CREATE SCHEMA IF NOT EXISTS AirLuxDB character set utf8mb4 collate utf8mb4_bin; 
CREATE TABLE IF NOT EXISTS  AirLuxDB.users (
    id INT AUTO_INCREMENT, 
    email VARCHAR(255) NOT NULL, 
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL, 
    device_id INT, 
    authorized BOOLEAN DEFAULT 1, 
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    UNIQUE INDEX id_UNIQUE (id ASC))CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS AirLuxDB.user_building (
    id int AUTO_INCREMENT, 
    building_id INT NOT NULL, 
    user_id INT NOT NULL, 
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    UNIQUE INDEX id_UNIQUE (id ASC))CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS AirLuxDB.buildings (
    id INT AUTO_INCREMENT, 
    name VARCHAR(255) NOT NULL, 
    type VARCHAR(255), 
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    UNIQUE INDEX id_UNIQUE (id ASC))CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS AirLuxDB.rooms (
    id INT AUTO_INCREMENT, 
    building_id INT NOT NULL, 
    name VARCHAR(255) NOT NULL, 
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    UNIQUE INDEX id_UNIQUE (id ASC))CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS AirLuxDB.captors (
    id INT AUTO_INCREMENT, 
    name VARCHAR(255) NOT NULL, 
    type VARCHAR(255) NOT NULL, 
    room_id INT NOT NULL, 
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    UNIQUE INDEX id_UNIQUE (id ASC))CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS AirLuxDB.captor_values (
    id INT AUTO_INCREMENT,
    captor_id INT NOT NULL,
    value INT NOT NULL,
    automation_id INT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    UNIQUE INDEX id_UNIQUE (id ASC))CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS AirLuxDB.devices (
    id INT AUTO_INCREMENT, 
    apns_token VARCHAR(255) NOT NULL, 
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    UNIQUE INDEX id_UNIQUE (id ASC))CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS AirLuxDB.automations (
    id INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL, 
    user_id INT NOT NULL,
    is_scheduled BOOLEAN DEFAULT false, 
    enabled BOOLEAN DEFAULT false, 
    frequency VARCHAR(255), 
    start_date DATETIME, 
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    UNIQUE INDEX id_UNIQUE (id ASC))CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


CREATE USER 'root'@'syncapi.docker_iotnetwork' IDENTIFIED BY 'password'; 
GRANT ALL PRIVILEGES ON *.* TO 'root'@'syncapi.docker_iotnetwork' WITH GRANT OPTION; 

## USERS
INSERT INTO `AirLuxDB`.`users` (`id`, `email`, `password`, `name`, `device_id`) VALUES ('1', 'test@gmail.com', 'pass', 'Benoit', '1');
INSERT INTO `AirLuxDB`.`users` (`id`, `email`, `password`, `name`, `device_id`) VALUES ('2', 'test@ynov.com', 'pass', 'Aymeric', '2');
INSERT INTO `AirLuxDB`.`users` (`id`, `email`, `password`, `name`, `device_id`) VALUES ('3', 'test@airlux.com', 'pass', 'Artus', '3');
INSERT INTO `AirLuxDB`.`users` (`id`, `email`, `password`, `name`, `device_id`) VALUES ('4', 'test@test.test', 'pass', 'Autre utilisateur', '4');

## BUILDINGS
INSERT INTO `AirLuxDB`.`buildings` (`id`, `name`, `type`) VALUES ('1', 'Principal', 'Large');
INSERT INTO `AirLuxDB`.`buildings` (`id`, `name`, `type`) VALUES ('2', 'Secondaire', 'Medium');
INSERT INTO `AirLuxDB`.`buildings` (`id`, `name`, `type`) VALUES ('3', 'Remise', 'Small');
INSERT INTO `AirLuxDB`.`buildings` (`id`, `name`, `type`) VALUES ('4', 'Maison', 'Medium');

## USER - BUILDING PIVOT
INSERT INTO `AirLuxDB`.`user_building` (`id`, `building_id`, `user_id`) VALUES ('1', '1', '1');
INSERT INTO `AirLuxDB`.`user_building` (`id`, `building_id`, `user_id`) VALUES ('2', '2', '1');
INSERT INTO `AirLuxDB`.`user_building` (`id`, `building_id`, `user_id`) VALUES ('3', '3', '1');

