# Application FastAPI Dockerisée

## Description
Application FastAPI dockerisée avec :
- une API REST
- une base de données **PostgreSQL**
- une orchestration via **Docker Compose**
- persistance des données via **volumes**
- healthchecks pour garantir le bon démarrage des services


## Prérequis
- Docker
- Docker Compose

## Structure du projet
```
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── main.py
├── database.py
├── .env
├── .gitignore
├── .dockerignore
└── README.md
```

## Variables d’environnement
Le projet utilise un fichier `.env` (non versionné) basé sur le fichier `.env.example`.

Fichier `.env.example`
```env
DATABASE_URL=postgresql+psycopg2://USER:PASSWORD@DB_HOST:DB_PORT/DB_NAME
```

## Lancer l’application

```
docker compose up --build
```
L’application est accessible sur :

- http://localhost:8000

- http://localhost:8000/docs

- http://localhost:8000/health

## Services Docker
### Application (app)

- FastAPI

- Port exposé : 8000

- Image construite via le Dockerfile

- Exécutée avec un utilisateur non-root

- Healthcheck sur /health

### Base de données (db)

- PostgreSQL 16

- Base : appdb

- Utilisateur : app

- Mot de passe : app

- Données persistées via un volume Docker

- Healthcheck avec pg_isready

## Volumes

postgres_data : persistance des données PostgreSQL

## Commandes utiles
Arrêter les conteneurs
```
docker compose down
```

Arrêter et supprimer les données
```
docker compose down -v
```

Lister les conteneurs
```
docker compose ps
```

Voir les logs
```
docker compose logs
```

## Tester l'api
Créer un utilisateur 
```
curl -X POST http://localhost:8000/users \
-H "Content-Type: application/json" \
-d '{"name":"Lorem","email":"lorem@example.com"}'
```

Lister les utilsateurs 
```
curl http://localhost:8000/users
```

## Publication DockerHub
L’image de l’application a été publiée sur DockerHub :
```
docker pull esinbaser/fastapi-upload-demo:1.0
```