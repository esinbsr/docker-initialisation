# ============================================
# ÉTAPE 1: Image de base
# ============================================
FROM python:3.11-slim

# ============================================
# ÉTAPE 2: Configuration de l'environnement
# ============================================
ENV APP_HOME=/app \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 
    #log affichés en temps réel, ces variables n'existent que dans l'image, pas sur mon pc

# Définir le répertoire de travail, toutes les commandes après, se font dans /app
WORKDIR $APP_HOME

# ============================================
# ÉTAPE 3: Installation des dépendances
# ============================================

# copie un fichier depuis mon pc vers l'image docker
COPY requirements.txt .

#  Installer les dépendences systèmes
RUN pip install --no-cache-dir -r requirements.txt

# ============================================
# ÉTAPE 4: Copie du code source
# ============================================

# Copier le code de l'application (ex:main.py etc, sans .dockerignore ca copy tout meme .git, .venv) dans /app
COPY . .

# ============================================
# ÉTAPE 5: Configuration finale
# ============================================

# informe docker qu'à l'intérieur du conteneur, mon application écoute sur le port 8000
EXPOSE 8000

#  quand le conteneur démarre lance cette commande
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]