from flask import Flask, request, jsonify
from sympy import preview
from io import BytesIO


app = Flask(__name__)

@app.route("/latex", methods=['POST'])
def index():
	data = request.json
	if data == None:
		return jsonify({"msg": "json/application Error"})
	if data['latex'] != None:
		obj = BytesIO()
		try:
			preview(
				data['latex'],
				viewer='BytesIO',
				filename='test.png',
				euler=False,
				output='png',
				dvioptions=['-D','1200'],
				outputbuffer=obj)
			return jsonify({"data": [t for t in obj.getvalue()]})
		except Exception as e:
			return jsonify({"msg": f"Failed to Process\nMSG:{e}"})
	else:
		return jsonify({"msg": "'latex' not found"})


if __name__ == "__main__":
	app.run(debug=True)