INSERT INTO `AirLuxDB`.`user_building` (`id`, `building_id`, `user_id`) VALUES ('4', '1', '2');
INSERT INTO `AirLuxDB`.`user_building` (`id`, `building_id`, `user_id`) VALUES ('5', '2', '2');
INSERT INTO `AirLuxDB`.`user_building` (`id`, `building_id`, `user_id`) VALUES ('6', '3', '2');

INSERT INTO `AirLuxDB`.`user_building` (`id`, `building_id`, `user_id`) VALUES ('7', '1', '3');
INSERT INTO `AirLuxDB`.`user_building` (`id`, `building_id`, `user_id`) VALUES ('8', '2', '3');
INSERT INTO `AirLuxDB`.`user_building` (`id`, `building_id`, `user_id`) VALUES ('9', '3', '3');

INSERT INTO `AirLuxDB`.`user_building` (`id`, `building_id`, `user_id`) VALUES ('10', '4', '4');

## ROOMS
INSERT INTO `AirLuxDB`.`rooms` (`id`, `building_id`, `name`) VALUES ('1', '1', 'Salon');
INSERT INTO `AirLuxDB`.`rooms` (`id`, `building_id`, `name`) VALUES ('2', '1', 'Cuisine');
INSERT INTO `AirLuxDB`.`rooms` (`id`, `building_id`, `name`) VALUES ('3', '1', 'SdB');
INSERT INTO `AirLuxDB`.`rooms` (`id`, `building_id`, `name`) VALUES ('4', '2', 'Salon');
INSERT INTO `AirLuxDB`.`rooms` (`id`, `building_id`, `name`) VALUES ('5', '2', 'Grenier');
INSERT INTO `AirLuxDB`.`rooms` (`id`, `building_id`, `name`) VALUES ('6', '3', 'Salle');
INSERT INTO `AirLuxDB`.`rooms` (`id`, `building_id`, `name`) VALUES ('7', '4', 'Salon');


## CAPTORS
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('1', 'Thermo', 'temp', '1');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('2', 'Lustre', 'light', '1');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('3', 'Lumiere', 'light', '2');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('4', 'Lumiere', 'light', '3');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('5', 'Porte entree', 'door', '1');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('6', 'Thermo', 'temp', '4');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('7', 'Lumiere', 'light', '4');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('8', 'Lumiere', 'light', '5');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('9', 'Lumiere', 'light', '6');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('10', 'Garage', 'door', '6');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('11', 'Porte', 'door', '7');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('12', 'Lumiere', 'light', '7');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('13', 'Volet', 'shutter', '1');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('14', 'Volet', 'shutter', '2');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('15', 'Movement', 'move', '3');

## CAPTOR VALUES
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('1', '1', '24', null);
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('2', '2', '1', null);
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('3', '3', '1', null);
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('4', '4', '0', null);
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('5', '5', '0', null);
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('6', '6', '22', null);
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('7', '7', '0', null);
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('8', '8', '1', null);
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('9', '9', '0', null);
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('10', '10', '0', null);
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('11', '11', '1', null);
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('12', '12', '1', null);
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('13', '13', '1', null);
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('14', '14', '0', null);
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('15', '15', '0', null);

INSERT INTO `AirLuxDB`.`automations` (`id`, `name`, `user_id`, `is_scheduled`, `enabled`, `start_date`, `frequency`) VALUES ('1', 'Bonne nuit', '1', '1', '1', '2023-09-18 21:00:00', 'day');
INSERT INTO `AirLuxDB`.`automations` (`id`, `name`, `user_id`, `is_scheduled`, `enabled`) VALUES ('2', 'Lancer la musique', '1', '0', '0');

INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('17', '2', '0', '1');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('18', '3', '0', '1');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('19', '5', '0', '1');

INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('20', '2', '1', '2');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`, `automation_id`) VALUES ('21', '3', '1', '2');