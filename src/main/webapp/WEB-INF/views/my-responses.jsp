<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp"/>

<style>
    .my-responses-page-header {
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

<div class="page-header my-responses-page-header">
    <div class="container">
        <h1 class="display-5 fw-bold"><i class="fas fa-comments me-3"></i>Мои отклики</h1>
        <p class="lead mb-0">Просмотрите ваши отклики на запросы о донорстве</p>
    </div>
</div>

<div class="container mb-5">
    <c:if test="${empty responses}">
        <div class="card border-0 shadow-sm">
            <div class="card-body text-center py-5">
                <i class="fas fa-info-circle fa-3x text-muted mb-3"></i>
                <h5>Вы пока не откликались ни на один запрос.</h5>
                <a href="${pageContext.request.contextPath}/requests/all" class="btn btn-primary mt-3">
                    <i class="fas fa-list me-2"></i>Посмотреть активные запросы
                </a>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty responses}">
        <div class="row">
            <c:forEach items="${responses}" var="response">
                <div class="col-md-6 mb-4">
                    <div class="card h-100 shadow-sm border-0">
                        <div class="card-header bg-white d-flex justify-content-between align-items-center border-0">
                            <span class="badge ${response.status == 'PENDING' ? 'bg-warning text-dark' :
                                                    response.status == 'CONTACTED' ? 'bg-success' : 'bg-secondary'} fs-6">
                                <i class="fas ${response.status == 'PENDING' ? 'fa-clock' :
                                               response.status == 'CONTACTED' ? 'fa-check' : 'fa-times'} me-1"></i>
                                ${response.status == 'PENDING' ? 'Ожидает' :
                                  response.status == 'CONTACTED' ? 'С вами связались' : 'Отклонен'}
                            </span>
                            <small class="text-muted">
                                <i class="fas fa-clock me-1"></i>
                                <fmt:parseDate value="${response.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="respCreatedDate" type="both"/>
                                <fmt:formatDate value="${respCreatedDate}" pattern="dd.MM.yyyy HH:mm"/>
                            </small>
                        </div>
                        <div class="card-body">
                            <h5 class="mb-3">
                                <i class="fas fa-user-injured me-2" style="color: #667eea;"></i>
                                Запрос для: ${response.requestPatientName}
                            </h5>
                            <c:if test="${not empty response.message}">
                                <div class="alert alert-light">
                                    <small class="text-muted"><i class="fas fa-comment me-2"></i>Ваше сообщение:</small>
                                    <p class="mb-0 mt-1">${response.message}</p>
                                </div>
                            </c:if>
                            <p class="text-muted small mb-0">
                                <i class="fas fa-calendar-alt me-1"></i>Дата отклика:
                                <fmt:parseDate value="${response.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="respCreatedDate2" type="both"/>
                                <fmt:formatDate value="${respCreatedDate2}" pattern="dd.MM.yyyy HH:mm"/>
                            </p>
                        </div>
                        <div class="card-footer bg-white border-0">
                            <a href="${pageContext.request.contextPath}/requests/view?id=${response.requestId}"
                               class="btn btn-primary w-100">
                                <i class="fas fa-eye me-2"></i>Посмотреть запрос
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</div>

<jsp:include page="footer.jsp"/>
