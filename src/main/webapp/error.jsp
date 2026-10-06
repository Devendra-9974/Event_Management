<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Action Notice &bull; Arya College ClubSphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light d-flex align-items-center justify-content-center min-vh-100">

<div class="container text-center py-5">
    <div class="card card-custom p-5 mx-auto shadow-sm" style="max-width: 500px;">
        <div class="text-warning mb-3">
            <i class="bi bi-shield-exclamation display-3"></i>
        </div>
        <h3 class="fw-bold text-dark mb-2">Attention Required</h3>
        <p class="text-muted small mb-4">
            ${not empty errorMessage ? errorMessage : 'An issue occurred while processing your request or access was denied.'}
        </p>
        <div class="d-flex gap-2 justify-content-center">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary fw-semibold px-4">
                Back to Homepage
            </a>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-secondary px-4">
                Switch Account
            </a>
        </div>
    </div>
</div>

</body>
</html>
