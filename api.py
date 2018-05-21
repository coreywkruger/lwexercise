import os
from flask import Flask
from flask import jsonify
import mysql.connector

app = Flask(__name__)

def mysqlConnection():
    return mysql.connector.connect(host='db',database=os.environ.get('MYSQL_DATABASE'),user=os.environ.get('MYSQL_USER'),password=os.environ.get('MYSQL_PASSWORD'))

@app.route("/")
def hello():
    conn = mysqlConnection()
    cursor = conn.cursor()
    cursor.callproc('get_salary_sums', (2000, 1, 'd005'))
    results = []
    
    # print out the result
    for result in cursor.stored_results():
        results.append(result.fetchall()[0])

    report = results[0]

    return jsonify(year=report[0], quarter=report[1], department=report[2], salary_paid=float(report[3]))
 
if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)