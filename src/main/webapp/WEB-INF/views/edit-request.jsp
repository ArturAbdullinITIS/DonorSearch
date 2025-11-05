<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"/>

<style>
    .edit-request-page-header {
        background: transparent;
        color: white;
        padding: 2rem 0;
        margin-bottom: 2rem;
    }
    .card {
        border-radius: 15px;
        overflow: hidden;
    }
    .card-header {
        padding: 1rem 1.25rem !important;
        border-radius: 15px 15px 0 0 !important;
    }
    .card-body {
        padding: 1.25rem !important;
        border-radius: 0 !important;
    }
</style>

<div class="page-header edit-request-page-header">
    <div class="container">
        <h1 class="display-5 fw-bold"><i class="fas fa-edit me-3"></i>Редактировать запрос</h1>
        <p class="lead mb-0">Обновите информацию о запросе на донорство</p>
    </div>
</div>

<div class="container mb-5">
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card shadow-sm border-0">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0"><i class="fas fa-file-medical me-2"></i>Информация о запросе</h4>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/requests/update" method="post">
                <input type="hidden" name="id" value="${request.id}">

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="patientName" class="form-label"><i class="fas fa-user-injured me-2"></i>Имя пациента *</label>
                            <input type="text" class="form-control" id="patientName" name="patientName"
                                   value="${request.patientName}" required>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="mb-3">
                            <label for="bloodType" class="form-label"><i class="fas fa-tint me-2"></i>Группа крови *</label>
                            <select class="form-select" id="bloodType" name="bloodType" required>
                                <option value="O" ${request.bloodTypeNeeded == 'O' ? 'selected' : ''}>O (I)</option>
                                <option value="A" ${request.bloodTypeNeeded == 'A' ? 'selected' : ''}>A (II)</option>
                                <option value="B" ${request.bloodTypeNeeded == 'B' ? 'selected' : ''}>B (III)</option>
                                <option value="AB" ${request.bloodTypeNeeded == 'AB' ? 'selected' : ''}>AB (IV)</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="mb-3">
                            <label for="rhFactor" class="form-label"><i class="fas fa-plus-square me-2"></i>Резус-фактор *</label>
                            <select class="form-select" id="rhFactor" name="rhFactor" required>
                                <option value="POSITIVE" ${request.rhFactorNeeded == 'POSITIVE' ? 'selected' : ''}>Положительный (Rh+)</option>
                                <option value="NEGATIVE" ${request.rhFactorNeeded == 'NEGATIVE' ? 'selected' : ''}>Отрицательный (Rh-)</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="city" class="form-label"><i class="fas fa-map-marker-alt me-2"></i>Город *</label>
                            <input type="text" class="form-control" id="city" name="city"
                                   value="${request.city}" required>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="hospital" class="form-label"><i class="fas fa-hospital me-2"></i>Больница *</label>
                            <input type="text" class="form-control" id="hospital" name="hospital"
                                   value="${request.hospital}" required>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="urgency" class="form-label"><i class="fas fa-exclamation-triangle me-2"></i>Срочность</label>
                    <select class="form-select" id="urgency" name="urgency">
                        <option value="LOW" ${request.urgencyLevel == 'LOW' ? 'selected' : ''}>Низкая</option>
                        <option value="MEDIUM" ${request.urgencyLevel == 'MEDIUM' ? 'selected' : ''}>Средняя</option>
                        <option value="HIGH" ${request.urgencyLevel == 'HIGH' ? 'selected' : ''}>Высокая</option>
                        <option value="CRITICAL" ${request.urgencyLevel == 'CRITICAL' ? 'selected' : ''}>Критическая</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label"><i class="fas fa-info-circle me-2"></i>Описание</label>
                    <textarea class="form-control" id="description" name="description" rows="4">${request.description}</textarea>
                </div>

                <div class="mb-3">
                    <label for="contactInfo" class="form-label"><i class="fas fa-phone me-2"></i>Контактная информация *</label>
                    <textarea class="form-control" id="contactInfo" name="contactInfo" rows="2" required>${request.contactInfo}</textarea>
                </div>

                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                    <a href="${pageContext.request.contextPath}/requests/view?id=${request.id}" class="btn btn-secondary">
                        <i class="fas fa-times me-2"></i>Отмена
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Сохранить изменения
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp"/>
