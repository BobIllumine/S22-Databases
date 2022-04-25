from datetime import date, datetime

from pymongo import MongoClient

client = MongoClient("mongodb://localhost")
db = client['test']
