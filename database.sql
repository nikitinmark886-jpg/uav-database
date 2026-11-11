-- ============================================
-- УЧЕБНАЯ БАЗА ДАННЫХ: МАРШРУТЫ БПЛА
-- ============================================

-- Создание таблиц (если запускаете с нуля)
CREATE TABLE Drones (
  drone_id        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  model           VARCHAR(50) NOT NULL,
  serial_number   VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE Routes (
  route_id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  route_name       VARCHAR(100) NOT NULL,
  description      VARCHAR(255) NULL
) ENGINE=InnoDB;

CREATE TABLE Waypoints (
  waypoint_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  route_id     INT UNSIGNED NOT NULL,
  sequence_num SMALLINT UNSIGNED NOT NULL,
  latitude     DECIMAL(10,6) NOT NULL,
  longitude    DECIMAL(10,6) NOT NULL,
  altitude_m   SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  speed_ms     DECIMAL(5,2) NOT NULL DEFAULT 0,
  action       VARCHAR(20) NOT NULL,
  CONSTRAINT fk_wp_route FOREIGN KEY (route_id) REFERENCES Routes(route_id) ON DELETE CASCADE,
  CONSTRAINT uq_route_seq UNIQUE (route_id, sequence_num),
  CONSTRAINT chk_altitude CHECK (altitude_m <= 120)
) ENGINE=InnoDB;

CREATE TABLE Flights (
  flight_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  drone_id      INT UNSIGNED NOT NULL,
  route_id      INT UNSIGNED NOT NULL,
  flight_date   DATETIME NOT NULL,
  operator_name VARCHAR(100) NOT NULL,
  weather_notes VARCHAR(255) NULL,
  CONSTRAINT fk_flight_drone FOREIGN KEY (drone_id) REFERENCES Drones(drone_id) ON DELETE RESTRICT,
  CONSTRAINT fk_flight_route FOREIGN KEY (route_id) REFERENCES Routes(route_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================
-- НАПОЛНЕНИЕ ДАННЫМИ
-- ============================================

INSERT INTO Drones (model, serial_number) VALUES
('DJI Mavic 3', 'SN-DJI-001'),
('Autel EVO II', 'SN-AUT-002'),
('DJI Mini 3', 'SN-DJI-003'),
('FPV Freestyle', 'SN-FPV-004');

INSERT INTO Routes (route_name, description) VALUES
('Учебный квадрат А', 'Базовый облет по квадрату'),
('Облет препятствия', 'Тест облета высотного здания'),
('Периметр площадки', 'Мониторинг охраны'),
('Линейный маршрут', 'Патрулирование дороги'),
('FPV-трасса', 'Гоночная трасса с воротами');

INSERT INTO Waypoints (route_id, sequence_num, latitude, longitude, altitude_m, speed_ms, action) VALUES
(1, 1, 55.755800, 37.617300, 0, 0.00, 'Взлёт'),
(1, 2, 55.756000, 37.618000, 50, 5.00, 'Фото'),
(1, 3, 55.756500, 37.619000, 80, 5.00, 'Фото'),
(1, 4, 55.755800, 37.617300, 0, 0.00, 'Посадка'),
(2, 1, 55.760000, 37.620000, 0, 0.00, 'Взлёт'),
(2, 2, 55.761000, 37.621000, 100, 3.00, 'Облет'),
(2, 3, 55.762000, 37.622500, 60, 4.00, 'Фото'),
(2, 4, 55.760000, 37.620000, 0, 0.00, 'Посадка'),
(3, 1, 55.700000, 37.600000, 0, 0.00, 'Взлёт'),
(3, 2, 55.701000, 37.600000, 100, 6.00, 'Мониторинг'),
(3, 3, 55.701000, 37.601000, 100, 6.00, 'Мониторинг'),
(3, 4, 55.700000, 37.601000, 100, 6.00, 'Мониторинг'),
(3, 5, 55.700000, 37.600000, 0, 0.00, 'Посадка'),
(4, 1, 55.800000, 37.500000, 0, 0.00, 'Взлёт'),
(4, 2, 55.810000, 37.520000, 120, 10.00, 'Линейный'),
(4, 3, 55.820000, 37.540000, 120, 10.00, 'Линейный'),
(4, 4, 55.830000, 37.560000, 120, 10.00, 'Линейный'),
(4, 5, 55.800000, 37.500000, 0, 0.00, 'Посадка'),
(5, 1, 55.900000, 37.400000, 0, 0.00, 'Взлёт'),
(5, 2, 55.901000, 37.401000, 30, 15.00, 'Ворота'),
(5, 3, 55.902000, 37.402000, 20, 15.00, 'Ворота'),
(5, 4, 55.900000, 37.400000, 0, 0.00, 'Посадка');

INSERT INTO Flights (drone_id, route_id, flight_date, operator_name, weather_notes) VALUES
(1, 1, '2026-10-27 10:00:00', 'Иванов И.И.', 'Ветер 3 м/с, видимость 10 км'),
(2, 2, '2026-10-27 11:30:00', 'Петров П.П.', 'Ветер 5 м/с, видимость 8 км'),
(3, 3, '2026-10-28 09:15:00', 'Сидоров С.С.', 'Ясно, ветер 2 м/с'),
(1, 4, '2026-10-28 14:00:00', 'Иванов И.И.', 'Облачно, ветер 4 м/с'),
(4, 5, '2026-10-29 16:30:00', 'Кузнецов К.К.', 'Ветер 6 м/с, порывы');