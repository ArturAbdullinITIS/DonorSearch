<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"/>

<style>
    .card {
        border-radius: 15px;
        overflow: hidden;
    }
    .card-header {
        padding: 1rem 1.25rem !important;
        border-radius: 15px 15px 0 0 !important;
    }
    .card-body {
        padding: 1.25rem !important;
        border-radius: 0 !important;
    }
</style>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card shadow-sm border-0">
                <div class="card-header text-white" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <h4 class="mb-0 text-center"><i class="fas fa-user-plus me-2"></i>Регистрация</h4>
                </div>
                <div class="card-body">
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
                            <input type="text" class="form-control" id="login" name="login" value="${param.login}" required placeholder="Придумайте логин">
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Email *</label>
                            <input type="email" class="form-control" id="email" name="email" value="${param.email}" required placeholder="example@mail.ru">
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="password" class="form-label">Пароль *</label>
                                    <div class="position-relative">
                                        <input type="password" class="form-control" id="password" name="password" required placeholder="Не менее 6 символов">
                                        <span class="position-absolute top-50 end-0 translate-middle-y me-3 text-muted" style="cursor:pointer" onclick="togglePassword('password')">
                                            <i class="fas fa-eye"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="confirmPassword" class="form-label">Подтверждение пароля *</label>
                                    <div class="position-relative">
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required placeholder="Повторите пароль">
                                        <span class="position-absolute top-50 end-0 translate-middle-y me-3 text-muted" style="cursor:pointer" onclick="togglePassword('confirmPassword')">
                                            <i class="fas fa-eye"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-user-check me-2"></i> Зарегистрироваться
                            </button>
                        </div>
                    </form>

                    <div class="text-center mt-3">
                        <a href="${pageContext.request.contextPath}/login" class="text-decoration-none">Уже есть аккаунт? Войдите</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp"/>

<script>
    function togglePassword(inputId) {
        const input = document.getElementById(inputId);
        const icon = input.parentNode.querySelector('i');
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.replace('fa-eye-slash', 'fa-eye');
        }
    }
</script>
