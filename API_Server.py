from flask import Flask,jsonify
from flask_cors import CORS, cross_origin
from flask import request
import requests

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import datetime

# Use a service account.
cred = credentials.Certificate('serviceAccount.json')

app = firebase_admin.initialize_app(cred)

db = firestore.client()

# Khởi tạo Flask Server Backend
app = Flask(__name__)

# Apply Flask CORS
CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'


@app.route('/', methods=['GET', 'POST'])
def home():
    return

# Get all board infor in cloud firestore
@app.route('/api/get_boards', methods=['GET'])
def get_board():

    response = []

    docs = db.collection('Board')
    docs = docs.order_by('timestamp', direction=firestore.Query.DESCENDING)
    docs = docs.stream()

    for doc in docs:
        result = doc.to_dict()

        # Convert timestamp to datetime
        time = datetime.datetime.fromtimestamp(result['timestamp'])

        time = time.strftime('%H:%M %d-%m-%Y')

        result['timestamp'] = time

        response.append(result)
        
        print(f'{doc.id} => {doc.to_dict()}')

    return response


#POST data into cloud firestore
@app.route('/api/add_boards', methods=['POST'])
@cross_origin(origin='*')
def add_boards():
    # Get json data form POST request
    board = request.json

    timestamp = datetime.datetime.now()
    timestamp = timestamp.timestamp()

    board["timestamp"] = timestamp
    
    # Add data into cloud firestore
    update_time, board_ref = db.collection('Board').add(board)

    print(f'Added document into Board collection with id {board_ref.id} at {update_time}')

    respone = {'error': False,
               'message': f'Added document into Board collection with id {board_ref.id} at {update_time}'}
    return respone


# Get all board count in cloud firestore
@app.route('/api/get_boardscount', methods=['GET'])
def get_boardcount():

    board_id = 23000
    board_id_last = 0
    list_board = []

    docs = db.collection('Board').order_by('id', direction=firestore.Query.ASCENDING).limit_to_last(1).get()
    for doc in docs:
        board_id_last = doc.to_dict()['id']
        break

    while True:
        
        board = {}

        board_id += 1

        docs = db.collection('Board').order_by('timestamp', direction=firestore.Query.DESCENDING).stream()


        for doc in docs:
            
            result = doc.to_dict()

            if result['id'] == board_id:

                board['name'] = result['name']
                board['id'] = result['id']

                # Convert timestamp to datetime
                time = datetime.datetime.fromtimestamp(result['timestamp'])

                time = time.strftime('%H:%M %d-%m-%Y')

                board['timestamp'] = time

                # Check status of board
                if onStatus(result['timestamp']):
                    board['status'] = 'on'
                else:
                    board['status'] = 'off'


                list_board.append(board)

                print(f'{doc.id} => {doc.to_dict()}')

                break
        if board_id == board_id_last:
            break

    return list_board

# Check status based on timestamp
def onStatus(timestamp):
    time_now = datetime.datetime.now()

    time_send = datetime.datetime.fromtimestamp(timestamp)
    print(time_send)

    # get difference
    delta = time_now - time_send

    # Difference in seconds
    sec = delta.total_seconds()

    # Difference in minutes
    min = sec / 60

    if min <= 5: 
        return True
    
    return False

# Get all data in cloud firestore
@app.route('/api/get_data', methods=['GET'])
def get_data():
    list_data = []

    docs = db.collection('Board').order_by('timestamp', direction=firestore.Query.ASCENDING).limit_to_last(5).get()

    for doc in docs:
        data = {}
        result = doc.to_dict()

        # Check time of today
        time_now = datetime.datetime.now()
        time_data = datetime.datetime.fromtimestamp(result['timestamp'])

        if(time_now.day == time_data.day and time_now.month == time_data.month and time_now.year == time_data.year):

            data['temperature'] = result['data']['temperature']
            data['humidity'] = result['data']['humidity']
            data['light'] = result['data']['light']

            time_data = time_data.strftime('%H:%M')

            data['timestamp'] = time_data

            list_data.append(data)

            print(f'{doc.id} => {doc.to_dict()}')

    return list_data


# Get the lastest data in cloud firestore
@app.route('/api/get_lastestdata', methods=['GET'])
def get_lastestdata():
    docs = db.collection('Board')
    docs = docs.order_by('timestamp', direction=firestore.Query.DESCENDING).limit(1).get()

    fake_list = []

    for doc in docs:
        result = doc.to_dict()

        data = {}

        data['temperature'] = result['data']['temperature']
        data['humidity'] = result['data']['humidity']
        data['light'] = result['data']['light']

        fake_list.append(data)

        print(f'{doc.id} => {doc.to_dict()}')

    return fake_list

# Post light on inform from ui app to API server
@app.route('/api/post_lighton', methods=['POST'])
def post_lighton():
    # Get json data form POST request
    light = request.json

    timestamp = datetime.datetime.now()
    timestamp = timestamp.timestamp()

    light["timestamp"] = timestamp
    
    # Add data into cloud firestore
    update_time, light_ref = db.collection('Light').add(light)

    print(f'Added document into Light collection with id {light_ref.id} at {update_time}')

    respone = {'error': False,
               'message': f'Added document into Light collection with id {light_ref.id} at {update_time}'}
    return respone


# Get light on inform from ui app 
@app.route('/api/get_lighton', methods=['GET'])
def respone_lighton():

    docs = db.collection('Light')
    docs = docs.order_by('timestamp', direction=firestore.Query.DESCENDING).limit(1).get()

    for doc in docs:
        result = doc.to_dict()

    time_data = datetime.datetime.fromtimestamp(result['timestamp'])
    time_data = time_data.strftime('%H:%M %d-%m-%Y')
    
    response = {
        'light1_on': result['light1_on'],
        'light2_on': result['light2_on'],
        'timestamp': time_data
    }

    return response


# Start Backend
if __name__ == '__main__':
    app.run(host='0.0.0.0', port='6868')
