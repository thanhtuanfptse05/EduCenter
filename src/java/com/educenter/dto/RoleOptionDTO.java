package com.educenter.dto;

import java.io.Serializable;

/** Persisted role choice for administrative filters and editors. */
public final class RoleOptionDTO implements Serializable {
    private static final long serialVersionUID = 1L;
    private final String code;
    private final String name;
    public RoleOptionDTO(String code, String name) { this.code = code; this.name = name; }
    public String getCode() { return code; }
    public String getName() { return name; }
}
