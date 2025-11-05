<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Система доноров крови</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        .main-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .logo-icon {
            font-size: 4rem;
            color: #ff6b6b;
            margin-bottom: 1rem;
        }
        .feature-item {
            padding: 1.5rem;
            border-radius: 15px;
            background: rgba(255, 255, 255, 0.8);
            margin-bottom: 1rem;
            border-left: 4px solid #667eea;
            transition: all 0.3s ease;
        }
        .feature-item:hover {
            transform: translateX(10px);
            background: white;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="main-card p-5">
                <!-- Заголовок -->
                <div class="text-center mb-5">
                    <div class="logo-icon">💉</div>
                    <h1 class="display-5 fw-bold text-dark mb-3">Система доноров крови</h1>
                    <p class="lead text-muted">Помогаем находить доноров и спасать жизни</p>
                </div>

                <!-- Уведомления -->
                <c:if test="${not empty param.logout}">
                    <div class="alert alert-info alert-dismissible fade show" role="alert">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Вы успешно вышли из системы</strong>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty param.registered}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        <strong>Регистрация прошла успешно!</strong> Теперь вы можете войти в систему.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty param.deleted}">
                    <div class="alert alert-warning alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Профиль удален</strong> Ваш аккаунт был успешно деактивирован.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Функционал -->
                <div class="row mb-5">
                    <div class="col-md-6">
                        <div class="feature-item">
                            <div class="d-flex align-items-center mb-2">
                                <i class="fas fa-search text-primary me-3 fs-4"></i>
                                <h5 class="mb-0">Найти донора</h5>
                            </div>
                            <p class="text-muted mb-0">Опубликуйте запрос на поиск донора с нужной группой крови в вашем городе</p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="feature-item">
                            <div class="d-flex align-items-center mb-2">
                                <i class="fas fa-heart text-danger me-3 fs-4"></i>
                                <h5 class="mb-0">Стать донором</h5>
                            </div>
                            <p class="text-muted mb-0">Зарегистрируйтесь как донор и помогайте спасать жизни людей</p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="feature-item">
                            <div class="d-flex align-items-center mb-2">
                                <i class="fas fa-handshake text-success me-3 fs-4"></i>
                                <h5 class="mb-0">Откликнуться на запрос</h5>
                            </div>
                            <p class="text-muted mb-0">Помогите людям, которые нуждаются в донорской крови</p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="feature-item">
                            <div class="d-flex align-items-center mb-2">
                                <i class="fas fa-users text-warning me-3 fs-4"></i>
                                <h5 class="mb-0">Сообщество</h5>
                            </div>
                            <p class="text-muted mb-0">Присоединяйтесь к сообществу людей, готовых помочь в трудную минуту</p>
                        </div>
                    </div>
                </div>

                <!-- Кнопки входа/регистрации -->
                <div class="text-center">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <p class="text-muted mb-3">
                                <i class="fas fa-user-circle me-2"></i>
                                Вы вошли как <strong>${sessionScope.user.login}</strong>
                            </p>
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary btn-lg me-3">
                                <i class="fas fa-tachometer-alt me-2"></i>Панель управления
                            </a>
                            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-primary btn-lg">
                                <i class="fas fa-sign-out-alt me-2"></i>Выйти
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-lg me-3">
                                <i class="fas fa-sign-in-alt me-2"></i>Войти в систему
                            </a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-primary btn-lg">
                                <i class="fas fa-user-plus me-2"></i>Зарегистрироваться
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Футер -->
                <div class="text-center mt-5 pt-4 border-top">
                    <p class="text-muted small mb-0">
                        <i class="fas fa-shield-alt me-2"></i>
                        Ваши данные защищены и используются только для организации донорства
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>