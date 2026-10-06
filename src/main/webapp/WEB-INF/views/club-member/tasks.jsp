<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Assigned Tasks &bull; Club Member</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="mem-tasks"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">My Assigned Tasks</h3>
                <p class="text-muted small mb-0">Update execution status and report back to your Club Head</p>
            </div>
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
                            <th>Task Title & Brief</th>
                            <th>Club</th>
                            <th>Assigned By</th>
                            <th>Due Date</th>
                            <th>Priority</th>
                            <th>Status</th>
                            <th>Action: Update Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty tasks}">
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted">You have no tasks assigned to you currently.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="t" items="${tasks}">
                                    <tr>
                                        <td>
                                            <div class="fw-bold text-dark">${t.title}</div>
                                            <div class="small text-muted">${t.description}</div>
                                        </td>
                                        <td><span class="badge bg-light text-primary border">${t.clubName}</span></td>
                                        <td class="small text-secondary">${t.assignedByName}</td>
                                        <td class="small fw-semibold text-danger">${t.dueDate}</td>
                                        <td>
                                            <span class="badge ${t.priority == 'URGENT' ? 'bg-danger' : (t.priority == 'HIGH' ? 'bg-warning text-dark' : 'bg-secondary')}">
                                                ${t.priority}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge ${t.status == 'COMPLETED' ? 'badge-soft-success' : (t.status == 'IN_PROGRESS' ? 'badge-soft-primary' : 'badge-soft-warning')}">
                                                ${t.status}
                                            </span>
                                        </td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/club-member/task/update-status" method="post" class="d-flex gap-2">
                                                <input type="hidden" name="taskId" value="${t.id}">
                                                <select name="status" class="form-select form-select-sm" style="width: 130px;">
                                                    <option value="PENDING" ${t.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                                    <option value="IN_PROGRESS" ${t.status == 'IN_PROGRESS' ? 'selected' : ''}>IN_PROGRESS</option>
                                                    <option value="COMPLETED" ${t.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                                                </select>
                                                <button type="submit" class="btn btn-sm btn-primary py-0">Update</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
