# AirLux_Services
 Services utilisés pour le projet AirLux.

# Redis :

Generate ca.key :

```
openssl genrsa -out ca.key 2048 
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt
```

Generate cert & key :
```
openssl req   -nodes  -newkey rsa:2048  -keyout client_key_app_001.pem  -x509  -days 36500  -out client_cert_app_001.pem
```

# Local_app


Test unitaire :
```
npm --prefix Local_service/Local_app/ run test
```
Test integration (local) :
```
docker-compose -f Local_service/Local_app/tests/integ/dependencies/docker-compose.yaml build
docker-compose -f Local_service/Local_app/tests/integ/dependencies/docker-compose.yaml up -d
```
        
Test fonctionnel (local) :
```
docker-compose -f Local_service/Local_app/tests/functionnal/dependencies/docker-compose.yaml build
docker-compose -f Local_service/Local_app/tests/functionnal/dependencies/docker-compose.yaml up -d
```



Notes :


        MutualTLS
        github workflow
        sonar qube

        note ?


tester    | Ran all test suites matching /tests\/functionnal\//i.
tester    | 
tester    | Jest has detected the following 1 open handle potentially keeping Jest from exiting:
tester    | 
tester    |   ●  TCPWRAP
tester    | 
tester    |       18 |
tester    |       19 | async function redis_connection() {
tester    |     > 20 |   client.connect(function(err) {
tester    |          |          ^
tester    |       21 |     if(err) throw err;
tester    |       22 |     console.log("Redis database connected!")
tester    |       23 |   })
tester    | 
tester    |       at RedisSocket._RedisSocket_createNetSocket (node_modules/@redis/client/dist/lib/client/socket.js:208:21)
tester    |       at node_modules/@redis/client/dist/lib/client/socket.js:175:101
tester    |       at RedisSocket._RedisSocket_createSocket (node_modules/@redis/client/dist/lib/client/socket.js:172:12)
tester    |       at RedisSocket._RedisSocket_connect (node_modules/@redis/client/dist/lib/client/socket.js:147:154)
tester    |       at RedisSocket.connect (node_modules/@redis/client/dist/lib/client/socket.js:51:96)
tester    |       at Commander.connect (node_modules/@redis/client/dist/lib/client/index.js:184:71)
tester    |       at connect (src/redis/redis_client.js:20:10)
tester    |       at Object.redis_connection (src/redis/redis_client.js:28:1)
tester    |       at Object.require (tests/functionnal/redis.test.js:5:18)