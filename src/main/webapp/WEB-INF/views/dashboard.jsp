<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Панель управления - Система доноров крови</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .dashboard-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
        }
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border-left: 4px solid #667eea;
            transition: all 0.3s ease;
            height: 100%;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 0.5rem;
        }
        .quick-action {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border: 2px solid transparent;
            height: 100%;
        }
        .quick-action:hover {
            border-color: #667eea;
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .action-icon {
            font-size: 3rem;
            color: #667eea;
            margin-bottom: 1rem;
        }
        .nav-tabs .nav-link.active {
            background: #667eea;
            color: white;
            border: none;
            border-radius: 10px 10px 0 0;
        }
        .nav-tabs .nav-link {
            color: #667eea;
            border: none;
            border-radius: 10px 10px 0 0;
            padding: 12px 24px;
            font-weight: 500;
        }
        .nav-tabs {
            border-bottom: 2px solid #dee2e6;
        }
        .user-avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 2rem;
            color: white;
        }
        .recent-activity {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .activity-item {
            padding: 1rem;
            border-left: 3px solid #667eea;
            margin-bottom: 1rem;
            background: #f8f9fa;
            border-radius: 0 8px 8px 0;
        }
        .badge-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 500;
        }
    </style>
</head>
<body>
<!-- Хедер -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
            <i class="fas fa-tachometer-alt me-2"></i>Панель управления
        </a>
        <div class="navbar-nav ms-auto">
                <span class="navbar-text me-3">
                    <i class="fas fa-user-circle me-2"></i>Привет, <strong>${user.login}</strong>!
                </span>
            <a class="nav-link" href="${pageContext.request.contextPath}/profile">
                <i class="fas fa-user me-1"></i> Профиль
            </a>
            <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                <i class="fas fa-sign-out-alt me-1"></i> Выйти
            </a>
        </div>
    </div>
</nav>

