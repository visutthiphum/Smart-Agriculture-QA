
CREATE DATABASE IF NOT EXISTS smart_farm_db;
USE smart_farm_db;

CREATE TABLE IF NOT EXISTS telemetry_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    temperature FLOAT NOT NULL,
    humidity FLOAT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS warehouse_inventory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    apple_count INT DEFAULT 0,
    mango_count INT DEFAULT 0,
    orange_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
