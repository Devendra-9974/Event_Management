<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Club Events &bull; Member View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="mem-events"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Upcoming Events Schedule</h3>
                <p class="text-muted small mb-0">Stay informed on events scheduled across Arya College</p>
            </div>
        </div>

        <div class="row g-4">
            <c:forEach var="e" items="${events}">
                <div class="col-md-6 col-lg-4">
                    <div class="card card-custom h-100 p-4 d-flex flex-column">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="badge bg-light text-primary border">${e.clubName}</span>
                            <span class="badge ${e.status == 'REGISTRATION_OPEN' ? 'badge-soft-success' : 'badge-soft-warning'}">${e.status}</span>
                        </div>
                        <h5 class="fw-bold text-dark mb-2">${e.title}</h5>
                        <p class="text-muted small mb-3 flex-grow-1">${e.description}</p>
                        <div class="small text-secondary mb-3">
                            <div><i class="bi bi-calendar3 me-2 text-primary"></i> ${e.eventDate}</div>
                            <div><i class="bi bi-geo-alt me-2 text-danger"></i> ${e.venue}</div>
                            <div><i class="bi bi-people me-2 text-info"></i> Registered: ${e.registeredCount} / ${e.capacity}</div>
                        </div>
                        <a href="${pageContext.request.contextPath}/events?action=view&id=${e.id}" class="btn btn-outline-primary btn-sm w-100">View Event Page</a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </main>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
