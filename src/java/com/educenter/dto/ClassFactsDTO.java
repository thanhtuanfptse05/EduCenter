package com.educenter.dto;

/** Actual operational projections; null means information has not been scheduled. */
public record ClassFactsDTO(long enrolledCount, String roomName, String scheduleText) { }
