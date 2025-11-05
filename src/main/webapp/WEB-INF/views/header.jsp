<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Система поиска доноров крови</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        main { flex: 1; }
        .navbar-brand { font-weight: 700; font-size: 1.2rem; }
        .footer {
            background-color: rgba(0,0,0,0.85);
            color: white;
            margin-top: auto;
        }
        .page-header { background: rgba(255,255,255,0.08); color: white; padding: 2rem 0; margin-bottom: 2rem; }
        .stat-card { background: rgba(255,255,255,0.95); border-radius: 15px; padding: 1.25rem; box-shadow: 0 10px 25px rgba(0,0,0,0.15); border-left: 4px solid #667eea; }
        .stat-number { font-size: 2rem; font-weight: 700; color: #667eea; margin-bottom: .25rem; }
        .quick-action { background: rgba(255,255,255,0.95); border-radius: 15px; padding: 1.5rem; text-align: center; box-shadow: 0 10px 25px rgba(0,0,0,0.15); border: 2px solid transparent; }
        .quick-action:hover { border-color: #667eea; transform: translateY(-2px); transition: all .2s ease; }
        .action-icon { font-size: 2.25rem; color: #667eea; margin-bottom: .75rem; }
        .user-avatar { width: 80px; height: 80px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 1rem; font-size: 2rem; color: white; }
        .recent-activity { background: rgba(255,255,255,0.95); border-radius: 15px; padding: 1.25rem; box-shadow: 0 10px 25px rgba(0,0,0,0.15); }
        .activity-item { padding: 1rem; border-left: 3px solid #667eea; margin-bottom: 1rem; background: #f8f9fa; border-radius: 0 8px 8px 0; }
        .badge-custom { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #fff; padding: 6px 12px; border-radius: 20px; font-weight: 500; }

        /* Глобальные стили для всех карточек */
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
        .card-footer {
            padding: 1rem 1.25rem !important;
            border-radius: 0 0 15px 15px !important;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark" style="background-color: rgba(0,0,0,0.6);">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">
            <i class="fas fa-heart-pulse me-2"></i>Система доноров крови
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <c:if test="${not empty sessionScope.user}">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/requests/all"><i class="fas fa-list"></i> Активные запросы</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/requests"><i class="fas fa-folder-open"></i> Мои запросы</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/responses"><i class="fas fa-comments"></i> Мои отклики</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/search"><i class="fas fa-search"></i> Поиск доноров</a></li>
                </ul>
            </c:if>
            <ul class="navbar-nav ms-auto">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-user-circle"></i> ${sessionScope.user.login}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> Мой профиль</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Выйти</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/login"><i class="fas fa-sign-in-alt"></i> Войти</a></li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/register"><i class="fas fa-user-plus"></i> Регистрация</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<main>
    <div class="container mt-4">
