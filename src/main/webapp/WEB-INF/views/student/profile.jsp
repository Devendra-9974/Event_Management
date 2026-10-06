<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile &bull; Arya College ClubSphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="stu-prof"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">My Student Profile</h3>
                <p class="text-muted small mb-0">Manage your personal information and contact details</p>
            </div>
        </div>

        <c:if test="${not empty param.message}">
            <div class="alert alert-success py-2 small alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-1"></i> ${param.message}
                <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row">
            <div class="col-lg-8">
                <div class="card card-custom p-4 p-md-5">
                    <form action="${pageContext.request.contextPath}/student/profile/update" method="post">
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Username</label>
                                <input type="text" class="form-control" value="${user.username}" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Assigned System Role</label>
                                <input type="text" class="form-control" value="${user.role}" readonly>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">Full Name</label>
                                <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold text-secondary">College Email Address</label>
                                <input type="email" name="email" class="form-control" value="${user.email}" required>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold text-secondary">Student ID / Roll No</label>
                                <input type="text" class="form-control" value="${user.studentId}" readonly>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold text-secondary">Phone Number</label>
                                <input type="text" name="phone" class="form-control" value="${user.phone}">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold text-secondary">Academic Year</label>
                                <select name="yearOfStudy" class="form-select">
                                    <option value="1st Year" ${user.yearOfStudy == '1st Year' ? 'selected' : ''}>1st Year</option>
                                    <option value="2nd Year" ${user.yearOfStudy == '2nd Year' ? 'selected' : ''}>2nd Year</option>
                                    <option value="3rd Year" ${user.yearOfStudy == '3rd Year' ? 'selected' : ''}>3rd Year</option>
                                    <option value="4th Year" ${user.yearOfStudy == '4th Year' ? 'selected' : ''}>4th Year</option>
                                    <option value="Faculty" ${user.yearOfStudy == 'Faculty' ? 'selected' : ''}>Faculty</option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-semibold text-secondary">Department / Branch</label>
                            <input type="text" name="department" class="form-control" value="${user.department}">
                        </div>

                        <button type="submit" class="btn btn-primary fw-semibold px-4">
                            <i class="bi bi-save me-1"></i> Update Profile
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
