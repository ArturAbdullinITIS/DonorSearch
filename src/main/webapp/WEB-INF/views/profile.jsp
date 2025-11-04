<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"/>

<style>
    .profile-page-header {
        background: transparent;
        color: white;
        padding: 2rem 0;
        margin-bottom: 2rem;
    }
    .profile-tabs-container {
        background: rgba(255, 255, 255, 0.95);
        border-radius: 15px;
        padding: 2rem;
        box-shadow: 0 10px 25px rgba(0,0,0,0.15);
    }
    .nav-tabs {
        border-bottom: 2px solid #dee2e6;
        margin-bottom: 1.5rem;
    }
    .nav-tabs .nav-link {
        color: #495057;
        background-color: #f8f9fa;
        border: 1px solid #dee2e6;
        border-radius: 8px 8px 0 0;
        padding: 12px 24px;
        font-weight: 500;
        margin-right: 0.5rem;
        transition: all 0.2s ease;
    }
    .nav-tabs .nav-link:hover {
        background-color: #e9ecef;
        border-color: #dee2e6;
        color: #212529;
    }
    .nav-tabs .nav-link.active {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-color: #667eea;
        font-weight: 600;
    }
</style>

<div class="page-header profile-page-header">
    <div class="container">
        <h1 class="display-5 fw-bold"><i class="fas fa-user me-3"></i>Личный кабинет</h1>
        <p class="lead mb-0">Просмотр и редактирование данных</p>
    </div>
</div>

<div class="container">
    <div class="profile-tabs-container">
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

        <ul class="nav nav-tabs mb-4" id="profileTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="user-tab" data-bs-toggle="tab" data-bs-target="#user" type="button" role="tab" aria-controls="user" aria-selected="true">
                    <i class="fas fa-user me-2"></i>Профиль
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="donor-tab" data-bs-toggle="tab" data-bs-target="#donor" type="button" role="tab" aria-controls="donor" aria-selected="false">
                    <i class="fas fa-hand-holding-medical me-2"></i>Профиль донора
                </button>
            </li>
        </ul>

        <div class="tab-content" id="profileTabsContent">
            <!-- Вкладка пользовательского профиля -->
            <div class="tab-pane fade show active" id="user" role="tabpanel" aria-labelledby="user-tab">
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-white"><h5 class="mb-0"><i class="fas fa-id-card me-2"></i>Мои данные</h5></div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/profile" method="post">
                            <input type="hidden" name="form" value="user">
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
                                        <input type="email" class="form-control" id="email" name="email" value="${user.email}" required>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="fullName" class="form-label">Полное имя</label>
                                        <input type="text" class="form-control" id="fullName" name="fullName" value="${user.fullName != null ? user.fullName : ''}">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="phone" class="form-label">Телефон</label>
                                        <input type="tel" class="form-control" id="phone" name="phone"
                                               value="${user.phone != null ? user.phone : ''}"
                                               placeholder="+7 (999) 123-45-67">
                                        <div class="invalid-feedback" id="phoneError">
                                            Введите номер телефона в правильном формате
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="city" class="form-label">Город</label>
                                <input type="text" class="form-control" id="city" name="city" value="${user.city != null ? user.city : ''}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Дата регистрации</label>
                                <jsp:useBean id="dateFormatter" class="com.blooddonor.util.DateFormatter"/>
                                <input type="text" class="form-control" value="${dateFormatter.formatDateTime(user.createdAt)}" readonly>
                            </div>
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left"></i> Назад в панель
                                </a>
                                <button type="submit" class="btn btn-primary" id="submitBtn">
                                    <i class="fas fa-save"></i> Сохранить
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Вкладка профиля донора -->
            <div class="tab-pane fade" id="donor" role="tabpanel" aria-labelledby="donor-tab">
                <div class="card shadow-sm">
                    <div class="card-header bg-white"><h5 class="mb-0"><i class="fas fa-hand-holding-medical me-2"></i>Профиль донора</h5></div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/profile" method="post">
                            <input type="hidden" name="form" value="donor">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="bloodType" class="form-label">Группа крови *</label>
                                        <select class="form-select" id="bloodType" name="bloodType" required>
                                            <option value="">Выберите...</option>
                                            <option value="O" ${donorProfile != null && donorProfile.bloodType == 'O' ? 'selected' : ''}>O (I)</option>
                                            <option value="A" ${donorProfile != null && donorProfile.bloodType == 'A' ? 'selected' : ''}>A (II)</option>
                                            <option value="B" ${donorProfile != null && donorProfile.bloodType == 'B' ? 'selected' : ''}>B (III)</option>
                                            <option value="AB" ${donorProfile != null && donorProfile.bloodType == 'AB' ? 'selected' : ''}>AB (IV)</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="rhFactor" class="form-label">Резус-фактор *</label>
                                        <select class="form-select" id="rhFactor" name="rhFactor" required>
                                            <option value="">Выберите...</option>
                                            <option value="POSITIVE" ${donorProfile != null && donorProfile.rhFactor == 'POSITIVE' ? 'selected' : ''}>Положительный (Rh+)</option>
                                            <option value="NEGATIVE" ${donorProfile != null && donorProfile.rhFactor == 'NEGATIVE' ? 'selected' : ''}>Отрицательный (Rh-)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="card border-success mb-3">
                                        <div class="card-body">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="readyToDonate" name="readyToDonate" ${donorProfile == null || donorProfile.readyToDonate ? 'checked' : ''}>
                                                <label class="form-check-label" for="readyToDonate">
                                                    <strong class="text-success">
                                                        <i class="fas fa-check-circle me-1"></i>Готов быть донором
                                                    </strong>
                                                </label>
                                            </div>
                                            <small class="text-muted d-block mt-2">
                                                Если отмечено, вы будете видны в поиске доноров и сможете откликаться на запросы.
                                                Снимите галочку, если временно не можете сдавать кровь.
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="additionalInfo" class="form-label">Дополнительная информация</label>
                                <textarea class="form-control" id="additionalInfo" name="additionalInfo" rows="3" placeholder="Например, предпочтительная больница, удобное время...">${donorProfile != null && donorProfile.additionalInfo != null ? donorProfile.additionalInfo : ''}</textarea>
                            </div>
                            <div class="d-flex justify-content-end">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Сохранить профиль донора
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/inputmask@5.0.8/dist/inputmask.min.js"></script>
<script>
    // Маска для телефона
    const phoneMask = new Inputmask("+7 (999) 999-99-99");
    phoneMask.mask(document.getElementById("phone"));

    // Валидация формы при отправке
    document.querySelector('form[action*="profile"]').addEventListener('submit', function(e) {
        const phoneInput = document.getElementById('phone');
        const phoneValue = phoneInput.value;

        // Если поле телефона заполнено, проверяем формат
        if (phoneValue && phoneValue.trim() !== '') {
            // Проверяем, что номер полностью заполнен (нет _ в маске)
            if (phoneValue.includes('_') || phoneValue.length < 18) {
                e.preventDefault(); // Останавливаем отправку формы
                phoneInput.classList.add('is-invalid');
                phoneInput.focus();
                return false;
            }
        }

        // Убираем ошибку если все ок
        phoneInput.classList.remove('is-invalid');
    });

    // Убираем ошибку при начале ввода
    document.getElementById('phone').addEventListener('input', function() {
        this.classList.remove('is-invalid');
    });
</script>
