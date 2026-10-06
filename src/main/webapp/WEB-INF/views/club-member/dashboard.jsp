<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Member Workspace &bull; Arya College ClubSphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="mem-dash"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Club Member Workspace</h3>
                <p class="text-muted small mb-0">Welcome back, <strong>${sessionScope.currentUser.fullName}</strong> &bull; Core Team Member</p>
            </div>
            <a href="${pageContext.request.contextPath}/club-member/tasks" class="btn btn-primary btn-sm fw-semibold">
                <i class="bi bi-list-check me-1"></i> View My Tasks
            </a>
        </div>

        <!-- Clubs I Belong To -->
        <div class="row g-4 mb-4">
            <div class="col-lg-6">
                <div class="card card-custom p-4 h-100">
                    <h5 class="fw-bold mb-3"><i class="bi bi-collection-fill text-primary me-2"></i> My Club Affiliations</h5>
                    <div class="d-flex flex-column gap-3">
                        <c:choose>
                            <c:when test="${empty memberClubs}">
                                <div class="text-muted small py-3">You are not registered in any core club team yet.</div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="mc" items="${memberClubs}">
                                    <div class="p-3 bg-light rounded-3 d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="fw-bold text-dark">${mc.clubName}</div>
                                            <div class="small text-muted">Role: <span class="badge bg-primary">${mc.memberRole}</span> &bull; Joined: ${mc.joinedDate}</div>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/clubs?action=view&id=${mc.clubId}" class="btn btn-outline-primary btn-sm">Club Page</a>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Pending Assigned Tasks -->
            <div class="col-lg-6">
                <div class="card card-custom p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0"><i class="bi bi-check2-circle text-warning me-2"></i> Action Items Assigned to Me</h5>
                        <a href="${pageContext.request.contextPath}/club-member/tasks" class="small fw-semibold text-primary">All Tasks &rarr;</a>
                    </div>
                    <div class="d-flex flex-column gap-3">
                        <c:choose>
                            <c:when test="${empty tasks}">
                                <div class="text-muted small py-3">No pending tasks assigned to you right now. Great job!</div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="t" items="${tasks}" begin="0" end="3">
                                    <div class="p-3 bg-light rounded-3 border">
                                        <div class="d-flex justify-content-between align-items-start mb-1">
                                            <strong class="text-dark small">${t.title}</strong>
                                            <span class="badge ${t.status == 'COMPLETED' ? 'badge-soft-success' : (t.status == 'IN_PROGRESS' ? 'badge-soft-primary' : 'badge-soft-warning')}">
                                                ${t.status}
                                            </span>
                                        </div>
                                        <div class="text-muted small mb-2">${t.description}</div>
                                        <div class="d-flex justify-content-between text-secondary small" style="font-size: 0.75rem;">
                                            <span>Club: <strong>${t.clubName}</strong></span>
                                            <span class="text-danger fw-semibold">Due: ${t.dueDate}</span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Upcoming College Events -->
        <div class="card card-custom p-4">
            <h5 class="fw-bold mb-3"><i class="bi bi-calendar-event-fill text-success me-2"></i> Upcoming College Events</h5>
            <div class="row g-3">
                <c:forEach var="e" items="${upcomingEvents}" begin="0" end="3">
                    <div class="col-md-6 col-lg-3">
                        <div class="p-3 border rounded-3 bg-light h-100 d-flex flex-column">
                            <span class="badge bg-white text-primary border align-self-start mb-2">${e.clubName}</span>
                            <h6 class="fw-bold mb-1">${e.title}</h6>
                            <div class="small text-muted mb-2">${e.eventDate}</div>
                            <div class="mt-auto">
                                <a href="${pageContext.request.contextPath}/events?action=view&id=${e.id}" class="btn btn-outline-primary btn-sm w-100">Details</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
