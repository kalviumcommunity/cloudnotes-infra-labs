"""CloudNotes API - tiny Flask health service.

Do not modify this file for the assessment; it is not part of the
three planted issues. It is provided so the container has something
real to run.
"""
import os

from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/health")
def health():
    return jsonify(service="cloudnotes-api", status="ok"), 200


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
