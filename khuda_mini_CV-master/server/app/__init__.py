
from datetime import date, datetime
from json import JSONEncoder
from flask import request
from flask import Flask
from flask import jsonify

def create_app():
    app = Flask(__name__)

    #from .views import route_data
    #app.register_blueprint(route_data.bp) 

    @app.route('/', methods=['POST'])
    def post():
        print("POST : {}".format(datetime.now()))

        if 'audio' in request.files:
            print("audio file detected")
            try:
                audio = request.files['audio']
                audio.save('./test.mp4')
                print("audio file saved.")
                res = {'statusCode' : 200, 'msg' : 'audio upload completed.'}
                return jsonify(res)
            except Exception as e:
                print("Error in save", e)
                res = {'statusCode' : -1, 'msg' : 'Error in audio upload.'}
                return jsonify(res)
        if 'image' in request.files:
            try:
                img = request.files['image']
                img.save('./images/{}'.format(img.filename))
                print(img)
                res = {'statusCode' : 200, 'msg' : 'Image upload completed.'}
                return jsonify(res)
            except Exception as e:
                print("Error", e)
                res = {'statusCode' : -1, 'msg' : 'Error in image upload'}
                return jsonify(res)
    
    return app