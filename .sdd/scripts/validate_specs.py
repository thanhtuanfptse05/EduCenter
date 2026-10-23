"""Validate the SRS-derived specification inventory; never writes application data."""
from __future__ import annotations

import json
from pathlib import Path
import re
import sys
from urllib.parse import unquote


ROOT = Path(__file__).resolve().parents[2]
SPECS = ROOT / ".sdd" / "specs"
SOURCE = ROOT / "EduCenter_Tutoring_Exam_Preparation_SRS_v1.1.md"
ERRORS: list[str] = []


def require(condition: bool, message: str) -> None:
    if not condition:
        ERRORS.append(message)


def read(path: Path) -> str:
    if not path.is_file():
        ERRORS.append(f"Missing file: {path.relative_to(ROOT)}")
        return ""
    return path.read_text(encoding="utf-8-sig")


def source_inventory(text: str) -> tuple[dict, dict, list, set]:
    use_cases, screens, bullets, tables = {}, {}, [], set()
    module = None
    in_tables = False
    for line in text.splitlines():
        cells = [cell.strip() for cell in line.strip().strip("|").split("|")]
        if cells and re.fullmatch(r"UC\d{2}", cells[0]):
            use_cases[cells[0]] = cells
        if cells and re.fullmatch(r"(?:PUB|AUTH|ADM|TCH|STD|PAR|COM|SYS)-\d{2}", cells[0]):
            screens[cells[0]] = cells
        match = re.match(r"### (M\d{2}) ", line)
        if match:
            module = match[1]
        if line.startswith("## IV."):
            module = None
        if module and line.startswith("- "):
            bullets.append((module, line[2:]))
        if line.startswith("### 1. Danh sách 30 bảng"):
            in_tables = True
        elif in_tables and line.startswith("### 2."):
            in_tables = False
        if in_tables and len(cells) == 3 and cells[0] not in {"Nhóm", "---"}:
            tables.add(cells[1])
    return use_cases, screens, bullets, tables


def validate_links(path: Path, text: str) -> None:
    # Current baseline uses ordinary local markdown links without escaped spaces.
    for target in re.findall(r"\]\(([^)\n]+)\)", text):
        target = target.strip().strip("<>").split("#", 1)[0]
        if not target or re.match(r"[a-zA-Z][a-zA-Z0-9+.-]*:", target):
            continue
        resolved = (path.parent / unquote(target)).resolve()
        require(resolved.exists(), f"Broken link in {path.relative_to(ROOT)}: {target}")


