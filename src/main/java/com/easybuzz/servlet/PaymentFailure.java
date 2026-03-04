package com.easybuzz.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/easebuzz/failure")
public class PaymentFailure extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status");
        String txnid = request.getParameter("txnid");

        response.setContentType("text/html");

        response.getWriter().println("<h2>Payment Failed</h2>");
        response.getWriter().println("Transaction ID: " + txnid + "<br>");
        response.getWriter().println("Status: " + status + "<br>");
    }
}