DROP DATABASE IF EXISTS mindwell_nepal;

CREATE DATABASE mindwell_nepal
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE mindwell_nepal;

CREATE TABLE IF NOT EXISTS users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(160) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(30),
  city VARCHAR(80),
  user_type ENUM('user', 'counselor', 'admin', 'super_admin') NOT NULL DEFAULT 'user',
  requested_user_type ENUM('user', 'counselor', 'admin') NOT NULL DEFAULT 'user',
  account_status ENUM('pending', 'approved', 'rejected', 'disabled') NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS counselors (
  counselor_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  specialization VARCHAR(120) NOT NULL,
  experience_years INT NOT NULL DEFAULT 0,
  bio TEXT,
  consultation_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  is_available BOOLEAN NOT NULL DEFAULT TRUE,
  is_verified BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_counselors_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bookings (
  booking_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  counselor_id INT NOT NULL,
  booking_date DATE NOT NULL,
  booking_time TIME NOT NULL,
  message TEXT,
  status ENUM('pending', 'confirmed', 'cancelled', 'completed') NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_bookings_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_bookings_counselor
    FOREIGN KEY (counselor_id) REFERENCES counselors(counselor_id)
    ON DELETE CASCADE,
  INDEX idx_bookings_user (user_id),
  INDEX idx_bookings_counselor_date_time (counselor_id, booking_date, booking_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO users (full_name, email, password, phone, city, user_type, requested_user_type, account_status)
VALUES (
  'Super Admin',
  'admin@mindwell.local',
  'Admin@12345',
  NULL,
  'Kathmandu',
  'super_admin',
  'admin',
  'approved'
)
ON DUPLICATE KEY UPDATE
  user_type = 'super_admin',
  requested_user_type = 'admin',
  account_status = 'approved';

INSERT INTO users (full_name, email, password, phone, city, user_type, requested_user_type, account_status)
VALUES
  (
    'Aarav Sharma',
    'aarav.user@mindwell.local',
    'User@12345',
    '9800000001',
    'Kathmandu',
    'user',
    'user',
    'approved'
  ),
  (
    'Maya Gurung',
    'maya.user@mindwell.local',
    'User@12345',
    '9800000002',
    'Pokhara',
    'user',
    'user',
    'approved'
  ),
  (
    'Pending Client',
    'pending.user@mindwell.local',
    'User@12345',
    '9800000003',
    'Lalitpur',
    'user',
    'user',
    'pending'
  ),
  (
    'Dr. Sita Karki',
    'sita.counselor@mindwell.local',
    'Counselor@12345',
    '9810000001',
    'Kathmandu',
    'counselor',
    'counselor',
    'approved'
  ),
  (
    'Dr. Raj Thapa',
    'raj.counselor@mindwell.local',
    'Counselor@12345',
    '9810000002',
    'Bhaktapur',
    'counselor',
    'counselor',
    'approved'
  ),
  (
    'Nisha Lama',
    'nisha.pending@mindwell.local',
    'Counselor@12345',
    '9810000003',
    'Dharan',
    'user',
    'counselor',
    'pending'
  );

INSERT INTO counselors (user_id, specialization, experience_years, bio, consultation_fee, is_available, is_verified)
VALUES
  (
    (SELECT user_id FROM users WHERE email = 'sita.counselor@mindwell.local'),
    'Anxiety, Depression, CBT',
    8,
    'Licensed counselor focused on anxiety, depression, stress management, and culturally sensitive care.',
    1800.00,
    TRUE,
    TRUE
  ),
  (
    (SELECT user_id FROM users WHERE email = 'raj.counselor@mindwell.local'),
    'Family Therapy, Youth Counseling',
    6,
    'Counselor supporting families, young adults, and students through relationship and academic pressure.',
    1500.00,
    TRUE,
    TRUE
  ),
  (
    (SELECT user_id FROM users WHERE email = 'nisha.pending@mindwell.local'),
    'Trauma Support, Mindfulness',
    4,
    'Counselor applicant awaiting admin verification before becoming visible for booking.',
    1200.00,
    FALSE,
    FALSE
  );

INSERT INTO bookings (user_id, counselor_id, booking_date, booking_time, message, status)
VALUES
  (
    (SELECT user_id FROM users WHERE email = 'aarav.user@mindwell.local'),
    (SELECT counselor_id FROM counselors c JOIN users u ON c.user_id = u.user_id WHERE u.email = 'sita.counselor@mindwell.local'),
    DATE_ADD(CURDATE(), INTERVAL 2 DAY),
    '10:00:00',
    'I would like support managing workplace stress.',
    'pending'
  ),
  (
    (SELECT user_id FROM users WHERE email = 'maya.user@mindwell.local'),
    (SELECT counselor_id FROM counselors c JOIN users u ON c.user_id = u.user_id WHERE u.email = 'raj.counselor@mindwell.local'),
    DATE_ADD(CURDATE(), INTERVAL 4 DAY),
    '14:00:00',
    'Looking for guidance with family communication.',
    'confirmed'
  ),
  (
    (SELECT user_id FROM users WHERE email = 'aarav.user@mindwell.local'),
    (SELECT counselor_id FROM counselors c JOIN users u ON c.user_id = u.user_id WHERE u.email = 'raj.counselor@mindwell.local'),
    DATE_SUB(CURDATE(), INTERVAL 5 DAY),
    '11:00:00',
    'Follow-up session.',
    'completed'
  );
