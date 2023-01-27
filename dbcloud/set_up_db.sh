#!/bin/bash

sed -i 's/#auto eth0\n#iface eth0 inet dhcp/auto eth0\niface eth0 inet dhcp/g' /etc/network/interfaces
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
cp /var/run/mysqld/mysqld.sock.lock /var/run/mysqld/mysqld.sock
update-rc.d mysql defaults
ufw allow 3306
service mysql start


mysql -uroot -e "
CREATE SCHEMA AirLuxDB character set utf8mb4 collate utf8mb4_bin; 
CREATE TABLE AirLuxDB.users (
    id VARCHAR(255) NOT NULL, 
    email VARCHAR(255) NOT NULL, 
    password VARCHAR(255) NOT NULL, 
    name VARCHAR(255) NOT NULL, 
    device_id VARCHAR(255), 
    updated_at DATE, 
    created_at DATE, 
    UNIQUE INDEX id_UNIQUE (id ASC));
CREATE TABLE AirLuxDB.user_building (
    id int  AUTO_INCREMENT, 
    building_id VARCHAR(255) NOT NULL, 
    user_id VARCHAR(255) NOT NULL, 
    updated_at DATE, 
    created_at DATE, 
    UNIQUE INDEX id_UNIQUE (id ASC));
CREATE TABLE AirLuxDB.buildings (
    id VARCHAR(255) NOT NULL, 
    name VARCHAR(255) NOT NULL, 
    type VARCHAR(255), 
    updated_at DATE, 
    created_at DATE, 
    UNIQUE INDEX id_UNIQUE (id ASC));
CREATE TABLE AirLuxDB.rooms (
    id VARCHAR(255) NOT NULL, 
    building_id VARCHAR(255) NOT NULL, 
    name VARCHAR(255) NOT NULL, 
    updated_at DATE, 
    created_at DATE, 
    UNIQUE INDEX id_UNIQUE (id ASC));
CREATE TABLE AirLuxDB.captors (
    id VARCHAR(255) NOT NULL, 
    name VARCHAR(255) NOT NULL, 
    room_id VARCHAR(255) NOT NULL, 
    value VARCHAR(255), 
    updated_at DATE, 
    created_at DATE, 
    UNIQUE INDEX id_UNIQUE (id ASC));
CREATE TABLE AirLuxDB.captor_values (
    id int AUTO_INCREMENT,
    value VARCHAR(255), 
    updated_at DATE, 
    created_at DATE, 
    UNIQUE INDEX id_UNIQUE (id ASC));
CREATE TABLE AirLuxDB.devices (
    id VARCHAR(255) NOT NULL, 
    apns_token VARCHAR(255) NOT NULL, 
    updated_at DATE, 
    created_at DATE, 
    UNIQUE INDEX id_UNIQUE (id ASC));
CREATE USER 'root'@'syncapi.docker_iotnetwork' IDENTIFIED BY 'password'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'syncapi.docker_iotnetwork' WITH GRANT OPTION; CREATE USER 'root'@'%' IDENTIFIED BY 'password'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
