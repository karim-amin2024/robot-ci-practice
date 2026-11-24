import secrets
from fastapi import FastAPI, Header, HTTPException
from pydantic import BaseModel

# create the backend application to handle the api requests 
app = FastAPI()

USERS = {"alice": "secret"}
# stores the issued login tokens
TOKENS: set[str] = set()
ITEMS = [{"id": i, "name": f"item-{i}"} for i in range(1, 21)]

# defines the data set should be used login and registeration 
# if one parameter is missing FastAPI automatically returns 422 without any code from you. That's why your "missing field" negative test works.
class Credentials(BaseModel):
    username: str
    password: str


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/register", status_code=201)
def register(body: Credentials):
    USERS[body.username] = body.password
    return {"username": body.username}


@app.post("/login")
def login(body: Credentials):
    if USERS.get(body.username) != body.password:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    token = secrets.token_hex(16)
    TOKENS.add(token)
    return {"token": token}


@app.get("/items")
def items(limit: int = 10, authorization: str | None = Header(default=None)):
    token = (authorization or "").removeprefix("Bearer ")
    if token not in TOKENS:
        raise HTTPException(status_code=401, detail="Unauthorized")
    return ITEMS[:limit]