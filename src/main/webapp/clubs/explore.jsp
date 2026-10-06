<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Explore Clubs &bull; Arya College ClubSphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="container py-4">
    <!-- Header & Search/Filter Section -->
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
        <div>
            <h2 class="fw-bold mb-1">Explore College Clubs</h2>
            <p class="text-muted mb-0">Browse all 26 official societies and student organizations at Arya College</p>
        </div>
        <span class="badge bg-primary px-3 py-2 rounded-pill fs-6 fw-semibold align-self-start align-self-md-auto">
            ${totalCount} Clubs Listed
        </span>
    </div>

    <!-- Filter Form -->
    <div class="card card-custom p-3 mb-4">
        <form action="${pageContext.request.contextPath}/clubs" method="get" class="row g-2 align-items-center">
            <input type="hidden" name="action" value="explore">
            <div class="col-md-6 col-lg-7">
                <div class="input-group">
                    <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-search"></i></span>
                    <input type="text" name="search" class="form-control border-start-0" placeholder="Search clubs by name, code or keyword..." value="${keyword}">
                </div>
            </div>
            <div class="col-md-4 col-lg-3">
                <select name="category" class="form-select">
                    <option value="ALL">All Categories</option>
                    <option value="Technical" ${category == 'Technical' ? 'selected' : ''}>Technical & Coding</option>
                    <option value="Cultural" ${category == 'Cultural' ? 'selected' : ''}>Cultural & Arts</option>
                    <option value="Literary" ${category == 'Literary' ? 'selected' : ''}>Literary & Debating</option>
                    <option value="Creative" ${category == 'Creative' ? 'selected' : ''}>Creative & Design</option>
                    <option value="Entrepreneurship" ${category == 'Entrepreneurship' ? 'selected' : ''}>Entrepreneurship (E-Cell)</option>
                    <option value="Social Service" ${category == 'Social Service' ? 'selected' : ''}>Social Service (NSS / Eco)</option>
                    <option value="Sports" ${category == 'Sports' ? 'selected' : ''}>Sports & Athletics</option>
                    <option value="Science" ${category == 'Science' ? 'selected' : ''}>Science & Astronomy</option>
                    <option value="Wellness" ${category == 'Wellness' ? 'selected' : ''}>Wellness & Yoga</option>
                </select>
            </div>
            <div class="col-md-2 col-lg-2 d-flex gap-2">
                <button type="submit" class="btn btn-primary w-100 fw-semibold">Filter</button>
                <c:if test="${not empty keyword or (not empty category and category != 'ALL')}">
                    <a href="${pageContext.request.contextPath}/clubs" class="btn btn-outline-secondary" title="Reset filters"><i class="bi bi-arrow-counterclockwise"></i></a>
                </c:if>
            </div>
        </form>
    </div>

    <!-- 26 Clubs Grid -->
    <div class="row g-4">
        <c:forEach var="c" items="${clubs}">
            <div class="col-md-6 col-lg-4">
                <div class="card card-custom h-100 d-flex flex-column">
                    <div class="p-4 flex-grow-1">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div class="d-flex align-items-center gap-3">
                                <div class="bg-primary bg-opacity-10 text-primary rounded-3 p-3 fw-bold fs-4 d-flex align-items-center justify-content-center" style="width: 52px; height: 52px;">
                                    ${c.name.substring(0, 1)}
                                </div>
                                <div>
                                    <span class="badge bg-light text-secondary border small">${c.clubCode}</span>
                                    <div class="small text-muted">${c.category}</div>
                                </div>
                            </div>
                            <span class="badge ${c.status == 'ACTIVE' ? 'badge-soft-success' : 'badge-soft-danger'}">
                                ${c.status}
                            </span>
                        </div>

                        <h5 class="fw-bold mb-2 text-dark">${c.name}</h5>
                        <p class="text-muted small mb-3" style="min-height: 40px;">
                            <c:choose>
                                <c:when test="${c.description.length() > 110}">
                                    ${c.description.substring(0, 110)}...
                                </c:when>
                                <c:otherwise>
                                    ${c.description}
                                </c:otherwise>
                            </c:choose>
                        </p>

                        <div class="border-top pt-3 mt-auto">
                            <div class="row g-2 small text-secondary">
                                <div class="col-6">
                                    <i class="bi bi-person-badge me-1 text-primary"></i> 
                                    <strong>Lead:</strong> ${not empty c.headUserName ? c.headUserName : 'Unassigned'}
                                </div>
                                <div class="col-6 text-end">
                                    <i class="bi bi-people me-1 text-success"></i> 
                                    <strong>Members:</strong> ${c.memberCount}
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card-footer bg-white border-top p-3 d-flex justify-content-between align-items-center">
                        <span class="text-muted small">
                            <i class="bi bi-calendar-event me-1"></i> ${c.eventCount} Events
                        </span>
                        <a href="${pageContext.request.contextPath}/clubs?action=view&id=${c.id}" class="btn btn-outline-primary btn-sm fw-semibold px-3">
                            View Club <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
