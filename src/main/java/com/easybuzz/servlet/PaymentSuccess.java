package com.easybuzz.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
@WebServlet("/success")
public class PaymentSuccess extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status");
        String txnid = request.getParameter("txnid");
        String amount = request.getParameter("amount");

        response.setContentType("text/html");

        response.getWriter().println("<h2>Payment Successful</h2>");
        response.getWriter().println("Transaction ID: " + txnid + "<br>");
        response.getWriter().println("Amount: " + amount + "<br>");
        response.getWriter().println("Status: " + status + "<br>");
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        doPost(req, res);
    }
}