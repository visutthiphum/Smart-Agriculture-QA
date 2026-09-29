# Smart-Agriculture-QA

## Project Overview

ระบบ Smart Agriculture สำหรับตรวจวัดสภาพแวดล้อมและตรวจนับผลไม้

## Project Structure

- `hardware/` - ESP32 + DHT11
- `ai_engine/` - YOLOv8 Fruit Detection
- `backend/` - PHP API + MySQL
- `mobile_app/` - Flutter Dashboard

## System Components

1. ESP32 อ่านค่าอุณหภูมิและความชื้นจาก DHT11
2. AI Engine ใช้ YOLOv8 ตรวจจับ Apple, Mango และ Orange
3. PHP API รับและจัดเก็บข้อมูลใน MySQL
4. Flutter Dashboard ดึงข้อมูลจาก API มาแสดงผล
5. GitHub ใช้จัดการ Source Code ของทุกส่วน

## API

- `POST /api/store_telemetry.php`
- `POST /api/store_inventory.php`
- `GET /api/get_latest.php`

## Database

Database: `smart_farm_db`

Tables:

- `telemetry_data`
- `warehouse_inventory`
