<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications &bull; Arya College ClubSphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="fw-bold mb-1">Notifications & System Alerts</h3>
                    <p class="text-muted small mb-0">Updates on event registrations, task assignments, and club announcements</p>
                </div>
                <a href="${pageContext.request.contextPath}/notifications/mark-all-read" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-check2-all me-1"></i> Mark All as Read
                </a>
            </div>

            <div class="card card-custom p-0 overflow-hidden shadow-sm">
                <c:choose>
                    <c:when test="${empty notifications}">
                        <div class="p-5 text-center text-muted">
                            <i class="bi bi-bell-slash fs-1 mb-2"></i>
                            <h5>No notifications found.</h5>
                            <p class="small">You're completely up to date!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="list-group list-group-flush">
                            <c:forEach var="n" items="${notifications}">
                                <div class="list-group-item p-3 ${n.read ? 'opacity-75' : 'bg-light'} d-flex align-items-start gap-3" onclick="markNotificationRead(${n.id}, this)">
                                    <div class="p-2 rounded-circle mt-1 ${n.type == 'REGISTRATION_CONFIRMED' ? 'bg-success text-white' : (n.type == 'TASK_ASSIGNED' ? 'bg-warning text-dark' : 'bg-primary text-white')}">
                                        <i class="bi ${n.type == 'REGISTRATION_CONFIRMED' ? 'bi-check-circle' : (n.type == 'TASK_ASSIGNED' ? 'bi-list-task' : 'bi-bell')}"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <strong class="text-dark">${n.title}</strong>
                                            <span class="text-muted small" style="font-size: 0.75rem;">${n.createdAt}</span>
                                        </div>
                                        <p class="text-secondary small mb-1 mt-1">${n.message}</p>
                                        <c:if test="${not empty n.relatedEventId}">
                                            <a href="${pageContext.request.contextPath}/events?action=view&id=${n.relatedEventId}" class="small text-primary fw-semibold">View Event &rarr;</a>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
