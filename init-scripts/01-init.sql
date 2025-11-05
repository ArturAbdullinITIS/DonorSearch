-- Таблица пользователей
CREATE TABLE IF NOT EXISTS users (
                                     id BIGSERIAL PRIMARY KEY,
                                     login VARCHAR(50) NOT NULL UNIQUE,
                                     password_hash VARCHAR(255) NOT NULL,
                                     email VARCHAR(100) NOT NULL UNIQUE,
                                     phone VARCHAR(20),
                                     city VARCHAR(100),
                                     full_name VARCHAR(100),
                                     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     is_active BOOLEAN DEFAULT TRUE
);

-- Таблица профилей доноров
CREATE TABLE IF NOT EXISTS donor_profiles (
                                              id BIGSERIAL PRIMARY KEY,
                                              user_id BIGINT NOT NULL UNIQUE,
                                              blood_type VARCHAR(2) NOT NULL CHECK (blood_type IN ('A', 'B', 'AB', 'O')),
                                              rh_factor VARCHAR(8) NOT NULL CHECK (rh_factor IN ('POSITIVE', 'NEGATIVE')),
                                              is_ready_to_donate BOOLEAN DEFAULT TRUE,
                                              additional_info TEXT,
                                              FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Таблица запросов на донорство
CREATE TABLE IF NOT EXISTS donation_requests (
                                                 id BIGSERIAL PRIMARY KEY,
                                                 author_id BIGINT NOT NULL,
                                                 patient_name VARCHAR(100) NOT NULL,
                                                 blood_type_needed VARCHAR(2) NOT NULL CHECK (blood_type_needed IN ('A', 'B', 'AB', 'O')),
                                                 rh_factor_needed VARCHAR(8) NOT NULL CHECK (rh_factor_needed IN ('POSITIVE', 'NEGATIVE')),
                                                 hospital_name VARCHAR(200) NOT NULL,
                                                 hospital_address TEXT NOT NULL,
                                                 urgency VARCHAR(8) NOT NULL CHECK (urgency IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')) DEFAULT 'MEDIUM',
                                                 description TEXT,
                                                 contact_info TEXT NOT NULL,
                                                 status VARCHAR(10) NOT NULL CHECK (status IN ('ACTIVE', 'FULFILLED', 'CANCELLED')) DEFAULT 'ACTIVE',
                                                 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица откликов на запросы
CREATE TABLE IF NOT EXISTS responses (
                                         id BIGSERIAL PRIMARY KEY,
                                         request_id BIGINT NOT NULL,
                                         donor_id BIGINT NOT NULL,
                                         message TEXT,
                                         response_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                         status VARCHAR(10) NOT NULL CHECK (status IN ('PENDING', 'CONTACTED', 'REJECTED')) DEFAULT 'PENDING',
                                         FOREIGN KEY (request_id) REFERENCES donation_requests(id) ON DELETE CASCADE,
                                         FOREIGN KEY (donor_id) REFERENCES users(id) ON DELETE CASCADE,
                                         UNIQUE (request_id, donor_id)
);

-- Таблица активности пользователей
CREATE TABLE IF NOT EXISTS activities (
                                          id BIGSERIAL PRIMARY KEY,
                                          user_id BIGINT NOT NULL,
                                          type VARCHAR(50) NOT NULL,
                                          title VARCHAR(200) NOT NULL,
                                          description TEXT,
                                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


CREATE INDEX IF NOT EXISTS idx_donor_profiles_blood ON donor_profiles(blood_type, rh_factor, is_ready_to_donate);
CREATE INDEX IF NOT EXISTS idx_requests_blood ON donation_requests(blood_type_needed, rh_factor_needed, status);
CREATE INDEX IF NOT EXISTS idx_requests_author ON donation_requests(author_id);
CREATE INDEX IF NOT EXISTS idx_responses_donor ON responses(donor_id);
CREATE INDEX IF NOT EXISTS idx_responses_request ON responses(request_id);
CREATE INDEX IF NOT EXISTS idx_activities_user ON activities(user_id, created_at DESC);


CREATE OR REPLACE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_donation_requests_updated_at
    BEFORE UPDATE ON donation_requests
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();