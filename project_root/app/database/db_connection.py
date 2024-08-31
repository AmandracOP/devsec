# db_connection.py

import pymongo

def get_db_connection():
    client = pymongo.MongoClient("mongodb://db:27017/")
    db = client["mydatabase"]
    return db
