<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login &bull; Arya College ClubSphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light d-flex align-items-center justify-content-center min-vh-100 py-5">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5 col-lg-4">
            
            <div class="text-center mb-4">
                <div class="d-inline-flex bg-primary text-white rounded-4 p-3 shadow mb-2">
                    <i class="bi bi-mortarboard-fill fs-2"></i>
                </div>
                <h3 class="fw-bold mb-1">ClubSphere</h3>
                <p class="text-muted small">Arya College of Engineering & IT</p>
            </div>

            <div class="card card-custom p-4 p-sm-5 shadow-sm">
                <h5 class="fw-bold text-dark mb-4 text-center">Sign In to Your Account</h5>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger py-2 small alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-circle-fill me-1"></i> ${errorMessage}
                        <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty param.error}">
                    <div class="alert alert-warning py-2 small alert-dismissible fade show" role="alert">
                        <i class="bi bi-info-circle-fill me-1"></i> ${param.error}
                        <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty param.message}">
                    <div class="alert alert-success py-2 small alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-1"></i> ${param.message}
                        <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold text-secondary">Username or College Email</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-person"></i></span>
                            <input type="text" name="username" class="form-control border-start-0" placeholder="e.g. admin or dev.kumar" required autofocus>
                        </div>
                    </div>

                    <div class="mb-4">
                        <div class="d-flex justify-content-between">
                            <label class="form-label small fw-semibold text-secondary">Password</label>
                        </div>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-lock"></i></span>
                            <input type="password" name="password" class="form-control border-start-0" placeholder="••••••••" required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold shadow-sm mb-3">
                        Sign In <i class="bi bi-arrow-right ms-1"></i>
                    </button>
                </form>

                <!-- Demo quick access helper -->
                <div class="mt-3 p-3 bg-light rounded-3 border small">
                    <div class="fw-bold text-secondary mb-2 text-uppercase" style="font-size: 0.7rem;">Quick Login Credentials:</div>
                    <div class="d-flex flex-column gap-1 text-muted" style="font-size: 0.8rem;">
                        <div><strong>Admin:</strong> <code>admin</code> / <code>password123</code></div>
                        <div><strong>Club Head:</strong> <code>head_coding</code> / <code>password123</code></div>
                        <div><strong>Club Member:</strong> <code>member_coding_1</code> / <code>password123</code></div>
                        <div><strong>Student:</strong> <code>student_1</code> / <code>password123</code></div>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/" class="text-decoration-none small text-muted">
                        <i class="bi bi-arrow-left me-1"></i> Back to Homepage
                    </a>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
