from fastapi import FastAPI
import uvicorn
import random

app = FastAPI()

@app.get("/")
def read_root():
    quotes = ["a", "b", "c"]
    chosen_quote = random.choice(quotes)  # Use random.choice for simplicity
    return {"quote": chosen_quote}

# Check if the script is run directly (not imported as a module)
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
