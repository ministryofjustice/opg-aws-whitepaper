from flask import Flask, render_template
import requests
import argparse
import os

app = Flask(__name__)

# Add the URL from arg from the private loadbalancer
parser = argparse.ArgumentParser(description="URL for the loadbalancer")
parser.add_argument("--url", required=False, help="The URL is created from terraform")
arg = parser.parse_args()

@app.route('/')
def home():
  host = f"Host: {os.uname()[1]}"
  try:
    response = requests.get(arg.url)
    data = response.text
  except requests.RequestException as e:
    data = f"Error fetching data: {e}"

  return render_template('index.html', data=data, host=host)

if __name__ == '__main__':
    app.run(debug=True, port=8000)
