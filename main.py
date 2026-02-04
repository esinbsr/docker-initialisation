import logging
import os
import time

from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from sqlalchemy import Column, Integer, String
from database import Base, engine, SessionLocal

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Création de l'app
app = FastAPI(title="FastAPI Upload Demo", version="1.0.0")


# =========================
# Modèle DB
# =========================
class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    email = Column(String, nullable=False)


# =========================
# Startup
# =========================
@app.on_event("startup")
async def startup_event():
    Base.metadata.create_all(bind=engine)
    logger.info("DB prête (tables créées si besoin)")


# =========================
# Routes
# =========================
@app.get("/")
def read_root():
    return {"message": "Hello World!", "status": "running"}


@app.get("/health")
def health_check():
    return {"status": "healthy"}


@app.get("/users")
def get_users():
    db = SessionLocal()
    try:
        users = db.query(User).all()
        return [
            {"id": u.id, "name": u.name, "email": u.email}
            for u in users
        ]
    finally:
        db.close()


@app.post("/users")
def create_user(user_data: dict):
    db = SessionLocal()
    try:
        user = User(
            name=user_data["name"],
            email=user_data["email"]
        )
        db.add(user)
        db.commit()
        db.refresh(user)
        return {
            "message": "User created",
            "user": {
                "id": user.id,
                "name": user.name,
                "email": user.email,
            }
        }
    finally:
        db.close()


@app.get("/slow")
def slow_endpoint():
    time.sleep(2)
    return {"message": "This was slow!"}


@app.get("/error")
def error_endpoint():
    raise Exception("This is a test error!")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
