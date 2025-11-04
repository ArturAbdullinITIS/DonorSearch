package com.blooddonor.service;

import com.blooddonor.dao.DonationRequestDao;
import com.blooddonor.model.DonationRequest;

import java.sql.SQLException;
import java.util.List;

public class DonationRequestService {

    private final DonationRequestDao requestDao;

    public DonationRequestService() {
        this.requestDao = new DonationRequestDao();
    }

    public DonationRequest createRequest(DonationRequest request) throws SQLException {
        validateRequest(request);
        request.setStatus("ACTIVE");
        return requestDao.create(request);
    }

    public DonationRequest getRequestById(Long id) throws SQLException {
        return requestDao.findById(id);
    }

    public List<DonationRequest> getAllActiveRequests() throws SQLException {
        return requestDao.findAll();
    }

    public List<DonationRequest> getRequestsByAuthor(Long authorId) throws SQLException {
        return requestDao.findByAuthor(authorId);
    }

    public List<DonationRequest> searchByBloodType(String bloodType, String rhFactor) throws SQLException {
        return requestDao.searchByBloodType(bloodType, rhFactor);
    }

    public void updateRequest(DonationRequest request) throws SQLException {
        validateRequest(request);
        requestDao.update(request);
    }

    public void closeRequest(Long id) throws SQLException {
        DonationRequest request = requestDao.findById(id);
        if (request != null) {
            request.setStatus("FULFILLED");
            requestDao.update(request);
        }
    }

    public void deleteRequest(Long id) throws SQLException {
        requestDao.delete(id);
    }

    private void validateRequest(DonationRequest request) {
        if (request.getPatientName() == null || request.getPatientName().trim().isEmpty()) {
            throw new IllegalArgumentException("Имя пациента обязательно");
        }
        if (request.getBloodTypeNeeded() == null || request.getBloodTypeNeeded().trim().isEmpty()) {
            throw new IllegalArgumentException("Группа крови обязательна");
        }
        if (request.getRhFactorNeeded() == null || request.getRhFactorNeeded().trim().isEmpty()) {
            throw new IllegalArgumentException("Резус-фактор обязателен");
        }
        if (request.getCity() == null || request.getCity().trim().isEmpty()) {
            throw new IllegalArgumentException("Город обязателен");
        }
        if (request.getHospital() == null || request.getHospital().trim().isEmpty()) {
            throw new IllegalArgumentException("Больница обязательна");
        }
        if (request.getContactInfo() == null || request.getContactInfo().trim().isEmpty()) {
            throw new IllegalArgumentException("Контактная информация обязательна");
        }
    }
}
