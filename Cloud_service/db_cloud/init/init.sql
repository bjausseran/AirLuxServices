CREATE SCHEMA IF NOT EXISTS AirLuxDB character set utf8mb4 collate utf8mb4_bin; 
CREATE TABLE IF NOT EXISTS  AirLuxDB.users (
    id VARCHAR(255) NOT NULL, 
    email VARCHAR(255) NOT NULL, 
    password VARCHAR(255) NOT NULL, 
    name VARCHAR(255) NOT NULL, 
    device_id VARCHAR(255), 
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    UNIQUE INDEX id_UNIQUE (id ASC))CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS AirLuxDB.user_building (
    id int  AUTO_INCREMENT, 
    building_id VARCHAR(255) NOT NULL, 
    user_id VARCHAR(255) NOT NULL, 
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    UNIQUE INDEX id_UNIQUE (id ASC))CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS AirLuxDB.buildings (
    id VARCHAR(255) NOT NULL, 
    name VARCHAR(255) NOT NULL, 
    type VARCHAR(255), 
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    UNIQUE INDEX id_UNIQUE (id ASC))CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS AirLuxDB.rooms (
    id VARCHAR(255) NOT NULL, 
    building_id VARCHAR(255) NOT NULL, 
    name VARCHAR(255) NOT NULL, 
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    UNIQUE INDEX id_UNIQUE (id ASC))CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS AirLuxDB.captors (
    id VARCHAR(255) NOT NULL, 
    name VARCHAR(255) NOT NULL, 
    type VARCHAR(255) NOT NULL, 
    room_id VARCHAR(255) NOT NULL, 
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    UNIQUE INDEX id_UNIQUE (id ASC))CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS AirLuxDB.captor_values (
    id INT AUTO_INCREMENT,
    captor_id VARCHAR(255) NOT NULL,
    value INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    UNIQUE INDEX id_UNIQUE (id ASC))CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE TABLE IF NOT EXISTS AirLuxDB.devices (
    id VARCHAR(255) NOT NULL, 
    apns_token VARCHAR(255) NOT NULL, 
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    UNIQUE INDEX id_UNIQUE (id ASC))CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


CREATE USER 'root'@'syncapi.docker_iotnetwork' IDENTIFIED BY 'password'; 
GRANT ALL PRIVILEGES ON *.* TO 'root'@'syncapi.docker_iotnetwork' WITH GRANT OPTION; 
CREATE USER 'root'@'%' IDENTIFIED BY 'password'; 
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; 

INSERT INTO `AirLuxDB`.`users` (`id`, `email`, `password`, `name`, `device_id`) VALUES ('1', 'test@gmail.com', 'pass', 'Benoît', '1');
INSERT INTO `AirLuxDB`.`users` (`id`, `email`, `password`, `name`, `device_id`) VALUES ('2', 'test@ynov.com', 'pass', 'Aymeric', '2');

INSERT INTO `AirLuxDB`.`buildings` (`id`, `name`, `type`) VALUES ('1', 'Principal', 'Large');
INSERT INTO `AirLuxDB`.`buildings` (`id`, `name`, `type`) VALUES ('2', 'Secondaire', 'Medium');
INSERT INTO `AirLuxDB`.`buildings` (`id`, `name`, `type`) VALUES ('3', 'Remise', 'Small');
INSERT INTO `AirLuxDB`.`buildings` (`id`, `name`, `type`) VALUES ('4', 'Maison', 'Medium');

INSERT INTO `AirLuxDB`.`user_building` (`id`, `building_id`, `user_id`) VALUES ('1', '1', '1');
INSERT INTO `AirLuxDB`.`user_building` (`id`, `building_id`, `user_id`) VALUES ('2', '2', '1');
INSERT INTO `AirLuxDB`.`user_building` (`id`, `building_id`, `user_id`) VALUES ('3', '3', '1');
INSERT INTO `AirLuxDB`.`user_building` (`id`, `building_id`, `user_id`) VALUES ('4', '4', '2');

INSERT INTO `AirLuxDB`.`rooms` (`id`, `building_id`, `name`) VALUES ('1', '1', 'Salon');
INSERT INTO `AirLuxDB`.`rooms` (`id`, `building_id`, `name`) VALUES ('2', '1', 'Cuisine');
INSERT INTO `AirLuxDB`.`rooms` (`id`, `building_id`, `name`) VALUES ('3', '1', 'SdB');
INSERT INTO `AirLuxDB`.`rooms` (`id`, `building_id`, `name`) VALUES ('4', '2', 'Salon');
INSERT INTO `AirLuxDB`.`rooms` (`id`, `building_id`, `name`) VALUES ('5', '2', 'Grenier');
INSERT INTO `AirLuxDB`.`rooms` (`id`, `building_id`, `name`) VALUES ('6', '3', 'Salle');
INSERT INTO `AirLuxDB`.`rooms` (`id`, `building_id`, `name`) VALUES ('7', '4', 'Salon');

INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('1', 'Thermo', 'temp', '1');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('2', 'Lustre', 'light', '1');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('3', 'Lumière', 'light', '2');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('4', 'Lumière', 'light', '3');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('5', 'Porte entrée', 'door', '1');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('6', 'Thermo', 'temp', '4');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('7', 'Lumière', 'light', '4');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('8', 'Lumière', 'light', '5');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('9', 'Lumière', 'light', '6');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('10', 'Garage', 'door', '6');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('11', 'Porte', 'door', '7');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('12', 'Lumière', 'light', '7');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('13', 'Volet', 'shutter', '1');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('14', 'Volet', 'shutter', '2');
INSERT INTO `AirLuxDB`.`captors` (`id`, `name`, `type`, `room_id`) VALUES ('15', 'Movement', 'move', '3');

INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`) VALUES ('1', '1', '24');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`) VALUES ('2', '2', '1');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`) VALUES ('3', '3', '1');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`) VALUES ('4', '4', '0');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`) VALUES ('5', '5', '0');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`) VALUES ('6', '6', '22');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`) VALUES ('7', '7', '0');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`) VALUES ('8', '8', '1');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`) VALUES ('9', '9', '0');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`) VALUES ('10', '10', '0');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`) VALUES ('11', '11', '1');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`) VALUES ('12', '12', '1');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`) VALUES ('13', '13', '1');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`) VALUES ('14', '14', '0');
INSERT INTO `AirLuxDB`.`captor_values` (`id`, `captor_id`, `value`) VALUES ('15', '15', '0');
