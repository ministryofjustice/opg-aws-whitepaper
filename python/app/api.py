from fastapi import FastAPI
import uvicorn
import random
app = FastAPI()

@app.get("/")
def read_root():
  quotes = ["a", "b", "c"]
  return { quotes[random.randrange(0, 3)]}

uvicorn.run(app, port=8000)
