<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            💉 Система доноров крови
        </a>

        <div class="navbar-nav ms-auto">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a class="nav-link" href="${pageContext.request.contextPath}/profile">
                        👤 ${sessionScope.user.login}
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                        🚪 Выйти
                    </a>
                </c:when>
                <c:otherwise>
                    <a class="nav-link" href="${pageContext.request.contextPath}/login">
                        🔑 Войти
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/register">
                        📝 Регистрация
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>