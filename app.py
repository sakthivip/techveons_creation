from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
import smtplib
from email.mime.text import MIMEText
import os

app = Flask(__name__)
CORS(app)
HTML_FILE = os.path.join(os.path.dirname(__file__), 'techveons (4).html')

@app.route('/favicon.ico')
def favicon():
    return '', 204

@app.route('/rishva.jpeg')
def rishva_image():
    return send_file(os.path.join(os.path.dirname(__file__), 'rishva.jpeg'))

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def home(path):
    return send_file(HTML_FILE)

@app.route('/send', methods=['POST'])
def send():
    from flask import request

    data = request.get_json()
    if not data:
        return "No data received", 400
    msg = data.get("message", "")
    try:
        name = request.form.get('name')
        email = request.form.get('email')
        phone = request.form.get('phone')
        message = request.form.get('message')

        body = f"""
Name: {name}
Email: {email}
Phone: {phone}
Message: {message}
"""

        msg = MIMEText(body)
        msg['Subject'] = "New Form Message"
        msg['From'] = "techveons.creation.official@gmail.com"
        msg['To'] = "techveons.creation.official@gmail.com"

        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login("techveons.creation.official@gmail.com", "dpdc mjji mdvi ivxl")

        server.send_message(msg)
        server.quit()

        print("EMAIL SENT ✅")

        return jsonify({"message": "success"})

    except Exception as e:
        print("ERROR:", e)
        return jsonify({"message": "error"}), 500

if __name__ == '__main__':
    app.run(debug=True)