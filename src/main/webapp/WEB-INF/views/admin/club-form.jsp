<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty club ? 'Edit Club' : 'Create New Club'} &bull; Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="admin-clubs"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">${not empty club ? 'Edit Club Profile' : 'Register New College Club'}</h3>
                <p class="text-muted small mb-0">Configure metadata and faculty advisors for Arya College clubs</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/clubs" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i> Back to Clubs List
            </a>
        </div>

        <div class="card card-custom p-4 p-md-5">
            <form action="${pageContext.request.contextPath}/admin/club/save" method="post">
                <c:if test="${not empty club}">
                    <input type="hidden" name="id" value="${club.id}">
                </c:if>

                <div class="row g-3 mb-3">
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Unique Club Code</label>
                        <input type="text" name="clubCode" class="form-control" placeholder="e.g. ARYA-AI-DS" value="${club.clubCode}" required ${not empty club ? 'readonly' : ''}>
                    </div>
                    <div class="col-md-5">
                        <label class="form-label small fw-semibold text-secondary">Club Name</label>
                        <input type="text" name="name" class="form-control" placeholder="e.g. Artificial Intelligence Club" value="${club.name}" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-semibold text-secondary">Category</label>
                        <select name="category" class="form-select" required>
                            <option value="Technical" ${club.category == 'Technical' ? 'selected' : ''}>Technical</option>
                            <option value="Cultural" ${club.category == 'Cultural' ? 'selected' : ''}>Cultural</option>
                            <option value="Literary" ${club.category == 'Literary' ? 'selected' : ''}>Literary</option>
                            <option value="Creative" ${club.category == 'Creative' ? 'selected' : ''}>Creative</option>
                            <option value="Entrepreneurship" ${club.category == 'Entrepreneurship' ? 'selected' : ''}>Entrepreneurship</option>
                            <option value="Social Service" ${club.category == 'Social Service' ? 'selected' : ''}>Social Service</option>
                            <option value="Sports" ${club.category == 'Sports' ? 'selected' : ''}>Sports</option>
                            <option value="Science" ${club.category == 'Science' ? 'selected' : ''}>Science</option>
                            <option value="Wellness" ${club.category == 'Wellness' ? 'selected' : ''}>Wellness</option>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-semibold text-secondary">Description & Objectives</label>
                    <textarea name="description" class="form-control" rows="3" placeholder="Describe the mission, activities and target projects of this club...">${club.description}</textarea>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold text-secondary">Assign Club Head (Lead Coordinator)</label>
                        <select name="headUserId" class="form-select">
                            <option value="">-- No Club Head Assigned --</option>
                            <c:forEach var="h" items="${eligibleHeads}">
                                <option value="${h.id}" ${club.headUserId == h.id ? 'selected' : ''}>${h.fullName} (${h.username} - ${h.department})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold text-secondary">Faculty Advisor</label>
                        <input type="text" name="facultyAdvisor" class="form-control" placeholder="e.g. Dr. Senior Professor, CSE" value="${club.facultyAdvisor}">
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Contact Email</label>
                        <input type="email" name="contactEmail" class="form-control" placeholder="club@aryacollege.in" value="${club.contactEmail}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Contact Phone</label>
                        <input type="text" name="contactPhone" class="form-control" placeholder="+91 9829..." value="${club.contactPhone}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Primary Venue / Lab</label>
                        <input type="text" name="meetingVenue" class="form-control" placeholder="Lab Block C 102" value="${club.meetingVenue}">
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label small fw-semibold text-secondary">Club Status</label>
                    <select name="status" class="form-select" style="max-width: 200px;">
                        <option value="ACTIVE" ${club.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                        <option value="INACTIVE" ${club.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                    </select>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary fw-semibold px-4">
                        <i class="bi bi-save me-1"></i> Save Club Details
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/clubs" class="btn btn-outline-secondary">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </main>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
