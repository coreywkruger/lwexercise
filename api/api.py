import os
from functools import wraps
from flask import Flask, make_response
from flask import request
from flask import jsonify
import mysql.connector

app = Flask(__name__)

# initialize new connection to the database
def mysqlConnection():
    return mysql.connector.connect(host='db', database=os.environ.get('MYSQL_DATABASE'), user=os.environ.get('MYSQL_USER'), password=os.environ.get('MYSQL_PASSWORD'))

# Setup cors
def response_headers(f):
    @wraps(f)
    def cors(*args, **kwargs):
        response = make_response(f(*args, **kwargs))
        response.headers["Access-Control-Allow-Origin"] = "*"
        return response
    return cors

# define report route
@app.route("/report/<department>", methods=["GET"])
@response_headers
def report(department):

    year = request.args.get('year', default=2000, type=int)
    quarter = request.args.get('quarter', default=1, type=int)

    conn = mysqlConnection()
    cursor = conn.cursor()
    cursor.callproc('get_salary_sums', (year, quarter, department))
    results = []

    # print out the result
    for result in cursor.stored_results():
        results.append(result.fetchall()[0])

    report = results[0]

    return jsonify(year=report[0], quarter=report[1], dept_no=report[2], dept_name=report[3], salary_paid=float(report[4]))

# define department list route
@app.route("/departments", methods=["GET"])
@response_headers
def departments():
    conn = mysqlConnection()
    cursor = conn.cursor()
    cursor.execute("select dept_no, dept_name from departments")

    results = []
    for (dept_no, dept_name) in cursor:
        results.append({
            "dept_no": dept_no,
            "dept_name": dept_name
        })

    return jsonify(results)


if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
