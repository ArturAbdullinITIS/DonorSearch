<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Система доноров крови</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            padding: 100px 0;
            text-align: center;
        }
        .feature-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        .feature-card:hover {
            transform: translateY(-5px);
        }
    </style>
</head>
<body>
<!-- Герой секция -->
<div class="hero-section">
    <div class="container">
        <h1 class="display-4 mb-4">💉 Система доноров крови</h1>
        <p class="lead mb-4">Спасем жизни вместе. Найдите доноров или станьте одним из них.</p>

        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <div class="mt-4">
                    <p>Добро пожаловать, <strong>${sessionScope.user.login}</strong>!</p>
                    <a href="${pageContext.request.contextPath}/requests" class="btn btn-light btn-lg me-3">
                        📋 Мои запросы
                    </a>
                    <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-light btn-lg">
                        👤 Мой профиль
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-light btn-lg me-3">
                        🔑 Войти
                    </a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-light btn-lg">
                        📝 Зарегистрироваться
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Функционал -->
<div class="container my-5">
    <div class="row">
        <div class="col-md-4 mb-4">
            <div class="card feature-card h-100">
                <div class="card-body text-center">
                    <h3>🩸 Найти донора</h3>
                    <p>Опубликуйте запрос на поиск донора с нужной группой крови</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card feature-card h-100">
                <div class="card-body text-center">
                    <h3>❤️ Стать донором</h3>
                    <p>Зарегистрируйтесь как донор и помогайте спасать жизни</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card feature-card h-100">
                <div class="card-body text-center">
                    <h3>🤝 Сообщество</h3>
                    <p>Присоединяйтесь к сообществу людей, готовых помочь</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Статистика -->
<div class="bg-light py-5">
    <div class="container text-center">
        <h2 class="mb-4">Мы уже помогли</h2>
        <div class="row">
            <div class="col-md-3">
                <h3 class="text-danger">150+</h3>
                <p>доноров</p>
            </div>
            <div class="col-md-3">
                <h3 class="text-danger">50+</h3>
                <p>успешных донаций</p>
            </div>
            <div class="col-md-3">
                <h3 class="text-danger">30+</h3>
                <p>спасенных жизней</p>
            </div>
            <div class="col-md-3">
                <h3 class="text-danger">10+</h3>
                <p>городов</p>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>