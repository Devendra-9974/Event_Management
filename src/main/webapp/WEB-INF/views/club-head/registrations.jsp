<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Registrations &bull; ${club.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="head-regs"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">${club.name} Registrations</h3>
                <p class="text-muted small mb-0">Monitor participant rosters and group teams across your club's events</p>
            </div>
            <button onclick="window.print()" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-printer me-1"></i> Print Roster
            </button>
        </div>

        <div class="card card-custom p-0 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-custom align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Pass No</th>
                            <th>Student</th>
                            <th>Event</th>
                            <th>Format</th>
                            <th>Group / Team Details</th>
                            <th>Registered Time</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty registrations}">
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted">No student registrations recorded yet.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${registrations}">
                                    <tr>
                                        <td><code>${r.registrationNumber}</code></td>
                                        <td>
                                            <div class="fw-bold text-dark">${r.studentName}</div>
                                            <div class="small text-muted">${r.studentEmail} &bull; ${r.studentIdCode}</div>
                                        </td>
                                        <td class="fw-semibold small">${r.eventTitle}</td>
                                        <td>
                                            <span class="badge ${r.registrationType == 'GROUP' ? 'bg-info' : 'bg-secondary'}">
                                                ${r.registrationType}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.registrationType == 'GROUP'}">
                                                    <strong>${r.groupName}</strong>
                                                    <div class="small text-muted">${r.groupSize} Members</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="small text-muted">Single Entry</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="small text-secondary">${r.registeredAt}</td>
                                        <td>
                                            <span class="badge ${r.status == 'CONFIRMED' ? 'badge-soft-success' : 'badge-soft-danger'}">
                                                ${r.status}
                                            </span>
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
