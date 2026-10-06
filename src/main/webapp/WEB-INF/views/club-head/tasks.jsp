<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Management &bull; ${club.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="head-tasks"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Club Member Tasks</h3>
                <p class="text-muted small mb-0">Assign tasks, coordinate event workflows, and track completion</p>
            </div>
            <button class="btn btn-primary btn-sm fw-semibold" data-bs-toggle="modal" data-bs-target="#createTaskModal">
                <i class="bi bi-plus-lg me-1"></i> Assign New Task
            </button>
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
                            <th>Task Title & Details</th>
                            <th>Assigned Member</th>
                            <th>Related Event</th>
                            <th>Due Date</th>
                            <th>Priority</th>
                            <th>Status</th>
                            <th>Change Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="t" items="${tasks}">
                            <tr>
                                <td>
                                    <div class="fw-bold text-dark">${t.title}</div>
                                    <div class="small text-muted">${t.description}</div>
                                </td>
                                <td>
                                    <div class="fw-semibold small">${t.assignedToName}</div>
                                    <div class="text-muted small" style="font-size: 0.75rem;">${t.assignedToEmail}</div>
                                </td>
                                <td class="small text-secondary">
                                    ${not empty t.eventTitle ? t.eventTitle : '<span class=\"text-muted\">General Club Task</span>'}
                                </td>
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
                                    <form action="${pageContext.request.contextPath}/club-head/task/update-status" method="post" class="d-flex gap-2">
                                        <input type="hidden" name="taskId" value="${t.id}">
                                        <select name="status" class="form-select form-select-sm" style="width: 130px;">
                                            <option value="PENDING" ${t.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                            <option value="IN_PROGRESS" ${t.status == 'IN_PROGRESS' ? 'selected' : ''}>IN_PROGRESS</option>
                                            <option value="COMPLETED" ${t.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                                        </select>
                                        <button type="submit" class="btn btn-sm btn-outline-primary py-0">Save</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<!-- Assign Task Modal -->
<div class="modal fade" id="createTaskModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Assign Member Task</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/club-head/task/create" method="post">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Task Title</label>
                        <input type="text" name="title" class="form-control" placeholder="e.g. Venue setup, poster design, kit procurement" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Task Description</label>
                        <textarea name="description" class="form-control" rows="2" placeholder="Specific guidelines and deliverables..."></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Assign to Member</label>
                        <select name="assignedToUserId" class="form-select" required>
                            <option value="">-- Choose Club Member --</option>
                            <c:forEach var="m" items="${members}">
                                <option value="${m.userId}">${m.userName} (${m.memberRole})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Related Event (Optional)</label>
                            <select name="eventId" class="form-select">
                                <option value="">General Club Task</option>
                                <c:forEach var="e" items="${events}">
                                    <option value="${e.id}">${e.title}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Due Date</label>
                            <input type="date" name="dueDate" class="form-control" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Priority</label>
                        <select name="priority" class="form-select">
                            <option value="LOW">LOW</option>
                            <option value="MEDIUM" selected>MEDIUM</option>
                            <option value="HIGH">HIGH</option>
                            <option value="URGENT">URGENT</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Assign Task</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
