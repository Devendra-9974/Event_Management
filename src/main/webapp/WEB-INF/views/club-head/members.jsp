<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Club Members &bull; ${club.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="head-members"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Club Members Roster</h3>
                <p class="text-muted small mb-0">Manage core team members, designations, and student onboarding for ${club.name}</p>
            </div>
            <button class="btn btn-primary btn-sm fw-semibold" data-bs-toggle="modal" data-bs-target="#addMemberModal">
                <i class="bi bi-person-plus-fill me-1"></i> Add New Member
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
                            <th>Member</th>
                            <th>Student ID</th>
                            <th>Department</th>
                            <th>Phone</th>
                            <th>Designation</th>
                            <th>Joined Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="m" items="${members}">
                            <tr>
                                <td>
                                    <div class="fw-bold text-dark">${m.userName}</div>
                                    <div class="small text-muted">${m.userEmail}</div>
                                </td>
                                <td><code>${m.studentId}</code></td>
                                <td class="small text-secondary">${m.department}</td>
                                <td class="small text-secondary">${m.phone}</td>
                                <td>
                                    <span class="badge ${m.memberRole == 'COORDINATOR' ? 'bg-primary' : 'bg-secondary'}">
                                        ${m.memberRole}
                                    </span>
                                </td>
                                <td class="small text-muted">${m.joinedDate}</td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/club-head/member/remove" method="post" onsubmit="return confirm('Remove member from club?');" class="d-inline">
                                        <input type="hidden" name="userId" value="${m.userId}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger" title="Remove Member">
                                            <i class="bi bi-person-x"></i>
                                        </button>
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

<!-- Add Member Modal -->
<div class="modal fade" id="addMemberModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Add Student to Club</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/club-head/member/add" method="post">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Select Student</label>
                        <select name="userId" class="form-select" required>
                            <option value="">-- Choose Student --</option>
                            <c:forEach var="s" items="${availableStudents}">
                                <option value="${s.id}">${s.fullName} (${s.studentId} - ${s.department})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Member Role</label>
                        <select name="memberRole" class="form-select" required>
                            <option value="MEMBER">MEMBER (Core Team)</option>
                            <option value="COORDINATOR">COORDINATOR (Team Lead)</option>
                            <option value="VICE_HEAD">VICE_HEAD</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Team Responsibilities / Notes</label>
                        <textarea name="notes" class="form-control" rows="2" placeholder="e.g. Social media lead, backend dev, logistics"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Add Member</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