def main() -> int:
    manifest = json.loads(read(SPECS / "catalog.json"))
    srs = read(SOURCE)
    source_uc, source_screens, source_bullets, source_tables = source_inventory(srs)
    features = {feature["id"]: feature for feature in manifest["features"]}
    require(len(features) == len(manifest["features"]), "Duplicate feature ID")
    require(len(features) == 15, "Expected 15 core features")
    require({m for f in features.values() for m in f["module"]} == {f"M{i:02d}" for i in range(1, 13)}, "Module coverage differs from M01-M12")
    docs: dict[Path, str] = {}
    requirement_count = 0
    feature_fr: dict[str, set[str]] = {}
    for feature in manifest["features"] + manifest["supporting"]:
        path = SPECS / feature["spec"]
        content = read(path)
        docs[path] = content
        ids = re.findall(r"^\| (FR-\d{3}) \|", content, re.MULTILINE)
        require(len(ids) == len(set(ids)), f"Duplicate FR: {feature['id']}")
        require(bool(ids), f"No functional requirements: {feature['id']}")
        if feature["id"] in features:
            feature_fr[feature["id"]] = set(ids)
            require(ids == feature["requirements"], f"Manifest/FR drift: {feature['id']}")
            requirement_count += len(ids)
        for section in ("Business Context & Scope", "User Scenarios & Testing", "Requirements", "Success Criteria", "Assumptions", "Dependencies & Handoff"):
            require(f"## {section}" in content, f"Missing section {section}: {feature['id']}")
        for field in ("**Status:** Locked", "**Independent Test:**", "**Acceptance Scenarios:**", "### Edge Cases", "### Key Entities", "SC-001"):
            require(field in content, f"Missing {field}: {feature['id']}")
        require(not re.search(r"\[NEEDS CLARIFICATION|\[FEATURE NAME\]|\[DATE\]|\$ARGUMENTS|\bTODO\b|TKTK", content), f"Unresolved placeholder: {feature['id']}")
        checklist = path.parent / "checklists" / "requirements.md"
        docs[checklist] = read(checklist)
        require("- [x]" in docs[checklist] and "- [ ]" not in docs[checklist], f"Incomplete spec quality checklist: {feature['id']}")
        for line in content.splitlines():
            if re.match(r"^\| FR-\d{3} \|", line):
                cells = [x.strip() for x in line.strip("|").split("|")]
                require(len(cells) == 4 and all(cells), f"Malformed FR/source/acceptance row: {feature['id']}: {line[:50]}")

    mapped_refs: dict[str, set[str]] = {key: set() for key in features}

    def check_refs(item: dict, label: str) -> None:
        key = item["feature"]
        require(key in features, f"Unknown feature in {label}: {key}")
        if key in features:
            refs = set(item["requirements"])
            require(bool(refs), f"No FR refs for {label}")
            require(refs <= feature_fr[key], f"Unknown FR in {label}: {sorted(refs - feature_fr[key])}")
            mapped_refs[key].update(refs)

    mapped_uc = {item["id"]: item for item in manifest["uc"]}
    require(len(mapped_uc) == len(manifest["uc"]), "Duplicate UC mapping")
    require(set(mapped_uc) == set(source_uc), "UC coverage differs from SRS")
    for key, item in mapped_uc.items():
        source = source_uc.get(key)
        if source:
            require((item["title"], item["priority"]) == (source[1], source[3]), f"UC title/priority drift: {key}")
        check_refs(item, key)
    p1 = sorted(item["id"] for item in mapped_uc.values() if item["priority"] == "P1")
    require(p1 == ["UC18", "UC21", "UC28", "UC35"], "P1 classification drift")
    require([(item["module"], item["source"]) for item in manifest["module_requirements"]] == source_bullets, "Module bullet source/order drift")
    bullet_ids = [item["id"] for item in manifest["module_requirements"]]
    require(len(bullet_ids) == len(set(bullet_ids)), "Duplicate module requirement ID")
    for item in manifest["module_requirements"]:
        check_refs(item, item["id"])
    for item in manifest.get("cross_feature_coverage", []):
        require(item["source"] in set(mapped_uc) | set(bullet_ids), f"Unknown cross-feature source: {item['source']}")
        check_refs(item, item["source"])
    # A FR may be cross-cutting; it must still have at least one source mapping.
    for key, ids in feature_fr.items():
        require(ids <= mapped_refs[key], f"Unmapped FR in {key}: {sorted(ids - mapped_refs[key])}")

    rules = manifest["business_rules"]
    require({item["id"] for item in rules} == {f"BR{i:02d}" for i in range(1, 21)}, "BR01-BR20 coverage gap")
    for rule in rules:
        require(bool(rule["features"]) and all(key in features for key in rule["features"]), f"Unmapped rule: {rule['id']}")
        for key in rule["features"]:
            require(rule["id"] in docs[SPECS / features[key]["spec"]], f"Rule missing in referenced feature: {rule['id']}/{key}")

    mapped_screens = {item["id"]: item for item in manifest["screens"]}
    require(len(mapped_screens) == len(manifest["screens"]), "Duplicate screen ID")
    require(set(mapped_screens) == set(source_screens), "Screen coverage differs from SRS")
    screen_text = read(SPECS / "screen-map.md")
    for key, item in mapped_screens.items():
        owners = [f["id"] for f in features.values() if key in f["screens"]]
        require(owners == [item["feature"]], f"Screen must have one core owner: {key}")
        require(f"| {key} |" in screen_text, f"Screen missing from readable map: {key}")
        require(item["view"].startswith("/WEB-INF/views/"), f"Unprotected JSP path: {key}")
    data_text = read(SPECS / "data-contract.md")
    mapped_tables = set(re.findall(r"^\| ([A-Za-z]+) \|", data_text, re.MULTILINE))
    require(source_tables <= mapped_tables, f"Missing SRS tables: {sorted(source_tables - mapped_tables)}")
    require(len(source_tables) == 30, f"Source table parse error: {len(source_tables)}")

    for path in SPECS.glob("*.md"):
        if path.name != "template.md":
            docs[path] = read(path)
    for relative in ("README.md", "design.md", "design (1).md", ".sdd/shared_context.md", ".sdd/future-work.md", "docs/database/DATABASE_DESIGN.md"):
        path = ROOT / relative
        docs[path] = read(path)
    for path in (SPECS / "modules").glob("*/module.md"):
        docs[path] = read(path)
    for path, content in docs.items():
        validate_links(path, content)
    if ERRORS:
        print("Specification validation FAILED:")
        for error in ERRORS:
            print(f"- {error}")
        return 1
    print("Specification validation PASSED (document structure and traceability only)")
    print(f"Core features: {len(features)}; supporting UI specs: {len(manifest['supporting'])}; core FRs: {requirement_count}")
    print(f"SRS coverage: 12/12 modules; {len(source_uc)}/35 UC (31 P0, 4 P1); {len(source_bullets)}/55 module bullets; {len(rules)}/20 BR")
    print(f"Data/screens: {len(source_tables)}/30 core tables; {len(mapped_screens)}/49 screens, one core owner each")
    print(f"Checked {len(docs)} markdown documents/checklists and their local links; runtime/UAT not executed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
