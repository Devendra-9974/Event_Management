<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Monitor &bull; Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="admin-regs"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Registration Ledger</h3>
                <p class="text-muted small mb-0">System-wide event registrations and student ticketing status</p>
            </div>
            <span class="badge bg-primary px-3 py-2 rounded-pill fs-6">${registrations.size()} Total Registrations</span>
        </div>

        <div class="card card-custom p-0 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-custom align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Pass Reference</th>
                            <th>Student Name</th>
                            <th>Event & Organizing Club</th>
                            <th>Registration Type</th>
                            <th>Group Details</th>
                            <th>Date Registered</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${registrations}">
                            <tr>
                                <td><code class="fw-bold">${r.registrationNumber}</code></td>
                                <td>
                                    <div class="fw-bold text-dark">${r.studentName}</div>
                                    <div class="text-muted small">${r.studentEmail} &bull; ${r.studentIdCode}</div>
                                </td>
                                <td>
                                    <div class="fw-semibold text-dark">${r.eventTitle}</div>
                                    <div class="badge bg-light text-primary border small">${r.clubName}</div>
                                </td>
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
                                            <span class="text-muted small">Individual</span>
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
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
