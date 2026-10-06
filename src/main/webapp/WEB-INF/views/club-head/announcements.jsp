<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Announcements &bull; ${club.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="head-announce"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">${club.name} Announcements</h3>
                <p class="text-muted small mb-0">Broadcast alerts to club members or the entire college campus</p>
            </div>
            <button class="btn btn-primary btn-sm fw-semibold" data-bs-toggle="modal" data-bs-target="#createAnnouncementModal">
                <i class="bi bi-megaphone-fill me-1"></i> New Announcement
            </button>
        </div>

        <c:if test="${not empty param.message}">
            <div class="alert alert-success py-2 small alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-1"></i> ${param.message}
                <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <c:choose>
                <c:when test="${empty announcements}">
                    <div class="col-12">
                        <div class="card card-custom p-5 text-center text-muted">
                            <i class="bi bi-megaphone fs-1 mb-2"></i>
                            <h5>No announcements published yet.</h5>
                            <p class="small">Publish your first broadcast notice to keep students updated.</p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="a" items="${announcements}">
                        <div class="col-md-6">
                            <div class="card card-custom p-4 h-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="badge ${a.priority == 'URGENT' ? 'bg-danger' : (a.priority == 'IMPORTANT' ? 'bg-warning text-dark' : 'bg-primary')}">
                                        ${a.priority}
                                    </span>
                                    <span class="badge bg-light text-secondary border small">
                                        <i class="bi bi-eye me-1"></i> Audience: ${a.targetRole}
                                    </span>
                                </div>
                                <h5 class="fw-bold text-dark mb-2">${a.title}</h5>
                                <p class="text-secondary small mb-3" style="white-space: pre-line;">${a.content}</p>
                                <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-auto small text-muted">
                                    <span>By: <strong>${a.createdByName}</strong></span>
                                    <span>${a.createdAt}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<!-- New Announcement Modal -->
<div class="modal fade" id="createAnnouncementModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Publish Club Announcement</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/club-head/announcement/create" method="post">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Announcement Title</label>
                        <input type="text" name="title" class="form-control" placeholder="e.g. Hackathon Registration Extension" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Content / Notice Text</label>
                        <textarea name="content" class="form-control" rows="4" placeholder="Write announcement details here..." required></textarea>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Priority Level</label>
                            <select name="priority" class="form-select">
                                <option value="NORMAL">NORMAL</option>
                                <option value="IMPORTANT">IMPORTANT</option>
                                <option value="URGENT">URGENT</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Target Audience</label>
                            <select name="targetRole" class="form-select">
                                <option value="ALL">Entire Campus (Public)</option>
                                <option value="MEMBERS_ONLY">Club Core Members Only</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Publish Announcement</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
