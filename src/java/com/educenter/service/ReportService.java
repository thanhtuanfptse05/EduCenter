package com.educenter.service;

import com.educenter.dto.AdminDashboardDTO;
import com.educenter.dto.DetailedReportDTO;
import com.educenter.dto.ReportFilterDTO;

public interface ReportService {

    AdminDashboardDTO getAdminDashboardData();

    DetailedReportDTO getDetailedReport(ReportFilterDTO filter);
}
