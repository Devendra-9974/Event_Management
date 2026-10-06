<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage All 26 Clubs &bull; Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="admin-clubs"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Manage All 26 College Clubs</h3>
                <p class="text-muted small mb-0">Configure club metadata, assign club leads, and toggle status</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/club/create" class="btn btn-primary fw-semibold btn-sm">
                <i class="bi bi-plus-lg me-1"></i> Add New Club
            </a>
        </div>

        <c:if test="${not empty param.message}">
            <div class="alert alert-success py-2 small alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-1"></i> ${param.message}
                <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="card card-custom p-0 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-custom align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Club Code & Name</th>
                            <th>Category</th>
                            <th>Assigned Club Head</th>
                            <th>Faculty Advisor</th>
                            <th>Members</th>
                            <th>Events</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${clubs}">
                            <tr>
                                <td>
                                    <div class="fw-bold text-dark">${c.name}</div>
                                    <code class="text-muted small">${c.clubCode}</code>
                                </td>
                                <td><span class="badge bg-light text-secondary border">${c.category}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty c.headUserName}">
                                            <div class="fw-semibold text-primary small">${c.headUserName}</div>
                                            <div class="text-muted small" style="font-size: 0.75rem;">${c.headUserEmail}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning bg-opacity-10 text-warning">Unassigned</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="small text-secondary">${c.facultyAdvisor}</td>
                                <td><span class="fw-bold">${c.memberCount}</span></td>
                                <td><span class="fw-bold">${c.eventCount}</span></td>
                                <td>
                                    <span class="badge ${c.status == 'ACTIVE' ? 'badge-soft-success' : 'badge-soft-danger'}">
                                        ${c.status}
                                    </span>
                                </td>
                                <td>
                                    <div class="d-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/admin/club/edit?id=${c.id}" class="btn btn-sm btn-outline-primary" title="Edit Club">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <form action="${pageContext.request.contextPath}/admin/club/toggle-status" method="post" class="d-inline" onsubmit="return confirm('Toggle status for this club?');">
                                            <input type="hidden" name="id" value="${c.id}">
                                            <input type="hidden" name="currentStatus" value="${c.status}">
                                            <button type="submit" class="btn btn-sm ${c.status == 'ACTIVE' ? 'btn-outline-danger' : 'btn-outline-success'}" title="${c.status == 'ACTIVE' ? 'Deactivate' : 'Activate'}">
                                                <i class="bi ${c.status == 'ACTIVE' ? 'bi-slash-circle' : 'bi-check-circle'}"></i>
                                            </button>
                                        </form>
                                        <a href="${pageContext.request.contextPath}/clubs?action=view&id=${c.id}" target="_blank" class="btn btn-sm btn-outline-secondary" title="View Public Page">
                                            <i class="bi bi-box-arrow-up-right"></i>
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
