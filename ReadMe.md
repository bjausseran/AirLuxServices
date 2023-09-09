# Documentation
View documentation and all information in notion : https://hallowed-timimus-dfc.notion.site/Airlux-30a742c5c98c49b1b371ed8b0b422972


# SET UP :
```
# clone repo (uwu)
cd docker
docker compose build

#__________________MOSQUITTO____________________
# START MOSQUITTO BROKER :
docker exec -ti broker mosquitto -c /mosquitto/config/mosquitto.conf
#_______________________________________________

#____________PROMETHEUS / GRAFANA_______________
# TO OPEN GRAFANA
# go to localhost:3000
#   -   user = admin
#   -   pass = secret

# TO ADD A DATA SOURCE
# go to configuration - data sources
# clic Add data source, select Prometheus
#   -   url = http://host.docker.internal:9090
#   -   Prometheus type = Prometheus
#   -   Prometheus version = 2.40.x (or check at localhost:9090)

# TO ADD A DASHBOARD :
# Select dashboard - import
# choose a Json from grafana folder or find an ID on grafana.com
#______________________________________________
#
```

# Assignment
- Dang/Aymeric - websocket/localapp
- Jonathan/Loup - MCD
- Benoît - Laravel
- Artus - sick

# Integration checklist
- [x] pulsor (nodejs) : need to push to mosquitto and not redis
- [x] broker (mosquitto)
- [x] localapp (nodejs)
- [x] dblocal (redis)
- [x] syncapi (laravel) : remove direct connection to redis since websocket connect trought socket
- [x] dbcloud (mysql)
- [ ] validator (nodejs)
- [x] dbstats (prometheus)
- [x] statsapp (grafana)
- [ ] phoneapp (flutter)

# TODO (management)
- [x] Confirm services name and rename folders, dockerfiles, services (compose)
- [x] Set up a post merging process (with tech lead (maybe PO ?))
- [ ] Create MCD

# TODO Services
## statsapp-Grafana
- [ ] Create graphs
## dbstats-Prometheus
- [ ] Check data polling from mysql
## syncapi-Laravel
- [ ] Remove redis connection (useless)
- [ ] Add CRUD related to new MCD
