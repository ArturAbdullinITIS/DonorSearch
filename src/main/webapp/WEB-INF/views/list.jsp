<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp"/>

<style>
    .list-page-header {
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

<div class="page-header list-page-header">
    <div class="container">
        <h1 class="display-5 fw-bold"><i class="fas fa-list me-3"></i>Активные запросы на донорство</h1>
        <p class="lead mb-0">Просмотрите активные запросы и помогите тем, кто нуждается в донорской крови</p>
    </div>
</div>

<div class="container mb-5">
    <c:if test="${empty requests}">
        <div class="card border-0 shadow-sm">
            <div class="card-body text-center py-5">
                <i class="fas fa-info-circle fa-3x text-muted mb-3"></i>
                <h5>Сейчас нет активных запросов на донорство.</h5>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty requests}">
        <div class="row">
            <c:forEach items="${requests}" var="req">
                <div class="col-md-6 mb-4">
                    <div class="card h-100 shadow-sm border-0">
                        <div class="card-header d-flex justify-content-between align-items-center bg-white border-0">
                            <div>
                                <span class="badge ${req.urgencyLevel == 'CRITICAL' ? 'bg-danger' :
                                                         req.urgencyLevel == 'HIGH' ? 'bg-warning text-dark' :
                                                         req.urgencyLevel == 'MEDIUM' ? 'bg-info' : 'bg-secondary'} fs-6">
                                    <i class="fas fa-exclamation-triangle me-1"></i>
                                    ${req.urgencyLevel == 'CRITICAL' ? 'СРОЧНО!' :
                                      req.urgencyLevel == 'HIGH' ? 'Высокая' :
                                      req.urgencyLevel == 'MEDIUM' ? 'Средняя' : 'Низкая'}
                                </span>
                                <c:if test="${req.authorId == sessionScope.user.id}">
                                    <span class="badge bg-primary ms-2"><i class="fas fa-user me-1"></i>Мой запрос</span>
                                </c:if>
                            </div>
                            <small class="text-muted">
                                <i class="fas fa-clock me-1"></i>
                                <fmt:parseDate value="${req.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="reqCreatedDate" type="both"/>
                                <fmt:formatDate value="${reqCreatedDate}" pattern="dd.MM.yyyy HH:mm"/>
                            </small>
                        </div>
                        <div class="card-body">
                            <h5 class="card-title"><i class="fas fa-user-injured me-2" style="color: #667eea;"></i>${req.patientName}</h5>
                            <div class="mb-3">
                                <span class="badge bg-danger fs-6 me-2">${req.bloodTypeNeeded}</span>
                                <span class="badge bg-info fs-6">${req.rhFactorNeeded == 'POSITIVE' ? 'Rh+' : 'Rh-'}</span>
                            </div>
                            <p class="card-text">
                                <i class="fas fa-map-marker-alt me-2" style="color: #667eea;"></i><strong>Город:</strong> ${req.city}<br>
                                <i class="fas fa-hospital text-primary me-2"></i><strong>Больница:</strong> ${req.hospital}
                            </p>
                            <c:if test="${not empty req.description}">
                                <p class="card-text text-muted">
                                    <i class="fas fa-info-circle me-2"></i>
                                    ${req.description.length() > 150 ? req.description.substring(0, 150).concat('...') : req.description}
                                </p>
                            </c:if>
                            <hr>
                            <p class="card-text">
                                <small class="text-muted">
                                    <i class="fas fa-user me-1"></i>Автор: ${req.authorName} |
                                    <i class="fas fa-comments ms-2 me-1"></i>Откликов: ${req.responsesCount}
                                </small>
                            </p>
                        </div>
                        <div class="card-footer bg-white border-0">
                            <c:choose>
                                <c:when test="${req.authorId == sessionScope.user.id}">
                                    <button class="btn btn-secondary w-100" disabled>
                                        <i class="fas fa-info-circle me-2"></i>Это ваш запрос
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/requests/view?id=${req.id}"
                                       class="btn btn-primary w-100">
                                        <i class="fas fa-eye me-2"></i>Подробнее и откликнуться
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</div>

<jsp:include page="footer.jsp"/>
