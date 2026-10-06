<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users &bull; Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="admin-users"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">User Directory & Roles</h3>
                <p class="text-muted small mb-0">Manage faculty, club leads, core members, and students</p>
            </div>
            <button class="btn btn-primary btn-sm fw-semibold" data-bs-toggle="modal" data-bs-target="#createUserModal">
                <i class="bi bi-person-plus-fill me-1"></i> Register New User
            </button>
        </div>

        <c:if test="${not empty param.message}">
            <div class="alert alert-success py-2 small alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-1"></i> ${param.message}
                <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Role Filter Tabs -->
        <div class="mb-3 d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm ${empty selectedRole or selectedRole == 'ALL' ? 'btn-primary' : 'btn-outline-secondary'}">All Users</a>
            <a href="${pageContext.request.contextPath}/admin/users?role=ADMIN" class="btn btn-sm ${selectedRole == 'ADMIN' ? 'btn-primary' : 'btn-outline-secondary'}">Admins</a>
            <a href="${pageContext.request.contextPath}/admin/users?role=CLUB_HEAD" class="btn btn-sm ${selectedRole == 'CLUB_HEAD' ? 'btn-primary' : 'btn-outline-secondary'}">Club Heads</a>
            <a href="${pageContext.request.contextPath}/admin/users?role=CLUB_MEMBER" class="btn btn-sm ${selectedRole == 'CLUB_MEMBER' ? 'btn-primary' : 'btn-outline-secondary'}">Club Members</a>
            <a href="${pageContext.request.contextPath}/admin/users?role=STUDENT" class="btn btn-sm ${selectedRole == 'STUDENT' ? 'btn-primary' : 'btn-outline-secondary'}">Students</a>
        </div>

        <div class="card card-custom p-0 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-custom align-middle mb-0">
                    <thead>
                        <tr>
                            <th>User Details</th>
                            <th>Student / Employee ID</th>
                            <th>Department</th>
                            <th>Current Role</th>
                            <th>Status</th>
                            <th>Action: Change Role</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td>
                                    <div class="fw-bold text-dark">${u.fullName}</div>
                                    <div class="small text-muted">@${u.username} &bull; ${u.email}</div>
                                </td>
                                <td><code>${u.studentId}</code></td>
                                <td class="small text-secondary">${u.department}</td>
                                <td>
                                    <span class="badge ${u.role == 'ADMIN' ? 'bg-danger' : (u.role == 'CLUB_HEAD' ? 'bg-warning text-dark' : (u.role == 'CLUB_MEMBER' ? 'bg-success' : 'bg-primary'))}">
                                        ${u.role}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge ${u.status == 'ACTIVE' ? 'badge-soft-success' : 'badge-soft-danger'}">${u.status}</span>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/user/change-role" method="post" class="d-flex gap-2">
                                        <input type="hidden" name="userId" value="${u.id}">
                                        <select name="newRole" class="form-select form-select-sm" style="width: 140px;">
                                            <option value="ADMIN" ${u.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                                            <option value="CLUB_HEAD" ${u.role == 'CLUB_HEAD' ? 'selected' : ''}>CLUB_HEAD</option>
                                            <option value="CLUB_MEMBER" ${u.role == 'CLUB_MEMBER' ? 'selected' : ''}>CLUB_MEMBER</option>
                                            <option value="STUDENT" ${u.role == 'STUDENT' ? 'selected' : ''}>STUDENT</option>
                                        </select>
                                        <button type="submit" class="btn btn-sm btn-outline-primary py-0">Update</button>
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

<!-- Create User Modal -->
<div class="modal fade" id="createUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Register New User</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/user/create" method="post">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Username</label>
                        <input type="text" name="username" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Full Name</label>
                        <input type="text" name="fullName" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Email Address</label>
                        <input type="email" name="email" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Initial Password</label>
                        <input type="password" name="password" class="form-control" value="password123" required>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Role</label>
                            <select name="role" class="form-select" required>
                                <option value="STUDENT">STUDENT</option>
                                <option value="CLUB_MEMBER">CLUB_MEMBER</option>
                                <option value="CLUB_HEAD">CLUB_HEAD</option>
                                <option value="ADMIN">ADMIN</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Student / Employee ID</label>
                            <input type="text" name="studentId" class="form-control" placeholder="23ARYACS..." required>
                        </div>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Phone</label>
                            <input type="text" name="phone" class="form-control">
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Department</label>
                            <input type="text" name="department" class="form-control" placeholder="Computer Science">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Create User Account</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
