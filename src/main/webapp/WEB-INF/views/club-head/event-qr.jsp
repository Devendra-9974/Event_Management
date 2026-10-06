<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event QR Code &bull; ${event.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="head-events"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Official Event QR Code</h3>
                <p class="text-muted small mb-0">${event.title} &bull; ${club.name}</p>
            </div>
            <a href="${pageContext.request.contextPath}/club-head/events" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i> Back to Events
            </a>
        </div>

        <div class="row justify-content-center">
            <div class="col-md-7 col-lg-6">
                <div class="card card-custom p-4 p-md-5 text-center shadow-sm">
                    <span class="badge bg-primary bg-opacity-10 text-primary mx-auto mb-2 px-3 py-1 fw-semibold">${club.name}</span>
                    <h4 class="fw-bold mb-1">${event.title}</h4>
                    <p class="text-muted small mb-4">Print or display this QR code at campus notice boards, social handles, or lecture halls for direct student registration.</p>

                    <div class="qr-preview-box mb-4 p-4 bg-white border rounded-4 shadow-sm mx-auto" style="max-width: 320px;">
                        <img src="${pageContext.request.contextPath}/qr/${event.qrToken}" alt="Event Registration QR" class="img-fluid rounded mb-2" style="width: 250px; height: 250px;">
                        <div class="text-secondary small fw-semibold">Token: <code>${event.qrToken}</code></div>
                    </div>

                    <div class="d-flex flex-column gap-2">
                        <a href="${pageContext.request.contextPath}/qr/${event.qrToken}?download=true" class="btn btn-primary fw-semibold py-2">
                            <i class="bi bi-download me-2"></i> Download High-Res PNG
                        </a>
                        <button onclick="window.print()" class="btn btn-outline-secondary py-2">
                            <i class="bi bi-printer me-2"></i> Print Poster
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
