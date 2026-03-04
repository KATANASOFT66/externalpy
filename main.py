import os as modOs
import sys as modSys
import json
import logging
from flask import Flask, request, jsonify

modSys.path.append(modOs.path.dirname(__file__))

from utils.core import clsInjector

app = Flask(__name__)
log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)

@app.route('/handle', methods=['POST'])
def handle_bridge():
    try:
        raw_body = request.data.decode('utf-8')
        parts = raw_body.split('\n', 3)

        if len(parts) < 4:
            return jsonify({"error": "Invalid protocol"}), 400

        req_type = parts[0]
        pid = parts[1]
        settings = json.loads(parts[2])
        payload = parts[3]

        response = ""

        if req_type == "print":
            print(payload)
            response = "success"
        elif req_type == "test":
            response = "Bridge Connected"
        
        return str(response)

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    objInjector = clsInjector()
    objInjector.fnWaitForRoblox()
    if objInjector.fnInject():
        print("𐔌՞. .՞𐦯 enjoy!")
        app.run(host='0.0.0.0', port=5000)
