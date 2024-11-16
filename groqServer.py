from groq import Groq
from flask import Flask, request, jsonify
from flask_cors import CORS

api_key="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" #your api goes here

app = Flask(__name__)
client = Groq(api_key=api_key,)
CORS(app)


@app.route('/process', methods=['POST'])
def process_data():
	data = request.get_json()
	message = data["data"]

	chat_completion = client.chat.completions.create(messages=[{"role": "user","content": message,}],model="llama3-8b-8192",)
	print(chat_completion.choices[0].message.content)

	result = chat_completion.choices[0].message.content
	return jsonify(result)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5600, debug=True)
