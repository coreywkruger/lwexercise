import unittest
import os
import mysql.connector
from datetime import date, datetime

def get_db():
    return mysql.connector.connect(
        host='db',
        user='root',
        database='employees',
        password=os.environ.get("MYSQL_ROOT_PASSWORD")
    )

def load_sql(file_name):
    file = open(file_name, "r")
    sql = file.read()
    file.close()
    return sql

class TestDB(unittest.TestCase):
    def setUp(self):

        # create test database
        self.database = get_db()
        cursor = self.database.cursor()
        cursor.execute(load_sql("./test/test_seed.sql"), multi=True)
        cursor.close()

    def tearDown(self):
        self.database.close()
