<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Monitor All Events &bull; Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="admin-events"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Campus Event Monitor</h3>
                <p class="text-muted small mb-0">Live audit of events scheduled across all 26 Arya College clubs</p>
            </div>
        </div>

        <div class="card card-custom p-0 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-custom align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Event Title</th>
                            <th>Host Club</th>
                            <th>Date & Time</th>
                            <th>Venue</th>
                            <th>Capacity & Registrations</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="e" items="${events}">
                            <tr>
                                <td>
                                    <div class="fw-bold text-dark">${e.title}</div>
                                    <span class="badge bg-light text-secondary border small">${e.eventType} &bull; ${e.participationType}</span>
                                </td>
                                <td><span class="badge bg-primary bg-opacity-10 text-primary">${e.clubName}</span></td>
                                <td>
                                    <div class="fw-semibold small">${e.eventDate}</div>
                                    <div class="text-muted small">${e.startTime} - ${e.endTime}</div>
                                </td>
                                <td class="small text-secondary">${e.venue}</td>
                                <td>
                                    <div class="progress" style="height: 6px; width: 120px;">
                                        <div class="progress-bar bg-success" style="width: ${(e.registeredCount / e.capacity) * 100}%"></div>
                                    </div>
                                    <span class="small text-muted">${e.registeredCount} / ${e.capacity}</span>
                                </td>
                                <td>
                                    <span class="badge ${e.status == 'REGISTRATION_OPEN' ? 'badge-soft-success' : (e.status == 'CANCELLED' ? 'badge-soft-danger' : 'badge-soft-warning')}">
                                        ${e.status}
                                    </span>
                                </td>
                                <td>
                                    <div class="d-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/events?action=view&id=${e.id}" class="btn btn-sm btn-outline-primary" target="_blank" title="View Event">
                                            <i class="bi bi-box-arrow-up-right"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/qr/${e.qrToken}?download=true" class="btn btn-sm btn-outline-secondary" title="Download QR">
                                            <i class="bi bi-qr-code"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
