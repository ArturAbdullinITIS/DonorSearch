package com.blooddonor.service;

import com.blooddonor.dao.ResponseDao;
import com.blooddonor.dao.DonationRequestDao;
import com.blooddonor.model.Response;
import com.blooddonor.model.DonationRequest;

import java.sql.SQLException;
import java.util.List;

public class ResponseService {

    private final ResponseDao responseDao;
    private final DonationRequestDao requestDao;

    public ResponseService() {
        this.responseDao = new ResponseDao();
        this.requestDao = new DonationRequestDao();
    }

    public Response createResponse(Response response) throws SQLException {
        validateResponse(response);

        DonationRequest request = requestDao.findById(response.getRequestId());
        if (request == null) {
            throw new IllegalArgumentException("Запрос не найден");
        }

        if (!request.getStatus().equals("ACTIVE")) {
            throw new IllegalStateException("Нельзя откликнуться на неактивный запрос");
        }

        if (request.getAuthorId().equals(response.getDonorId())) {
            throw new IllegalStateException("Вы не можете откликнуться на собственный запрос");
        }

        if (responseDao.hasUserResponded(response.getRequestId(), response.getDonorId())) {
            throw new IllegalStateException("Вы уже откликнулись на этот запрос");
        }

        response.setStatus("PENDING");
        return responseDao.create(response);
    }

    public List<Response> getResponsesByRequest(Long requestId) throws SQLException {
        return responseDao.findByRequest(requestId);
    }

    public List<Response> getResponsesByDonor(Long donorId) throws SQLException {
        return responseDao.findByDonor(donorId);
    }

    public void updateResponseStatus(Long responseId, String status) throws SQLException {
        if (!status.equals("PENDING") && !status.equals("CONTACTED") && !status.equals("REJECTED")) {
            throw new IllegalArgumentException("Некорректный статус");
        }

        responseDao.updateStatus(responseId, status);
    }

    public void deleteResponse(Long responseId) throws SQLException {
        responseDao.delete(responseId);
    }

    private void validateResponse(Response response) {
        if (response.getRequestId() == null) {
            throw new IllegalArgumentException("ID запроса обязателен");
        }
        if (response.getDonorId() == null) {
            throw new IllegalArgumentException("ID донора обязателен");
        }
    }
}
