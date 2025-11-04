package com.blooddonor.service;

import com.blooddonor.dao.DonorProfileDao;
import com.blooddonor.model.DonorProfile;

import java.sql.SQLException;
import java.util.List;

public class DonorProfileService {

    private final DonorProfileDao donorProfileDao;

    public DonorProfileService() {
        this.donorProfileDao = new DonorProfileDao();
    }

    public DonorProfile createDonorProfile(DonorProfile profile) throws SQLException {
        validateDonorProfile(profile);

        DonorProfile existing = donorProfileDao.findByUserId(profile.getUserId());
        if (existing != null) {
            throw new IllegalStateException("Профиль донора уже существует для этого пользователя");
        }

        return donorProfileDao.create(profile);
    }

    public DonorProfile getDonorProfileByUserId(Long userId) throws SQLException {
        return donorProfileDao.findByUserId(userId);
    }

    public DonorProfile getDonorProfileById(Long id) throws SQLException {
        return donorProfileDao.findById(id);
    }

    public void updateDonorProfile(DonorProfile profile) throws SQLException {
        validateDonorProfile(profile);
        donorProfileDao.update(profile);
    }

    public void deleteDonorProfile(Long id) throws SQLException {
        donorProfileDao.delete(id);
    }

    public List<DonorProfile> searchDonors(String bloodType, String rhFactor, String city) throws SQLException {
        return donorProfileDao.searchDonors(bloodType, rhFactor, city);
    }

    private void validateDonorProfile(DonorProfile profile) {
        if (profile.getUserId() == null) {
            throw new IllegalArgumentException("ID пользователя обязателен");
        }
        if (profile.getBloodType() == null || profile.getBloodType().trim().isEmpty()) {
            throw new IllegalArgumentException("Группа крови обязательна");
        }
        if (profile.getRhFactor() == null || profile.getRhFactor().trim().isEmpty()) {
            throw new IllegalArgumentException("Резус-фактор обязателен");
        }

        String bloodType = profile.getBloodType().toUpperCase();
        if (!bloodType.equals("A") && !bloodType.equals("B") &&
            !bloodType.equals("AB") && !bloodType.equals("O")) {
            throw new IllegalArgumentException("Некорректная группа крови");
        }

        String rhFactor = profile.getRhFactor().toUpperCase();
        if (!rhFactor.equals("POSITIVE") && !rhFactor.equals("NEGATIVE")) {
            throw new IllegalArgumentException("Некорректный резус-фактор");
        }
    }
}