<!-- Основной контент -->
<div class="dashboard-header">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h1 class="display-5 fw-bold">Добро пожаловать в систему!</h1>
                <p class="lead mb-0">Управляйте вашими донорскими активностями и помогайте спасать жизни</p>
            </div>
            <div class="col-md-4 text-end">
                <div class="bg-white text-dark rounded p-3 d-inline-block">
                    <small class="text-muted">ID пользователя</small>
                    <div class="fw-bold fs-4">#${user.id}</div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <!-- Статистика -->
    <div class="row mb-5">
        <div class="col-md-3 mb-4">
            <div class="stat-card">
                <div class="stat-number">0</div>
                <div class="text-muted">
                    <i class="fas fa-clipboard-list me-2"></i>Мои запросы
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-4">
            <div class="stat-card">
                <div class="stat-number">0</div>
                <div class="text-muted">
                    <i class="fas fa-handshake me-2"></i>Активные отклики
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-4">
            <div class="stat-card">
                <div class="stat-number">0</div>
                <div class="text-muted">
                    <i class="fas fa-heart me-2"></i>Помощь оказана
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-4">
            <div class="stat-card">
                <div class="stat-number">
                    <jsp:useBean id="dateFormatter" class="com.blooddonor.util.DateFormatter"/>
                    ${dateFormatter.formatShortDate(user.createdAt)}
                </div>
                <div class="text-muted">
                    <i class="fas fa-calendar me-2"></i>С нами с
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Основной контент -->
        <div class="col-lg-8">
            <!-- Быстрые действия -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-white border-0 py-3">
                    <h4 class="mb-0">
                        <i class="fas fa-bolt text-warning me-2"></i>Быстрые действия
                    </h4>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <div class="quick-action">
                                <div class="action-icon">🩸</div>
                                <h5>Создать запрос</h5>
                                <p class="text-muted small mb-3">Опубликуйте запрос на поиск донора с нужной группой крови</p>
                                <button class="btn btn-primary" disabled>
                                    <i class="fas fa-plus me-2"></i>Создать запрос
                                </button>
                            </div>
                        </div>
                        <div class="col-md-6 mb-4">
                            <div class="quick-action">
                                <div class="action-icon">❤️</div>
                                <h5>Стать донором</h5>
                                <p class="text-muted small mb-3">Заполните донорский профиль и укажите вашу группу крови</p>
                                <button class="btn btn-primary" disabled>
                                    <i class="fas fa-user-plus me-2"></i>Заполнить профиль
                                </button>
                            </div>
                        </div>
                        <div class="col-md-6 mb-4">
                            <div class="quick-action">
                                <div class="action-icon">👥</div>
                                <h5>Найти доноров</h5>
                                <p class="text-muted small mb-3">Поиск доноров по группе крови и местоположению</p>
                                <button class="btn btn-primary" disabled>
                                    <i class="fas fa-search me-2"></i>Найти доноров
                                </button>
                            </div>
                        </div>
                        <div class="col-md-6 mb-4">
                            <div class="quick-action">
                                <div class="action-icon">📊</div>
                                <h5>Моя статистика</h5>
                                <p class="text-muted small mb-3">Просмотр вашей донорской активности и достижений</p>
                                <button class="btn btn-primary" disabled>
                                    <i class="fas fa-chart-bar me-2"></i>Посмотреть
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Последняя активность -->
            <div class="recent-activity">
                <h4 class="mb-4">
                    <i class="fas fa-history text-primary me-2"></i>Последняя активность
                </h4>
                <div class="activity-item">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <h6 class="mb-1">Добро пожаловать в систему!</h6>
                            <p class="text-muted mb-1">Вы успешно зарегистрировались в системе доноров крови</p>
                            <small class="text-muted">
                                <i class="fas fa-clock me-1"></i>
                                <jsp:useBean id="dateFormatter2" class="com.blooddonor.util.DateFormatter"/>
                                ${dateFormatter2.formatDateTime(user.createdAt)}
                            </small>
                        </div>
                        <span class="badge-custom">Регистрация</span>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <h6 class="mb-1">Заполните профиль донора</h6>
                            <p class="text-muted mb-1">Укажите вашу группу крови чтобы другие пользователи могли найти вас</p>
                            <small class="text-muted">
                                <i class="fas fa-clock me-1"></i>Рекомендуемое действие
                            </small>
                        </div>
                        <span class="badge bg-warning">Важно</span>
                    </div>
                </div>
                <div class="text-center py-3">
                    <p class="text-muted mb-0">Здесь будет отображаться ваша активность в системе</p>
                </div>
            </div>
        </div>

        <!-- Боковая панель -->
        <div class="col-lg-4">
            <!-- Информация о пользователе -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0">
                        <i class="fas fa-user me-2"></i>Полная информация о профиле
                    </h5>
                </div>
                <div class="card-body">
                    <div class="user-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <h5 class="text-center mb-3">${user.login}</h5>

                    <div class="mb-3">
                        <table class="table table-sm table-borderless">
                            <tr>
                                <td width="30"><i class="fas fa-id-card text-muted me-2"></i></td>
                                <td width="120"><strong>ID пользователя:</strong></td>
                                <td>#${user.id}</td>
                            </tr>
                            <tr>
                                <td><i class="fas fa-user-tag text-muted me-2"></i></td>
                                <td><strong>Логин:</strong></td>
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
                            <c:choose>
                                <c:when test="${not empty user.fullName}">
                                    <tr>
                                        <td><i class="fas fa-signature text-muted me-2"></i></td>
                                        <td><strong>Полное имя:</strong></td>
                                        <td>${user.fullName}</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td><i class="fas fa-signature text-muted me-2"></i></td>
                                        <td><strong>Полное имя:</strong></td>
                                        <td><span class="text-muted fst-italic">Не указано</span></td>
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
                                <td><strong>Статус аккаунта:</strong></td>
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

            <!-- Советы -->
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-success text-white py-3">
                    <h5 class="mb-0">
                        <i class="fas fa-lightbulb me-2"></i>Полезные советы
                    </h5>
                </div>
                <div class="card-body">
                    <div class="alert alert-info small">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Заполните донорский профиль</strong> - укажите вашу группу крови и резус-фактор
                    </div>
                    <div class="alert alert-warning small">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Обновляйте контакты</strong> - убедитесь что ваши телефон и email актуальны
                    </div>
                    <div class="alert alert-success small">
                        <i class="fas fa-heart me-2"></i>
                        <strong>Будьте готовы помочь</strong> - ваш отклик может спасти чью-то жизнь
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Футер -->
<footer class="bg-dark text-white mt-5 py-4">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <h5>💉 Система доноров крови</h5>
                <p class="mb-0 text-muted">Помогаем находить доноров и спасать жизни</p>
            </div>
            <div class="col-md-6 text-end">
                <p class="text-muted mb-0">
                    &copy; 2024 Система доноров крови. Все права защищены.
                </p>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>