# Конфигурация базы данных

## Настройка

1. Скопируйте файл `database.properties.example` в `database.properties`:
   ```bash
   cp src/main/resources/database.properties.example src/main/resources/database.properties
   ```

2. Отредактируйте `database.properties` и замените `YOUR_PASSWORD_HERE` на реальный пароль

3. **ВАЖНО**: Никогда не коммитьте файл `database.properties` в Git!

## Безопасность

Файл `database.properties` уже добавлен в `.gitignore` и не должен попадать в репозиторий.
Используйте только `database.properties.example` как шаблон для других разработчиков.

