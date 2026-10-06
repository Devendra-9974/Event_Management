<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Club Head Dashboard &bull; ${club.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="head-dash"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div>
                <span class="badge bg-primary bg-opacity-10 text-primary mb-1 fw-semibold">${club.clubCode} &bull; ${club.category}</span>
                <h3 class="fw-bold mb-1">${club.name} Dashboard</h3>
                <p class="text-muted small mb-0">Managing your club members, tasks, events, and registrations</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/club-head/event/create" class="btn btn-primary btn-sm fw-semibold">
                    <i class="bi bi-plus-circle me-1"></i> Create Event
                </a>
                <button class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                    <i class="bi bi-gear me-1"></i> Edit Club Profile
                </button>
            </div>
        </div>

        <c:if test="${not empty param.message}">
            <div class="alert alert-success py-2 small alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-1"></i> ${param.message}
                <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Stat Cards -->
        <div class="row g-3 mb-4">
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon blue"><i class="bi bi-people-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${stats.totalMembers}</h4>
                        <span class="text-muted small">Active Members</span>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon purple"><i class="bi bi-calendar2-event-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${stats.upcomingEvents} / ${stats.totalEvents}</h4>
                        <span class="text-muted small">Upcoming Events</span>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon green"><i class="bi bi-ticket-detailed-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${stats.totalRegistrations}</h4>
                        <span class="text-muted small">Event Registrations</span>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon amber"><i class="bi bi-check2-square"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${stats.completedTasks} / ${stats.totalTasks}</h4>
                        <span class="text-muted small">Tasks Completed</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <!-- Active Events with QR code triggers -->
            <div class="col-lg-7">
                <div class="card card-custom p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0">Club Events</h5>
                        <a href="${pageContext.request.contextPath}/club-head/events" class="small fw-semibold text-primary">Manage All &rarr;</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-custom align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Date</th>
                                    <th>Registered</th>
                                    <th>Status</th>
                                    <th>QR Code</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="e" items="${events}">
                                    <tr>
                                        <td class="fw-bold text-dark">${e.title}</td>
                                        <td class="small text-secondary">${e.eventDate}</td>
                                        <td><span class="fw-semibold">${e.registeredCount} / ${e.capacity}</span></td>
                                        <td>
                                            <span class="badge ${e.status == 'REGISTRATION_OPEN' ? 'badge-soft-success' : 'badge-soft-warning'}">
                                                ${e.status}
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/club-head/event/qr?id=${e.id}" class="btn btn-sm btn-outline-primary py-0">
                                                <i class="bi bi-qr-code me-1"></i> QR Code
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Urgent Tasks assigned to members -->
            <div class="col-lg-5">
                <div class="card card-custom p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0">Member Task Tracking</h5>
                        <a href="${pageContext.request.contextPath}/club-head/tasks" class="small fw-semibold text-primary">All Tasks &rarr;</a>
                    </div>
                    <div class="d-flex flex-column gap-3">
                        <c:forEach var="t" items="${tasks}" begin="0" end="4">
                            <div class="p-3 bg-light rounded-3 border">
                                <div class="d-flex justify-content-between align-items-start mb-1">
                                    <strong class="text-dark small">${t.title}</strong>
                                    <span class="badge ${t.status == 'COMPLETED' ? 'badge-soft-success' : (t.status == 'IN_PROGRESS' ? 'badge-soft-primary' : 'badge-soft-warning')}">
                                        ${t.status}
                                    </span>
                                </div>
                                <div class="d-flex justify-content-between text-muted small" style="font-size: 0.78rem;">
                                    <span>Assigned to: <strong>${t.assignedToName}</strong></span>
                                    <span>Due: ${t.dueDate}</span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

    </main>
</div>

<!-- Edit Club Profile Modal -->
<div class="modal fade" id="editProfileModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Update Club Profile</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/club-head/profile/update" method="post">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Description</label>
                        <textarea name="description" class="form-control" rows="3">${club.description}</textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Faculty Advisor</label>
                        <input type="text" name="facultyAdvisor" class="form-control" value="${club.facultyAdvisor}">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Contact Email</label>
                        <input type="email" name="contactEmail" class="form-control" value="${club.contactEmail}">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Contact Phone</label>
                        <input type="text" name="contactPhone" class="form-control" value="${club.contactPhone}">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Meeting Venue / Lab</label>
                        <input type="text" name="meetingVenue" class="form-control" value="${club.meetingVenue}">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
