<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"/>

<style>
    .create-request-page-header {
        background: transparent;
        color: white;
        padding: 2rem 0;
        margin-bottom: 2rem;
    }
    .card {
        border-radius: 15px;
        overflow: hidden;
    }
    .info-badge {
        background-color: #e7f3ff;
        color: #0066cc;
        padding: 0.5rem 1rem;
        border-radius: 8px;
        margin-bottom: 1rem;
        display: inline-block;
    }
</style>

<div class="page-header create-request-page-header">
    <div class="container">
        <h1 class="display-5 fw-bold"><i class="fas fa-plus-circle me-3"></i>Создать запрос на донорство</h1>
        <p class="lead mb-0">Заполните форму чтобы опубликовать запрос на поиск донора крови</p>
    </div>
</div>

<div class="container mb-5">
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty donorProfile}">
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            <i class="fas fa-info-circle me-2"></i>
            <strong>Автозаполнение:</strong> Данные о группе крови и городе заполнены из вашего профиля донора.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card shadow-sm border-0">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0"><i class="fas fa-file-medical me-2"></i>Информация о запросе</h4>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/requests/create" method="post">
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="patientName" class="form-label"><i class="fas fa-user-injured me-2"></i>Имя пациента *</label>
                            <input type="text" class="form-control" id="patientName" name="patientName"
                                   value="${not empty sessionScope.user.fullName ? sessionScope.user.fullName : ''}" required readonly>
                            <div class="form-text">Автоматически заполнено из вашего профиля</div>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="mb-3">
                            <label for="bloodType" class="form-label"><i class="fas fa-tint me-2"></i>Группа крови *</label>
                            <select class="form-select" id="bloodType" name="bloodType" required disabled>
                                <option value="">Выберите...</option>
                                <option value="O" ${not empty donorProfile && donorProfile.bloodType == 'O' ? 'selected' : ''}>O (I)</option>
                                <option value="A" ${not empty donorProfile && donorProfile.bloodType == 'A' ? 'selected' : ''}>A (II)</option>
                                <option value="B" ${not empty donorProfile && donorProfile.bloodType == 'B' ? 'selected' : ''}>B (III)</option>
                                <option value="AB" ${not empty donorProfile && donorProfile.bloodType == 'AB' ? 'selected' : ''}>AB (IV)</option>
                            </select>
                            <!-- Скрытое поле для отправки значения -->
                            <input type="hidden" name="bloodType" value="${not empty donorProfile ? donorProfile.bloodType : ''}">
                            <div class="form-text">Из профиля донора</div>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="mb-3">
                            <label for="rhFactor" class="form-label"><i class="fas fa-plus-square me-2"></i>Резус-фактор *</label>
                            <select class="form-select" id="rhFactor" name="rhFactor_display" required disabled>
                                <option value="">Выберите...</option>
                                <option value="POSITIVE" ${not empty donorProfile && donorProfile.rhFactor == 'POSITIVE' ? 'selected' : ''}>Положительный (Rh+)</option>
                                <option value="NEGATIVE" ${not empty donorProfile && donorProfile.rhFactor == 'NEGATIVE' ? 'selected' : ''}>Отрицательный (Rh-)</option>
                            </select>
                            <!-- Скрытое поле для отправки значения -->
                            <input type="hidden" name="rhFactor" value="${not empty donorProfile ? donorProfile.rhFactor : ''}">
                            <div class="form-text">Из профиля донора</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="city" class="form-label"><i class="fas fa-map-marker-alt me-2"></i>Город *</label>
                            <input type="text" class="form-control" id="city" name="city"
                                   value="${not empty sessionScope.user.city ? sessionScope.user.city : ''}" required>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="hospital" class="form-label"><i class="fas fa-hospital me-2"></i>Больница *</label>
                            <input type="text" class="form-control" id="hospital" name="hospital" required>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="urgency" class="form-label"><i class="fas fa-exclamation-triangle me-2"></i>Срочность</label>
                    <select class="form-select" id="urgency" name="urgency">
                        <option value="LOW">Низкая</option>
                        <option value="MEDIUM" selected>Средняя</option>
                        <option value="HIGH">Высокая</option>
                        <option value="CRITICAL">Критическая</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label"><i class="fas fa-info-circle me-2"></i>Описание</label>
                    <textarea class="form-control" id="description" name="description" rows="4"
                              placeholder="Дополнительная информация о ситуации..."></textarea>
                </div>

                <div class="mb-3">
                    <label for="contactInfo" class="form-label"><i class="fas fa-phone me-2"></i>Контактная информация *</label>
                    <textarea class="form-control" id="contactInfo" name="contactInfo" rows="2" required
                              placeholder="Укажите телефон, email или другие способы связи"><c:if test="${not empty sessionScope.user.phone}">Телефон: ${sessionScope.user.phone}</c:if><c:if test="${not empty sessionScope.user.phone && not empty sessionScope.user.email}">
</c:if><c:if test="${not empty sessionScope.user.email}">Email: ${sessionScope.user.email}</c:if></textarea>
                    <div class="form-text">Укажите как с вами можно связаться</div>
                </div>

                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                    <a href="${pageContext.request.contextPath}/requests" class="btn btn-secondary">
                        <i class="fas fa-times me-2"></i>Отмена
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-check me-2"></i>Создать запрос
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp"/>
