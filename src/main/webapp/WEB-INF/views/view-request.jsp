<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp"/>

<style>
    .view-request-page-header {
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

<div class="page-header view-request-page-header">
    <div class="container">
        <h1 class="display-5 fw-bold"><i class="fas fa-file-medical me-3"></i>Запрос на донорство</h1>
        <p class="lead mb-0">Детали запроса и отклики</p>
    </div>
</div>

<div class="container mb-5">
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row">
        <div class="col-lg-8 mb-4">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <div>
                        <c:choose>
                            <c:when test="${request.urgencyLevel == 'CRITICAL'}">
                                <span class="badge bg-danger"><i class="fas fa-exclamation-triangle me-1"></i>Критическая</span>
                            </c:when>
                            <c:when test="${request.urgencyLevel == 'HIGH'}">
                                <span class="badge bg-warning text-dark"><i class="fas fa-exclamation-triangle me-1"></i>Высокая</span>
                            </c:when>
                            <c:when test="${request.urgencyLevel == 'MEDIUM'}">
                                <span class="badge bg-info"><i class="fas fa-exclamation-triangle me-1"></i>Средняя</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary"><i class="fas fa-exclamation-triangle me-1"></i>Низкая</span>
                            </c:otherwise>
                        </c:choose>

                        <c:choose>
                            <c:when test="${request.status == 'ACTIVE'}">
                                <span class="badge bg-success ms-2">Активен</span>
                            </c:when>
                            <c:when test="${request.status == 'FULFILLED'}">
                                <span class="badge bg-secondary ms-2">Выполнен</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary ms-2">${request.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <small class="text-muted">
                        <i class="fas fa-clock me-1"></i>
                        <fmt:parseDate value="${request.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both"/>
                        <fmt:formatDate value="${parsedDate}" pattern="dd.MM.yyyy HH:mm"/>
                    </small>
                </div>
                <div class="card-body">
                    <h4 class="mb-3"><i class="fas fa-user-injured me-2" style="color: #667eea;"></i>${request.patientName}</h4>
                    <div class="mb-3">
                        <span class="badge bg-danger fs-6 me-2">${request.bloodTypeNeeded}</span>
                        <span class="badge bg-info fs-6">${request.rhFactorNeeded == 'POSITIVE' ? 'Rh+' : 'Rh-'}</span>
                    </div>
                    <p class="mb-2">
                        <i class="fas fa-map-marker-alt me-2" style="color: #667eea;"></i><strong>Город:</strong> ${request.city}
                    </p>
                    <p class="mb-2">
                        <i class="fas fa-hospital text-primary me-2"></i><strong>Больница:</strong> ${request.hospital}
                    </p>
                    <c:if test="${not empty request.description}">
                        <div class="alert alert-light">
                            <i class="fas fa-info-circle me-2"></i><strong>Описание:</strong> ${request.description}
                        </div>
                    </c:if>
                    <div class="alert alert-secondary">
                        <i class="fas fa-phone me-2"></i><strong>Контактная информация:</strong><br/>
                        <span style="white-space: pre-line;">${request.contactInfo}</span>
                    </div>
                </div>

                <!-- Форма отклика показывается только если запрос активен и пользователь НЕ является автором -->
                <c:if test="${request.status == 'ACTIVE' && sessionScope.user.id != request.authorId}">
                    <c:choose>
                        <c:when test="${hasUserResponded}">
                            <!-- Пользователь уже откликнулся -->
                            <div class="card-footer bg-light">
                                <div class="alert alert-success mb-0">
                                    <i class="fas fa-check-circle me-2"></i>Вы уже откликнулись на этот запрос. Автор запроса может связаться с вами по контактным данным из вашего профиля.
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${empty donorProfile}">
                            <!-- У пользователя нет профиля донора -->
                            <div class="card-footer bg-light">
                                <div class="alert alert-warning mb-0">
                                    <i class="fas fa-exclamation-triangle me-2"></i>У вас нет профиля донора. Заполните свой донорский профиль, чтобы откликаться на запросы.
                                    <div class="mt-2">
                                        <a href="${pageContext.request.contextPath}/profile" class="btn btn-sm btn-primary">
                                            <i class="fas fa-user-plus me-1"></i>Заполнить профиль донора
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:when test="${!isBloodTypeCompatible}">
                            <!-- Группа крови не совместима -->
                            <div class="card-footer bg-light">
                                <div class="alert alert-danger mb-0">
                                    <i class="fas fa-times-circle me-2"></i>
                                    <strong>Несовместимая группа крови</strong><br/>
                                    Ваша группа крови: <strong>${donorProfile.bloodType} ${donorProfile.rhFactor == 'POSITIVE' ? 'Rh+' : 'Rh-'}</strong><br/>
                                    Требуется: <strong>${request.bloodTypeNeeded} ${request.rhFactorNeeded == 'POSITIVE' ? 'Rh+' : 'Rh-'}</strong><br/>
                                    <small class="text-muted mt-2 d-block">К сожалению, ваша группа крови не совместима с требуемой группой крови реципиента.</small>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Форма для отклика -->
                            <div class="card-footer bg-white">
                                <form action="${pageContext.request.contextPath}/responses/create" method="post">
                                    <input type="hidden" name="requestId" value="${request.id}">
                                    <div class="mb-3">
                                        <label for="message" class="form-label"><i class="fas fa-comment me-2"></i>Ваше сообщение автору (необязательно)</label>
                                        <textarea id="message" name="message" rows="3" class="form-control" placeholder="Кратко опишите готовность, возможные сроки и т.п."></textarea>
                                    </div>
                                    <div class="d-grid d-md-flex justify-content-md-end">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-handshake me-2"></i>Откликнуться
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>

                <!-- Сообщение для автора запроса -->
                <c:if test="${request.status == 'ACTIVE' && sessionScope.user.id == request.authorId}">
                    <div class="card-footer bg-light">
                        <div class="alert alert-info mb-0">
                            <i class="fas fa-info-circle me-2"></i>Это ваш запрос. Вы не можете откликнуться на собственный запрос.
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="col-lg-4">
            <!-- Отклики видны только автору запроса -->
            <c:if test="${sessionScope.user.id == request.authorId}">
                <div class="card shadow-sm mb-4 border-0">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-comments me-2"></i>Отклики</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty responses}">
                                <div class="list-group">
                                    <c:forEach items="${responses}" var="resp">
                                        <div class="list-group-item list-group-item-action">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <c:choose>
                                                        <c:when test="${resp.status == 'PENDING'}">
                                                            <span class="badge bg-warning text-dark">Ожидает</span>
                                                        </c:when>
                                                        <c:when test="${resp.status == 'CONTACTED'}">
                                                            <span class="badge bg-success">Связались</span>
                                                        </c:when>
                                                        <c:when test="${resp.status == 'REJECTED'}">
                                                            <span class="badge bg-secondary">Отклонен</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${resp.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <small class="text-muted">
                                                    <i class="fas fa-clock me-1"></i>
                                                    <fmt:parseDate value="${resp.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="respDate" type="both"/>
                                                    <fmt:formatDate value="${respDate}" pattern="dd.MM.yyyy HH:mm"/>
                                                </small>
                                            </div>
                                            <c:if test="${not empty resp.message}">
                                                <p class="mb-2 mt-2"><i class="fas fa-comment me-2"></i>${resp.message}</p>
                                            </c:if>
                                            <small class="text-muted">
                                                <i class="fas fa-user me-1"></i>Донор:
                                                <c:choose>
                                                    <c:when test="${not empty resp.donorName}">
                                                        ${resp.donorName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Не указано
                                                    </c:otherwise>
                                                </c:choose>
                                            </small>
                                            <c:if test="${not empty resp.donorPhone}">
                                                <br/>
                                                <small class="text-muted">
                                                    <i class="fas fa-phone me-1"></i>Телефон: ${resp.donorPhone}
                                                </small>
                                            </c:if>
                                            <c:if test="${not empty resp.donorBloodType}">
                                                <br/>
                                                <small class="text-muted">
                                                    <i class="fas fa-tint me-1"></i>Группа крови: ${resp.donorBloodType}
                                                </small>
                                            </c:if>

                                            <!-- Кнопки управления откликом -->
                                            <div class="mt-3 d-flex gap-2 flex-wrap">
                                                <c:if test="${resp.status == 'PENDING'}">
                                                    <form action="${pageContext.request.contextPath}/responses/update-status" method="post" class="d-inline" onsubmit="return confirm('Отметить, что вы связались с этим донором?');">
                                                        <input type="hidden" name="responseId" value="${resp.id}">
                                                        <input type="hidden" name="status" value="CONTACTED">
                                                        <input type="hidden" name="requestId" value="${request.id}">
                                                        <button type="submit" class="btn btn-sm btn-success">
                                                            <i class="fas fa-check me-1"></i>Связались
                                                        </button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/responses/update-status" method="post" class="d-inline" onsubmit="return confirm('Отклонить этот отклик?');">
                                                        <input type="hidden" name="responseId" value="${resp.id}">
                                                        <input type="hidden" name="status" value="REJECTED">
                                                        <input type="hidden" name="requestId" value="${request.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger">
                                                            <i class="fas fa-times me-1"></i>Отклонить
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${resp.status == 'CONTACTED'}">
                                                    <span class="badge bg-success-subtle text-success border border-success px-3 py-2">
                                                        <i class="fas fa-check-circle me-1"></i>Вы связались с этим донором
                                                    </span>
                                                    <form action="${pageContext.request.contextPath}/responses/update-status" method="post" class="d-inline">
                                                        <input type="hidden" name="responseId" value="${resp.id}">
                                                        <input type="hidden" name="status" value="PENDING">
                                                        <input type="hidden" name="requestId" value="${request.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-secondary">
                                                            <i class="fas fa-undo me-1"></i>Вернуть
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${resp.status == 'REJECTED'}">
                                                    <span class="badge bg-danger-subtle text-danger border border-danger px-3 py-2">
                                                        <i class="fas fa-times-circle me-1"></i>Отклик отклонен
                                                    </span>
                                                    <form action="${pageContext.request.contextPath}/responses/update-status" method="post" class="d-inline">
                                                        <input type="hidden" name="responseId" value="${resp.id}">
                                                        <input type="hidden" name="status" value="PENDING">
                                                        <input type="hidden" name="requestId" value="${request.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-secondary">
                                                            <i class="fas fa-undo me-1"></i>Восстановить
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted">Пока нет откликов на этот запрос.</p>
                                <a href="${pageContext.request.contextPath}/responses/for-request?requestId=${request.id}" class="btn btn-outline-primary w-100">
                                    <i class="fas fa-sync-alt me-2"></i>Обновить отклики
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>

            <div class="d-grid gap-2">
                <c:choose>
                    <c:when test="${sessionScope.user.id == request.authorId}">
                        <!-- Если это автор запроса -->
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/requests">
                            <i class="fas fa-arrow-left me-2"></i>К моим запросам
                        </a>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/requests/all">
                            <i class="fas fa-list me-2"></i>Все активные запросы
                        </a>
                    </c:when>
                    <c:otherwise>
                        <!-- Если это не автор запроса -->
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/requests/all">
                            <i class="fas fa-arrow-left me-2"></i>К активным запросам
                        </a>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/responses">
                            <i class="fas fa-comments me-2"></i>Мои отклики
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp"/>
