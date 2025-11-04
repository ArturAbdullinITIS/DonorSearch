<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"/>

<style>
    .dashboard-page-header {
        background: transparent;
        color: white;
        padding: 2rem 0;
        margin-bottom: 2rem;
    }
    /* Убираем принудительное растягивание карточек */
    .dashboard-card {
        border-radius: 15px;
        overflow: hidden;
    }
</style>

<div class="page-header dashboard-page-header">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h1 class="display-5 fw-bold"><i class="fas fa-home me-3"></i>Главная страница</h1>
                <p class="lead mb-0">Управляйте вашими активностями и помогайте спасать жизни</p>
            </div>
        </div>
    </div>
</div>

<div class="container mb-5 pb-4">
    <!-- Статистика (плейсхолдеры) -->
    <div class="row mb-5">
        <div class="col-md-3 mb-4">
            <div class="stat-card">
                <div class="stat-number">${myRequestsCount != null ? myRequestsCount : 0}</div>
                <div class="text-muted"><i class="fas fa-clipboard-list me-2"></i>Мои запросы</div>
            </div>
        </div>
        <div class="col-md-3 mb-4">
            <div class="stat-card">
                <div class="stat-number">${myResponsesCount != null ? myResponsesCount : 0}</div>
                <div class="text-muted"><i class="fas fa-handshake me-2"></i>Отклики</div>
            </div>
        </div>
        <div class="col-md-3 mb-4">
            <div class="stat-card">
                <div class="stat-number">${fulfilledRequestsCount != null ? fulfilledRequestsCount : 0}</div>
                <div class="text-muted"><i class="fas fa-heart me-2"></i>Помощь оказана</div>
            </div>
        </div>
        <div class="col-md-3 mb-4">
            <div class="stat-card">
                <div class="stat-number">
                    <jsp:useBean id="dateFormatter" class="com.blooddonor.util.DateFormatter"/>
                    ${dateFormatter.formatShortDate(user.createdAt)}
                </div>
                <div class="text-muted"><i class="fas fa-calendar me-2"></i>С нами с</div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Основной контент -->
        <div class="col-lg-8 mb-4">
            <!-- Быстрые действия -->
            <div class="card border-0 shadow-sm mb-4 dashboard-card">
                <div class="card-header bg-primary text-white py-3">
                    <h4 class="mb-0"><i class="fas fa-bolt me-2" style="color: #ffc107;"></i>Быстрые действия</h4>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <div class="quick-action">
                                <div class="action-icon">🩸</div>
                                <h5>Создать запрос</h5>
                                <p class="text-muted small mb-3">Опубликуйте запрос на поиск донора</p>
                                <a href="${pageContext.request.contextPath}/requests/new" class="btn btn-primary">
                                    <i class="fas fa-plus me-2"></i>Создать запрос
                                </a>
                            </div>
                        </div>
                        <div class="col-md-6 mb-4">
                            <div class="quick-action">
                                <div class="action-icon">❤️</div>
                                <h5>Стать донором</h5>
                                <p class="text-muted small mb-3">Заполните донорский профиль</p>
                                <a href="${pageContext.request.contextPath}/profile" class="btn btn-primary">
                                    <i class="fas fa-user-plus me-2"></i>Заполнить профиль
                                </a>
                            </div>
                        </div>
                        <div class="col-md-6 mb-4">
                            <div class="quick-action">
                                <div class="action-icon">👥</div>
                                <h5>Найти доноров</h5>
                                <p class="text-muted small mb-3">Поиск доноров по параметрам</p>
                                <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">
                                    <i class="fas fa-search me-2"></i>Найти доноров
                                </a>
                            </div>
                        </div>
                        <div class="col-md-6 mb-4">
                            <div class="quick-action">
                                <div class="action-icon">📊</div>
                                <h5>Активные запросы</h5>
                                <p class="text-muted small mb-3">Просмотр всех активных запросов</p>
                                <a href="${pageContext.request.contextPath}/requests/all" class="btn btn-primary">
                                    <i class="fas fa-list me-2"></i>Посмотреть
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Последняя активность -->
            <div class="card border-0 shadow-sm mb-4 dashboard-card">
                <div class="card-header bg-primary text-white py-3">
                    <h4 class="mb-0"><i class="fas fa-history me-2"></i>Последняя активность</h4>
                </div>
                <div class="card-body">
                    <jsp:useBean id="dateFormatter2" class="com.blooddonor.util.DateFormatter"/>
                    <c:choose>
                        <c:when test="${not empty recentActivities}">
                            <div class="list-group list-group-flush">
                                <c:forEach var="act" items="${recentActivities}">
                                    <div class="list-group-item d-flex justify-content-between align-items-start py-2">
                                        <div>
                                            <h6 class="mb-1">${act.title}</h6>
                                            <p class="text-muted small mb-1">${act.description}</p>
                                            <small class="text-muted">
                                                <i class="fas fa-clock me-1"></i>
                                                    ${dateFormatter2.formatDateTime(act.createdAt)}
                                            </small>
                                        </div>
                                        <span class="badge-custom">${act.type}</span>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center text-muted py-4">
                                <i class="fas fa-info-circle fa-2x mb-2"></i>
                                <div class="small">Нет недавней активности</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Боковая панель -->
        <div class="col-lg-4 mb-4">
            <div class="card border-0 shadow-sm dashboard-card">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0"><i class="fas fa-user me-2"></i>Профиль</h5>
                </div>
                <div class="card-body">
                    <div class="user-avatar"><i class="fas fa-user"></i></div>
                    <h5 class="text-center mb-3">${user.login}</h5>
                    <div class="mb-3">
                        <table class="table table-sm table-borderless">
                            <tr>
                                <td width="30"><i class="fas fa-user-tag text-muted me-2"></i></td>
                                <td width="120"><strong>Логин:</strong></td>
                                <td>${user.login}</td>
                            </tr>
                            <tr>
                                <td><i class="fas fa-envelope text-muted me-2"></i></td>
                                <td><strong>Email:</strong></td>
                                <td>${user.email}</td>
                            </tr>
                            <c:choose>
                                <c:when test="${not empty user.phone}">
                                    <tr>
                                        <td><i class="fas fa-phone text-muted me-2"></i></td>
                                        <td><strong>Телефон:</strong></td>
                                        <td>${user.phone}</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td><i class="fas fa-phone text-muted me-2"></i></td>
                                        <td><strong>Телефон:</strong></td>
                                        <td><span class="text-muted fst-italic">Не указан</span></td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            <c:choose>
                                <c:when test="${not empty user.city}">
                                    <tr>
                                        <td><i class="fas fa-city text-muted me-2"></i></td>
                                        <td><strong>Город:</strong></td>
                                        <td>${user.city}</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td><i class="fas fa-city text-muted me-2"></i></td>
                                        <td><strong>Город:</strong></td>
                                        <td><span class="text-muted fst-italic">Не указан</span></td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            <tr>
                                <td><i class="fas fa-calendar text-muted me-2"></i></td>
                                <td><strong>Дата регистрации:</strong></td>
                                <td>
                                    <jsp:useBean id="dateFormatter3" class="com.blooddonor.util.DateFormatter"/>
                                    ${dateFormatter3.formatDateTime(user.createdAt)}
                                </td>
                            </tr>
                            <tr>
                                <td><i class="fas fa-user-check text-muted me-2"></i></td>
                                <td><strong>Статус:</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.active}">
                                            <span class="badge bg-success">Активен</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">Заблокирован</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-primary">
                            <i class="fas fa-edit me-2"></i>Редактировать профиль
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp"/>
