<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"/>

<style>
    .search-donors-page-header {
        background: transparent;
        color: white;
        padding: 2rem 0;
        margin-bottom: 2rem;
    }
    .card {
        border-radius: 15px;
        overflow: hidden;
    }
</style>

<div class="page-header search-donors-page-header">
    <div class="container">
        <h1 class="display-5 fw-bold"><i class="fas fa-search me-3"></i>Поиск доноров крови</h1>
        <p class="lead mb-0">Найдите доноров по группе крови и местоположению</p>
    </div>
</div>

<div class="container mb-5">
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0"><i class="fas fa-filter me-2"></i>Параметры поиска</h4>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/search" method="get">
                <div class="row">
                    <div class="col-md-3">
                        <div class="mb-3">
                            <label for="bloodType" class="form-label"><i class="fas fa-tint me-2"></i>Группа крови *</label>
                            <select class="form-select" id="bloodType" name="bloodType" required>
                                <option value="">Выберите...</option>
                                <option value="O" ${bloodType == 'O' ? 'selected' : ''}>O (I)</option>
                                <option value="A" ${bloodType == 'A' ? 'selected' : ''}>A (II)</option>
                                <option value="B" ${bloodType == 'B' ? 'selected' : ''}>B (III)</option>
                                <option value="AB" ${bloodType == 'AB' ? 'selected' : ''}>AB (IV)</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="mb-3">
                            <label for="rhFactor" class="form-label"><i class="fas fa-plus-square me-2"></i>Резус-фактор *</label>
                            <select class="form-select" id="rhFactor" name="rhFactor" required>
                                <option value="">Выберите...</option>
                                <option value="POSITIVE" ${rhFactor == 'POSITIVE' ? 'selected' : ''}>Положительный (Rh+)</option>
                                <option value="NEGATIVE" ${rhFactor == 'NEGATIVE' ? 'selected' : ''}>Отрицательный (Rh-)</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="mb-3">
                            <label for="city" class="form-label"><i class="fas fa-map-marker-alt me-2"></i>Город (необязательно)</label>
                            <input type="text" class="form-control" id="city" name="city" value="${city}"
                                   placeholder="Например: Москва">
                        </div>
                    </div>

                    <div class="col-md-2">
                        <div class="mb-3">
                            <label class="form-label">&nbsp;</label>
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-search me-2"></i>Найти
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <c:if test="${searchPerformed}">
        <c:if test="${empty donors}">
            <div class="card border-0 shadow-sm">
                <div class="card-body text-center py-5">
                    <i class="fas fa-info-circle fa-3x text-muted mb-3"></i>
                    <h5>По вашему запросу доноров не найдено. Попробуйте изменить параметры поиска.</h5>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty donors}">
            <div class="alert alert-success mb-4">
                <i class="fas fa-check-circle me-2"></i>
                <strong>Найдено доноров: ${donors.size()}</strong>
            </div>

            <div class="row">
                <c:forEach items="${donors}" var="donor">
                    <div class="col-md-4 mb-4">
                        <div class="card h-100 shadow-sm border-0">
                            <div class="card-header bg-white border-0">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="badge bg-danger fs-6">${donor.bloodType}</span>
                                    <span class="badge bg-info fs-6">${donor.rhFactor == 'POSITIVE' ? 'Rh+' : 'Rh-'}</span>
                                </div>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title"><i class="fas fa-user me-2" style="color: #667eea;"></i>${donor.userName}</h5>
                                <hr>
                                <p class="card-text mb-2">
                                    <i class="fas fa-map-marker-alt me-2" style="color: #667eea;"></i><strong>Город:</strong> ${donor.userCity}
                                </p>
                                <c:if test="${not empty donor.userPhone}">
                                    <p class="card-text mb-2">
                                        <i class="fas fa-phone text-success me-2"></i><strong>Телефон:</strong> ${donor.userPhone}
                                    </p>
                                </c:if>
                                <c:if test="${donor.readyToDonate}">
                                    <div class="mt-3">
                                        <span class="badge bg-success w-100 py-2">
                                            <i class="fas fa-check-circle me-1"></i>Готов быть донором
                                        </span>
                                    </div>
                                </c:if>
                                <c:if test="${not empty donor.additionalInfo}">
                                    <hr>
                                    <p class="card-text text-muted small">
                                        <i class="fas fa-info-circle me-1"></i>${donor.additionalInfo}
                                    </p>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </c:if>
</div>

<jsp:include page="footer.jsp"/>
