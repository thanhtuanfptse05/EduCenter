package com.educenter.dto;

public record PasswordResetStateDTO(boolean valid, long remainingSeconds) {
    public boolean isValid() { return valid; }
    public long getRemainingSeconds() { return remainingSeconds; }
}
