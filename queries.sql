-- Запрос 1: Сводная карточка всех полетов
SELECT 
  f.flight_id AS 'ID полета',
  DATE_FORMAT(f.flight_date, '%d.%m.%Y %H:%i') AS 'Дата и время',
  d.model AS 'Дрон',
  f.operator_name AS 'Оператор',
  r.route_name AS 'Маршрут',
  f.weather_notes AS 'Погода',
  GROUP_CONCAT(
    CONCAT(w.sequence_num, '. ', w.action, ' (', w.altitude_m, ' м)') 
    ORDER BY w.sequence_num ASC SEPARATOR ' -> '
  ) AS 'Траектория полета'
FROM Flights f
JOIN Drones d ON d.drone_id = f.drone_id
JOIN Routes r ON r.route_id = f.route_id
JOIN Waypoints w ON w.route_id = r.route_id
GROUP BY f.flight_id, f.flight_date, d.model, f.operator_name, r.route_name, f.weather_notes
ORDER BY f.flight_id;