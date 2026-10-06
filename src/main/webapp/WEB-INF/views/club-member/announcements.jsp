<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Announcements &bull; Member View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="mem-announce"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Campus & Club Announcements</h3>
                <p class="text-muted small mb-0">Official updates from club leads and event coordinators</p>
            </div>
        </div>

        <div class="row g-4">
            <c:forEach var="a" items="${announcements}">
                <div class="col-md-6">
                    <div class="card card-custom p-4 h-100">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <span class="badge ${a.priority == 'URGENT' ? 'bg-danger' : (a.priority == 'IMPORTANT' ? 'bg-warning text-dark' : 'bg-primary')}">${a.priority}</span>
                            <span class="badge bg-light text-primary border">${a.clubName}</span>
                        </div>
                        <h5 class="fw-bold text-dark mb-2">${a.title}</h5>
                        <p class="text-secondary small mb-3" style="white-space: pre-line;">${a.content}</p>
                        <div class="pt-3 border-top mt-auto small text-muted d-flex justify-content-between">
                            <span>By: <strong>${a.createdByName}</strong></span>
                            <span>${a.createdAt}</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </main>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
