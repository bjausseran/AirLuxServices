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

docker build -t jausseran/cloud_app --target run -f Dockerfile_cloud_app .
docker push jausseran/cloud_app
docker compose up -d cloud_app local_app db_local db_cloud broker

docker build -t jausseran/local_app --target installer -f Dockerfile_local_app .
docker push jausseran/local_app

docker compose up -d cloud_app local_app db_local db_cloud broker