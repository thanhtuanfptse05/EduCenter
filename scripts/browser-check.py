"""Local browser regression checks. Requires Python Playwright and Chrome."""
from pathlib import Path
import json
import os
from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parent.parent
BASE = os.environ.get('EDUCENTER_TEST_URL', 'http://127.0.0.1:18080/EduCenter')
OUT = ROOT / 'build/repair/screenshots'
OUT.mkdir(parents=True, exist_ok=True)
report = []
with sync_playwright() as playwright:
    browser = playwright.chromium.launch(
        executable_path='C:/Program Files/Google/Chrome/Application/chrome.exe',
        headless=True, args=['--disable-gpu', '--no-first-run'])
    for width, height in [(1440, 1000), (1024, 900), (768, 1024), (360, 900)]:
        context = browser.new_context(viewport={'width': width, 'height': height}, color_scheme='dark')
        page = context.new_page()
        errors = []
        page.on('pageerror', lambda error: errors.append(str(error)))
        page.goto(BASE + '/courses', wait_until='networkidle')
        detail = page.locator('a[href*="/courses/detail?id="]').first.get_attribute('href')
        detail_path = detail.split('/EduCenter', 1)[1]
        page.locator('form[action$="/registration-cart/add"] button').first.click()
        page.wait_for_load_state('networkidle')
        paths = ['/', '/courses', detail_path, '/registration-cart', '/registration/confirm', '/login', '/register', '/forgot-password', '/reset-password?token=' + '0' * 64]
        for path in paths:
            response = page.goto(BASE + path, wait_until='networkidle')
            assert response.status == 200, (width, path, response.status)
            assert page.locator('[data-shared-public-header]').count() == 1
            assert page.locator('html').get_attribute('data-theme') == 'light'
            dimensions = page.evaluate('({viewport:innerWidth, content:document.documentElement.scrollWidth})')
            assert dimensions['content'] <= width, (width, path, dimensions)
            assert not errors, errors
            if path == '/':
                assert page.locator('.portal-hero').bounding_box()['y'] == 68
                primary = page.locator('.hero-btn-group .btn-primary')
                primary.hover()
                assert primary.evaluate('(element) => getComputedStyle(element).color !== getComputedStyle(element).backgroundColor')
                page.screenshot(path=str(OUT / f'home-{width}.png'))
                for href in page.locator('.site-header a[href*="#"], .site-footer a[href*="#"]').evaluate_all('(links) => links.map(link => link.getAttribute("href"))'):
                    assert page.locator('[id="' + href.split('#', 1)[1] + '"]').count() == 1, href
            if width < 1200:
                button = page.locator('.site-menu-button')
                button.click()
                assert button.get_attribute('aria-expanded') == 'true'
                page.keyboard.press('Escape')
                assert button.get_attribute('aria-expanded') == 'false'
        # User choice persists across navigation, including system dark preference.
        page.locator('[data-theme-toggle]').first.click()
        assert page.locator('html').get_attribute('data-theme') == 'dark'
        page.goto(BASE + '/courses', wait_until='networkidle')
        assert page.locator('html').get_attribute('data-theme') == 'dark'
        page.screenshot(path=str(OUT / f'courses-dark-{width}.png'), full_page=True)
        if os.environ.get('EDUCENTER_TEST_ACCOUNTS') == '1':
            # These accounts exist only in the disposable SqlServerFixture database.
            for account, dashboard in [('student', '/student/dashboard'), ('admin', '/admin/dashboard')]:
                page.goto(BASE + '/login', wait_until='networkidle')
                page.locator('input[name=email]').fill(account + '@verification.invalid')
                page.locator('input[name=password]').fill('VerificationPass17')
                page.locator('form[action$="/login"] button[type=submit]').click()
                page.wait_for_load_state('networkidle')
                for path in [dashboard, '/profile'] + (['/admin/users'] if account == 'admin' else []):
                    response = page.goto(BASE + path, wait_until='networkidle')
                    assert response.status == 200, (width, account, path)
                    assert page.evaluate('document.documentElement.scrollWidth') <= width, (width, account, path, 'overflow')
                    if width <= 1024:
                        button = page.locator('[data-app-menu]')
                        button.click()
                        assert button.get_attribute('aria-expanded') == 'true'
                        assert page.locator('.admin-sidebar').is_visible()
                        page.keyboard.press('Escape')
                        assert button.get_attribute('aria-expanded') == 'false'
                    if path == '/admin/users':
                        page.locator('[data-role-editor]').first.click()
                        assert page.locator('#roleModal').is_visible()
                        assert page.locator('#roleModal input[name=roles]').count() == 5
                        page.locator('#roleModal [data-modal-close]').first.click()
                    assert not errors, errors
                page.goto(BASE + '/logout', wait_until='networkidle')
                assert page.locator('[data-shared-public-header]').count() == 1
                page.locator('form[action$="/logout"] button[type=submit]').click()
                page.wait_for_load_state('networkidle')
            report.append({'width': width, 'internalPages': 5, 'drawer': 'passed'})
        report.append({'width': width, 'routes': len(paths), 'overflow': False, 'javascriptErrors': errors, 'themes': 'passed'})
        context.close()
    browser.close()
(OUT / 'browser-results.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
print(json.dumps(report, indent=2))
