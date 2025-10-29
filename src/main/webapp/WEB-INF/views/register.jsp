<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Регистрация - Система доноров крови</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        .register-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        .register-header {
            background: #667eea;
            color: white;
            padding: 2rem;
            text-align: center;
        }
        .register-form {
            padding: 2rem;
        }
        .btn-register {
            background: #667eea;
            border-color: #667eea;
            color: white;
        }
        .btn-register:hover {
            background: #5a6fd8;
            border-color: #5a6fd8;
            color: white;
        }
        .password-toggle {
            cursor: pointer;
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        .password-input-group {
            position: relative;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="register-container">
                <div class="register-header">
                    <h1><i class="fas fa-user-plus"></i> Регистрация</h1>
                    <p class="mb-0">Присоединяйтесь к сообществу доноров</p>
                </div>

                <div class="register-form">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Ошибка!</strong> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <strong>Успех!</strong> ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/register" method="post">
                        <div class="mb-3">
                            <label for="login" class="form-label">Логин *</label>
                            <input type="text"
                                   class="form-control"
                                   id="login"
                                   name="login"
                                   value="${param.login}"
                                   required
                                   placeholder="Придумайте логин">
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Email *</label>
                            <input type="email"
                                   class="form-control"
                                   id="email"
                                   name="email"
                                   value="${param.email}"
                                   required
                                   placeholder="example@mail.ru">
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="password" class="form-label">Пароль *</label>
                                    <div class="password-input-group">
                                        <input type="password"
                                               class="form-control"
                                               id="password"
                                               name="password"
                                               required
                                               placeholder="Не менее 6 символов">
                                        <span class="password-toggle" onclick="togglePassword('password')">
                                            <i class="fas fa-eye"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="confirmPassword" class="form-label">Подтверждение пароля *</label>
                                    <div class="password-input-group">
                                        <input type="password"
                                               class="form-control"
                                               id="confirmPassword"
                                               name="confirmPassword"
                                               required
                                               placeholder="Повторите пароль">
                                        <span class="password-toggle" onclick="togglePassword('confirmPassword')">
                                            <i class="fas fa-eye"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-register btn-lg">
                                📝 Зарегистрироваться
                            </button>
                        </div>
                    </form>

                    <div class="text-center mt-3">
                        <p>Уже есть аккаунт?
                            <a href="${pageContext.request.contextPath}/login" class="text-decoration-none">
                                Войдите здесь
                            </a>
                        </p>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-sm">
                            ← На главную
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function togglePassword(inputId) {
        const passwordInput = document.getElementById(inputId);
        const toggleIcon = passwordInput.parentNode.querySelector('i');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggleIcon.classList.remove('fa-eye');
            toggleIcon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            toggleIcon.classList.remove('fa-eye-slash');
            toggleIcon.classList.add('fa-eye');
        }
    }

    // Дополнительная валидация паролей
    document.addEventListener('DOMContentLoaded', function() {
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');

        function validatePasswords() {
            if (password.value !== confirmPassword.value) {
                confirmPassword.setCustomValidity('Пароли не совпадают');
            } else {
                confirmPassword.setCustomValidity('');
            }
        }

        password.addEventListener('change', validatePasswords);
        confirmPassword.addEventListener('keyup', validatePasswords);
    });
</script>
</body>
</html>