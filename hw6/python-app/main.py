from email import header
from urllib import response
from flask import Flask, request
import requests, json
import config
app = Flask(__name__)

@app.route("/")
def index():
    return app.send_static_file("index.html")

@app.route("/business_search")
def business_search():
    term = request.args.get("keyword")
    latitude = request.args.get("latitude")
    longitude = request.args.get("longitude")
    categories = request.args.get("categories")
    radius = int(request.args.get("radius"))
    radius = int(radius * 1609.344)
    url = "https://api.yelp.com/v3/businesses/search?term={}&latitude={}&longitude={}&categories={}&radius={}".format(term, latitude, longitude, categories, radius)
    # print(config.YELP_API_KEY)
    headers = {
        'Authorization': 'Bearer {}'.format(config.YELP_API_KEY)  
    }
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        res = response.json()
    else:
        res = {}
    return json.dumps(res)

@app.route("/business_info/")
def get_business_info():
    business_id = request.args.get("business_id")
    url = "https://api.yelp.com/v3/businesses/{}".format(business_id)
    headers = {
        'Authorization': 'Bearer {}'.format(config.YELP_API_KEY)
    }
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        res = response.json()
    else:
        res = {}

    return json.dumps(res)

if __name__ == "__main__":
    app.run(host='127.0.0.1',port=8080,debug=True)