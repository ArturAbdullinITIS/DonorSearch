package com.blooddonor.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class DateFormatter {

    private static final DateTimeFormatter DATE_TIME_FORMATTER =
            DateTimeFormatter.ofPattern("dd.MM.yyyy в HH:mm", new Locale("ru"));

    private static final DateTimeFormatter DATE_FORMATTER =
            DateTimeFormatter.ofPattern("dd.MM.yyyy", new Locale("ru"));

    private static final DateTimeFormatter SHORT_DATE_FORMATTER =
            DateTimeFormatter.ofPattern("dd.MM.yy", new Locale("ru"));


    public static String formatDateTime(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "Не указано";
        }
        return dateTime.format(DATE_TIME_FORMATTER);
    }

    public static String formatDate(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "Не указано";
        }
        return dateTime.format(DATE_FORMATTER);
    }

    public static String formatShortDate(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "Не указано";
        }
        return dateTime.format(SHORT_DATE_FORMATTER);
    }

    public static String getRelativeTime(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "Не указано";
        }

        LocalDateTime now = LocalDateTime.now();
        long daysBetween = java.time.Duration.between(dateTime, now).toDays();

        if (daysBetween == 0) {
            return "Сегодня";
        } else if (daysBetween == 1) {
            return "Вчера";
        } else if (daysBetween < 7) {
            return daysBetween + " дня назад";
        } else if (daysBetween < 30) {
            long weeks = daysBetween / 7;
            return weeks + " недели назад";
        } else {
            return formatDate(dateTime);
        }
    }
}