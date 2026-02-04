
# Image de base
FROM python:3.11-slim

# créer un utilisateur non-root pour la securité
RUN useradd -m -u 1001 appuser \
    && chown -R appuser:appuser /app

# Configuration de l'environnement
ENV APP_HOME=/app \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
    # logs affichés en temps réel, ces variables n'existent que dans l'image, pas sur mon pc


# Définir le répertoire de travail, toutes les commandes après se font dans /app
WORKDIR $APP_HOME


# Dépendances système (pour le healthcheck)
RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*

# Installation des dépendances Python

# copie un fichier depuis mon pc vers l'image docker
COPY requirements.txt .

# installer les dépendances (en root)
RUN pip install --no-cache-dir -r requirements.txt


# Copier le code de l'application (sans .dockerignore ça copierait tout : .git, .venv, etc.)
COPY . .


# utiliser cet utilisateur
USER appuser

# informe docker qu'à l'intérieur du conteneur, mon application écoute sur le port 8000
EXPOSE 8000

# quand le conteneur démarre, lancer l'application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
