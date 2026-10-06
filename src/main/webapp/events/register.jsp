<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Registration &bull; ${event.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card card-custom p-4 p-md-5 mb-4">
                
                <div class="border-bottom pb-3 mb-4">
                    <span class="badge bg-primary bg-opacity-10 text-primary mb-2">${event.clubName}</span>
                    <h3 class="fw-bold mb-1">Registration: ${event.title}</h3>
                    <p class="text-muted small mb-0">Fill in the participant details below to confirm your seat.</p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger py-2 small alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i> ${errorMessage}
                        <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/event/register" method="post" id="registrationForm">
                    <input type="hidden" name="eventId" value="${event.id}">

                    <!-- Participation Mode Selection -->
                    <div class="mb-4">
                        <label class="form-label fw-bold small text-secondary text-uppercase">Participation Mode</label>
                        <div class="row g-3">
                            <c:if test="${event.participationType == 'INDIVIDUAL' || event.participationType == 'BOTH'}">
                                <div class="col-sm-6">
                                    <div class="form-check p-3 border rounded-3 bg-light">
                                        <input class="form-check-input ms-0 me-2" type="radio" name="registrationType" id="regTypeIndividual" value="INDIVIDUAL" checked>
                                        <label class="form-check-label fw-bold text-dark cursor-pointer" for="regTypeIndividual">
                                            Individual Participant
                                            <div class="small fw-normal text-muted">Single registration under your name.</div>
                                        </label>
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${event.participationType == 'GROUP' || event.participationType == 'BOTH'}">
                                <div class="col-sm-6">
                                    <div class="form-check p-3 border rounded-3 bg-light">
                                        <input class="form-check-input ms-0 me-2" type="radio" name="registrationType" id="regTypeGroup" value="GROUP" ${event.participationType == 'GROUP' ? 'checked' : ''}>
                                        <label class="form-check-label fw-bold text-dark cursor-pointer" for="regTypeGroup">
                                            Team / Group Registration
                                            <div class="small fw-normal text-muted">Register a team with multiple students.</div>
                                        </label>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Primary Student / Team Leader Info -->
                    <div class="mb-4 p-3 bg-light rounded-3 border">
                        <h6 class="fw-bold text-dark mb-3">
                            <i class="bi bi-person-circle me-1 text-primary"></i> Primary Student (Team Lead)
                        </h6>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small text-muted">Full Name</label>
                                <input type="text" class="form-control" value="${currentUser.fullName}" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small text-muted">Student ID / Roll No</label>
                                <input type="text" class="form-control" value="${currentUser.studentId}" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small text-muted">Email</label>
                                <input type="email" class="form-control" value="${currentUser.email}" readonly>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small text-muted">Phone</label>
                                <input type="text" class="form-control" value="${currentUser.phone}" readonly>
                            </div>
                        </div>
                    </div>

                    <!-- Dynamic Group Registration Fields -->
                    <div id="groupRegistrationFields" class="d-none mb-4">
                        <div class="mb-3">
                            <label class="form-label fw-bold small text-secondary">Team / Group Name</label>
                            <input type="text" name="groupName" class="form-control" placeholder="e.g. CodeKnights, BinaryBits">
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <label class="form-label fw-bold small text-secondary mb-0">Team Members</label>
                            <button type="button" id="addParticipantBtn" class="btn btn-outline-primary btn-sm">
                                <i class="bi bi-plus-circle me-1"></i> Add Teammate
                            </button>
                        </div>

                        <div id="participantsList">
                            <!-- JS will dynamically append rows here -->
                        </div>
                    </div>

                    <!-- Special Requirements -->
                    <div class="mb-4">
                        <label class="form-label fw-bold small text-secondary">Special Requirements / Notes (Optional)</label>
                        <textarea name="specialRequirements" class="form-control" rows="2" placeholder="Dietary restrictions, wheelchair access, hardware kits needed, etc."></textarea>
                    </div>

                    <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                        <a href="${pageContext.request.contextPath}/events?action=view&id=${event.id}" class="btn btn-outline-secondary">
                            Cancel
                        </a>
                        <button type="submit" class="btn btn-primary px-4 fw-semibold shadow-sm">
                            Confirm Registration <i class="bi bi-check-circle-fill ms-1"></i>
                        </button>
                    </div>
                </form>

            </div>
        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
