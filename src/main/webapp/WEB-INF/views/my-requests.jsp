<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"/>


<style>
    .my-requests-page-header {
        background: transparent;
        color: white;
        padding: 2rem 0;
        margin-bottom: 2rem;
    }
    .card {
        border-radius: 15px;
        overflow: hidden;
        transition: transform 0.2s ease, box-shadow 0.2s ease;
        background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
        border: 1px solid #e9ecef !important;
    }
    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 35px rgba(0,0,0,0.2) !important;
    }
    .card-header {
        padding: 0.75rem 1rem;
        background: linear-gradient(135deg, rgba(102, 126, 234, 0.08) 0%, rgba(118, 75, 162, 0.08) 100%) !important;
        border-bottom: 1px solid rgba(102, 126, 234, 0.1) !important;
    }
    .card-body {
        padding: 1rem;
        background: white;
    }
    .card-title {
        font-size: 1.1rem;
        font-weight: 600;
        margin-bottom: 0.75rem;
    }
    .card-text {
        font-size: 0.9rem;
        line-height: 1.6;
    }
    .card-footer {
        padding: 0.75rem 1rem;
        background: linear-gradient(135deg, rgba(248, 249, 250, 0.8) 0%, rgba(233, 236, 239, 0.8) 100%) !important;
        border-top: 1px solid rgba(0, 0, 0, 0.05) !important;
    }
    .badge {
        font-weight: 500;
        padding: 0.35rem 0.65rem;
    }
    .btn-group {
        display: flex;
        gap: 0.5rem;
    }
    .btn-group .btn {
        font-size: 0.85rem;
        padding: 0.5rem;
        border-radius: 8px !important;
        flex: 1;
        min-width: 0;
    }
    .info-row {
        display: flex;
        align-items: center;
        margin-bottom: 0.4rem;
    }
    .info-row i {
        width: 20px;
        margin-right: 0.5rem;
    }
    .requests-container {
        padding: 2rem;
        border-radius: 20px;
        backdrop-filter: blur(10px);
    }
</style>

<div class="page-header my-requests-page-header">
    <div class="container">
        <h1 class="display-5 fw-bold"><i class="fas fa-list me-3"></i>Мои запросы на донорство</h1>
        <p class="lead mb-0">Управляйте своими запросами на поиск доноров крови</p>
    </div>
</div>

<div class="container mb-5">
    <div class="requests-container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div></div>
            <a href="${pageContext.request.contextPath}/requests/new" class="btn btn-primary">
                <i class="fas fa-plus me-2"></i>Создать новый запрос
            </a>
        </div>

        <c:if test="${empty requests}">
            <div class="card border-0 shadow-sm">
                <div class="card-body text-center py-5">
                    <i class="fas fa-info-circle fa-3x text-muted mb-3"></i>
                    <h5>У вас пока нет запросов на донорство.</h5>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty requests}">
            <div class="row">
                <c:forEach items="${requests}" var="req">
                    <div class="col-md-6 col-lg-4 mb-4">
                        <div class="card h-100 shadow-sm">
                            <div class="card-header d-flex justify-content-between align-items-center border-0">
                                <span class="badge ${req.urgencyLevel == 'CRITICAL' ? 'bg-danger' :
                                                         req.urgencyLevel == 'HIGH' ? 'bg-warning text-dark' :
                                                         req.urgencyLevel == 'MEDIUM' ? 'bg-info' : 'bg-secondary'}">
                                    ${req.urgencyLevel == 'CRITICAL' ? 'Срочно' :
                                      req.urgencyLevel == 'HIGH' ? 'Высокая' :
                                      req.urgencyLevel == 'MEDIUM' ? 'Средняя' : 'Низкая'}
                                </span>
                                <span class="badge ${req.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                    ${req.status == 'ACTIVE' ? 'Активен' :
                                      req.status == 'FULFILLED' ? 'Выполнен' : 'Закрыт'}
                                </span>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title">
                                    <i class="fas fa-user-injured me-2" style="color: #667eea;"></i>${req.patientName}
                                </h5>
                                <div class="mb-3">
                                    <span class="badge bg-danger me-1">${req.bloodTypeNeeded}${req.rhFactorNeeded == 'POSITIVE' ? '+' : '-'}</span>
                                    <span class="badge bg-light text-dark"><i class="fas fa-comments me-1"></i>${req.responsesCount}</span>
                                </div>
                                <div class="info-row">
                                    <i class="fas fa-map-marker-alt text-muted"></i>
                                    <small class="text-muted">${req.city}</small>
                                </div>
                                <div class="info-row">
                                    <i class="fas fa-hospital text-muted"></i>
                                    <small class="text-muted">${req.hospital.length() > 30 ? req.hospital.substring(0, 30).concat('...') : req.hospital}</small>
                                </div>
                            </div>
                            <div class="card-footer border-0">
                                <div class="d-flex flex-column gap-2">
                                    <a href="${pageContext.request.contextPath}/requests/view?id=${req.id}"
                                       class="btn btn-sm btn-primary w-100">
                                        <i class="fas fa-eye me-1"></i>Подробнее
                                    </a>
                                    <div class="btn-group" role="group">
                                        <c:choose>
                                            <c:when test="${req.status == 'ACTIVE'}">
                                                <!-- Активный запрос: редактировать, закрыть, удалить -->
                                                <a href="${pageContext.request.contextPath}/requests/edit?id=${req.id}"
                                                   class="btn btn-sm btn-outline-warning" title="Редактировать">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <form action="${pageContext.request.contextPath}/requests/close" method="post"
                                                      style="flex: 1;" onsubmit="return confirm('Закрыть этот запрос?');">
                                                    <input type="hidden" name="id" value="${req.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-success w-100" title="Закрыть">
                                                        <i class="fas fa-check"></i>
                                                    </button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/requests/delete" method="post"
                                                      style="flex: 1;" onsubmit="return confirm('Удалить этот запрос?');">
                                                    <input type="hidden" name="id" value="${req.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger w-100" title="Удалить">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Закрытый запрос: возобновить, удалить -->
                                                <form action="${pageContext.request.contextPath}/requests/reopen" method="post"
                                                      style="flex: 1;" onsubmit="return confirm('Возобновить этот запрос?');">
                                                    <input type="hidden" name="id" value="${req.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-success w-100" title="Возобновить">
                                                        <i class="fas fa-redo"></i>
                                                    </button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/requests/delete" method="post"
                                                      style="flex: 1;" onsubmit="return confirm('Удалить этот запрос?');">
                                                    <input type="hidden" name="id" value="${req.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger w-100" title="Удалить">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="footer.jsp"/>
