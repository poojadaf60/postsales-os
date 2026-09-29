package com.org;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

@WebFilter(urlPatterns = {
    "/DashboardServlet",
    "/FlatManagementServlet",
    "/AllotteeManagementServlet",
    "/BookingManagementServlet",
    "/PaymentManagementServlet",
    "/DocumentServlet",
    "/TicketServlet",
    "/SnagServlet",
    "/ConstructionServlet",
    "/PossessionServlet",
    "/ReportServlet",
    "/Setting.jsp",
    "/AddFlatServlet",
    "/AddAllotteeServlet",
    "/BookingServlet",
    "/EditAllotteeServlet",
    "/EditFlatServlet",
    "/EditBookingServlet",
    "/EditPaymentServlet",
    "/DeleteAllotteeServlet",
    "/DeleteFlatServlet",
    "/DeleteBookingServlet",
    "/DeleteDocumentServlet",
    "/DeletePaymentServlet",
    "/TicketUpdateServlet",
    "/SnagUpdateServlet",
    "/UpdateBookingServlet",
    "/UpdatePaymentServlet",
    "/DocumentUploadServlet",
    "/DocumentDownloadServlet",
    "/ChangePasswordServlet"
})
public class AuthFilter implements Filter {

    public void init(FilterConfig filterConfig) {}

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("Loginindex.jsp");
            return;
        }

        chain.doFilter(req, res);
    }

    public void destroy() {}
}