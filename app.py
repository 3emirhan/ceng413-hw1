import os
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def index():
    env_name = os.getenv("APP_ENV", "development")
    return jsonify({
        "message": "CENG413 Docker Homework API is running",
        "environment": env_name
    })

@app.route("/health")
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == "__main__":
    port = int(os.getenv("PORT", 8080))
    app.run(host="0.0.0.0", port=port)
