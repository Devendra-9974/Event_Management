<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Arya College ClubSphere &bull; Centralized Club & Event Platform</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<!-- Hero Section -->
<div class="container my-5">
    <div class="hero-banner p-4 p-md-5 mb-5 shadow-sm">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <span class="badge bg-primary px-3 py-2 rounded-pill fw-semibold mb-3">Official Arya Campus Portal</span>
                <h1 class="display-5 fw-bold mb-3">Arya College ClubSphere</h1>
                <p class="lead text-light opacity-75 mb-4">
                    The centralized nexus connecting students across <strong>26 college clubs</strong>.
                    Discover hackathons, cultural fests, workshops, team up with peers, and register seamlessly with smart QR codes.
                </p>
                <div class="d-flex flex-wrap gap-3">
                    <a href="${pageContext.request.contextPath}/clubs" class="btn btn-primary btn-lg px-4 fw-semibold shadow">
                        <i class="bi bi-grid-3x3-gap-fill me-2"></i> Explore 26 Clubs
                    </a>
                    <a href="${pageContext.request.contextPath}/events" class="btn btn-outline-light btn-lg px-4 fw-semibold">
                        <i class="bi bi-calendar-check me-2"></i> View Upcoming Events
                    </a>
                    <c:if test="${empty sessionScope.currentUser}">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-light btn-lg px-4 fw-semibold text-dark">
                            <i class="bi bi-box-arrow-in-right me-2"></i> Student & Staff Login
                        </a>
                    </c:if>
                </div>
            </div>
            <div class="col-lg-4 d-none d-lg-block text-center">
                <div class="p-4 bg-white bg-opacity-10 rounded-4 border border-white border-opacity-25 shadow-lg">
                    <div class="display-3 fw-bold text-warning mb-1">26</div>
                    <div class="text-uppercase fw-semibold tracking-wider text-light mb-3">Active Campus Clubs</div>
                    <div class="hr border-white opacity-25 mb-3"></div>
                    <div class="text-start small text-light opacity-75">
                        <div class="mb-2"><i class="bi bi-check-circle-fill text-success me-2"></i> Technical & Coding Societies</div>
                        <div class="mb-2"><i class="bi bi-check-circle-fill text-success me-2"></i> Cultural, Drama & Music</div>
                        <div class="mb-2"><i class="bi bi-check-circle-fill text-success me-2"></i> Robotics, AI & Cyber Labs</div>
                        <div><i class="bi bi-check-circle-fill text-success me-2"></i> Entrepreneurship, Sports & NSS</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Highlights -->
    <div class="row g-4 mb-5">
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon blue"><i class="bi bi-collection-fill"></i></div>
                <div>
                    <h3 class="fw-bold mb-0">26</h3>
                    <span class="text-muted small">Campus Clubs</span>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon purple"><i class="bi bi-calendar2-event-fill"></i></div>
                <div>
                    <h3 class="fw-bold mb-0">National</h3>
                    <span class="text-muted small">Hackathons & Fests</span>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon green"><i class="bi bi-qr-code-scan"></i></div>
                <div>
                    <h3 class="fw-bold mb-0">Smart QR</h3>
                    <span class="text-muted small">Fast Registration</span>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon amber"><i class="bi bi-shield-lock-fill"></i></div>
                <div>
                    <h3 class="fw-bold mb-0">4 Roles</h3>
                    <span class="text-muted small">RBAC Secured</span>
                </div>
            </div>
        </div>
    </div>

    <!-- 4 Role Overview Cards -->
    <div class="mb-5">
        <div class="text-center mb-4">
            <h3 class="fw-bold">Platform Capabilities for Every Role</h3>
            <p class="text-muted">Designed specifically for Arya College of Engineering & IT administrators, coordinators, and students.</p>
        </div>
        <div class="row g-4">
            <div class="col-md-6 col-lg-3">
                <div class="card card-custom h-100 p-4">
                    <div class="d-inline-flex p-3 bg-primary bg-opacity-10 text-primary rounded-3 mb-3" style="width: fit-content;">
                        <i class="bi bi-person-fill-gear fs-3"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Admin / Professor</h5>
                    <p class="text-muted small mb-3">Complete oversight of all 26 clubs, head assignments, system users, analytics, and event registrations.</p>
                    <span class="badge badge-soft-primary align-self-start">Full Control</span>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="card card-custom h-100 p-4">
                    <div class="d-inline-flex p-3 bg-warning bg-opacity-10 text-warning rounded-3 mb-3" style="width: fit-content;">
                        <i class="bi bi-person-workspace fs-3"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Club Head</h5>
                    <p class="text-muted small mb-3">Organize events, generate registration QR codes, assign member tasks, publish club notices, and review reports.</p>
                    <span class="badge badge-soft-warning align-self-start">Club Isolated</span>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="card card-custom h-100 p-4">
                    <div class="d-inline-flex p-3 bg-success bg-opacity-10 text-success rounded-3 mb-3" style="width: fit-content;">
                        <i class="bi bi-people-fill fs-3"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Club Member</h5>
                    <p class="text-muted small mb-3">Access member workspace, fulfill assigned preparation tasks, update workflow progress, and review club activities.</p>
                    <span class="badge badge-soft-success align-self-start">Task Tracking</span>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="card card-custom h-100 p-4">
                    <div class="d-inline-flex p-3 bg-info bg-opacity-10 text-info rounded-3 mb-3" style="width: fit-content;">
                        <i class="bi bi-mortarboard fs-3"></i>
                    </div>
                    <h5 class="fw-bold mb-2">Student</h5>
                    <p class="text-muted small mb-3">Browse all 26 clubs, register for individual or group events, scan QR codes on campus, and view tickets.</p>
                    <span class="badge badge-soft-info align-self-start">Self Service</span>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
