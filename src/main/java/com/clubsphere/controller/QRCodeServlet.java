package com.clubsphere.controller;

import com.clubsphere.model.Event;
import com.clubsphere.service.EventService;
import com.clubsphere.util.DBUtil;
import com.clubsphere.util.QRCodeUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/qr/*")
public class QRCodeServlet extends HttpServlet {
    private final EventService eventService = new EventService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo(); // e.g. /event/{token}
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "QR token missing");
            return;
        }

        String token = pathInfo.replace("/", "").trim();
        Event event = eventService.getEventByQrToken(token);
        if (event == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Event not found for this QR token");
            return;
        }

        // Construct the full absolute registration URL
        String baseUrl = DBUtil.getProperty("app.base.url", "http://localhost:8080/aryaClgClubSphere").trim();
        if (baseUrl.endsWith("/")) {
            baseUrl = baseUrl.substring(0, baseUrl.length() - 1);
        }
        String registrationUrl = baseUrl + "/event/register?token=" + event.getQrToken();

        boolean download = "true".equalsIgnoreCase(req.getParameter("download"));
        try {
            byte[] qrBytes = QRCodeUtil.generateQRCodePNG(registrationUrl, 320, 320);

            resp.setContentType("image/png");
            resp.setContentLength(qrBytes.length);
            if (download) {
                resp.setHeader("Content-Disposition", "attachment; filename=\"qr_" + event.getQrToken() + ".png\"");
            }

            try (OutputStream out = resp.getOutputStream()) {
                out.write(qrBytes);
                out.flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating QR Code");
        }
    }
}
