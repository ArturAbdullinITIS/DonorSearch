<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Личный кабинет - Система доноров крови</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .profile-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            margin-top: 50px;
            margin-bottom: 50px;
        }
        .profile-header {
            background: #667eea;
            color: white;
            padding: 2rem;
            border-radius: 15px 15px 0 0;
            text-align: center;
        }
        .profile-content {
            padding: 2rem;
        }
        .user-avatar {
            width: 100px;
            height: 100px;
            background: #e9ecef;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 2.5rem;
            color: #667eea;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-10 col-lg-8">
            <div class="profile-container">
                <!-- Заголовок -->
                <div class="profile-header">
                    <div class="user-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <h1>Личный кабинет</h1>
                    <p class="mb-0">Управление вашим профилем</p>
                </div>

                <!-- Контент -->
                <div class="profile-content">
                    <!-- Уведомления -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <strong>Успех!</strong> ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Ошибка!</strong> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/profile" method="post">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Логин</label>
                                    <input type="text" class="form-control" value="${user.login}" readonly>
                                    <div class="form-text">Логин нельзя изменить</div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email *</label>
                                    <input type="email" class="form-control" id="email" name="email"
                                           value="${user.email}" required>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="fullName" class="form-label">Полное имя</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName"
                                           value="${user.fullName != null ? user.fullName : ''}"
                                           placeholder="Введите ваше полное имя">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="phone" class="form-label">Телефон</label>
                                    <input type="tel" class="form-control" id="phone" name="phone"
                                           value="${user.phone != null ? user.phone : ''}"
                                           placeholder="+7 (999) 123-45-67">
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="city" class="form-label">Город</label>
                            <input type="text" class="form-control" id="city" name="city"
                                   value="${user.city != null ? user.city : ''}"
                                   placeholder="Введите ваш город">
                        </div>

                        <!-- ТОЛЬКО ОДНО поле даты регистрации -->
                        <div class="mb-3">
                            <label class="form-label">Дата регистрации</label>
                            <input type="text" class="form-control"
                                   value="<jsp:useBean id="dateFormatter" class="com.blooddonor.util.DateFormatter"/>${dateFormatter.formatDateTime(user.createdAt)}"
                                   readonly>
                            <div class="form-text">Дата автоматической регистрации в системе</div>
                        </div>

                        <!-- Кнопки действий -->
                        <div class="border-top pt-4 mt-4">
                            <div class="row">
                                <div class="col-md-6">
                                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-secondary">
                                        <i class="fas fa-arrow-left"></i> Назад в панель управления
                                    </a>
                                </div>
                                <div class="col-md-6 text-end">
                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Сохранить изменения
                                        </button>
                                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger ms-2">
                                            <i class="fas fa-sign-out-alt"></i> Выйти
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>