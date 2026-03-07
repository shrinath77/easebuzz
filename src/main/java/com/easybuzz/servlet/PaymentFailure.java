package com.easybuzz.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/failure")
public class PaymentFailure extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(PaymentFailure.class.getName());

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("PaymentFailure servlet called");
        
        String status = request.getParameter("status");
        String txnid = request.getParameter("txnid");
        String amount = request.getParameter("amount");
        String error = request.getParameter("error");
        
        LOGGER.info("Parameters - status: " + status + ", txnid: " + txnid + ", amount: " + amount + ", error: " + error);

        // Set attributes for JSP
        request.setAttribute("status", status);
        request.setAttribute("txnid", txnid);
        request.setAttribute("amount", amount);
        request.setAttribute("error", error);

        // Forward to failure JSP
        request.getRequestDispatcher("/failure.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        doPost(request, response);
    }
}
