USE mindwell_nepal;

ALTER TABLE users
  MODIFY password VARCHAR(255) NOT NULL;

ALTER TABLE users
  MODIFY user_type ENUM('user', 'counselor', 'admin', 'super_admin') NOT NULL DEFAULT 'user';

ALTER TABLE users
  ADD COLUMN IF NOT EXISTS requested_user_type ENUM('user', 'counselor', 'admin') NOT NULL DEFAULT 'user' AFTER user_type;

ALTER TABLE users
  ADD COLUMN IF NOT EXISTS account_status ENUM('pending', 'approved', 'rejected', 'disabled') NOT NULL DEFAULT 'approved' AFTER requested_user_type;

UPDATE users
SET requested_user_type = user_type
WHERE requested_user_type = 'user' AND user_type IN ('user', 'counselor', 'admin');

UPDATE users
SET account_status = 'approved'
WHERE account_status IS NULL OR account_status = '';

UPDATE counselors
SET is_verified = TRUE
WHERE is_verified IS NULL;

INSERT INTO users (full_name, email, password, phone, city, user_type, requested_user_type, account_status)
VALUES (
  'Super Admin',
  'admin@mindwell.local',
  'pbkdf2$120000$uhXDZnsca6abGyloaYd7lA==$6hXthokkCuhb3k4//f//QyoJj0KXYqOPbeG1EGhMHQw=',
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
