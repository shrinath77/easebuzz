package com.easybuzz.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/success")
public class PaymentSuccess extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(PaymentSuccess.class.getName());

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("PaymentSuccess servlet called");
        
        String status = request.getParameter("status");
        String txnid = request.getParameter("txnid");
        String amount = request.getParameter("amount");
        String productinfo = request.getParameter("productinfo");
        String firstname = request.getParameter("firstname");
        String email = request.getParameter("email");
        
        LOGGER.info("Parameters - status: " + status + ", txnid: " + txnid + ", amount: " + amount);

        request.setAttribute("status", status);
        request.setAttribute("txnid", txnid);
        request.setAttribute("amount", amount);
        request.setAttribute("productinfo", productinfo);
        request.setAttribute("firstname", firstname);
        request.setAttribute("email", email);

        request.getRequestDispatcher("/success.jsp").forward(request, response);
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        doPost(req, res);
    }
}