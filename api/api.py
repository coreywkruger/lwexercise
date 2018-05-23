import os
from functools import wraps
from flask import Flask, make_response, g
from flask import request
from flask import jsonify
import mysql.connector

app = Flask(__name__)

# Setup cors
def response_headers(f):
    @wraps(f)
    def cors(*args, **kwargs):
        response = make_response(f(*args, **kwargs))
        response.headers["Access-Control-Allow-Origin"] = "*"
        return response
    return cors

# initialize new connection to the database
def mysql_connection():
    return mysql.connector.connect(
        host='db', 
        database=os.environ.get('MYSQL_DATABASE'), 
        user=os.environ.get('MYSQL_USER'), 
        password=os.environ.get('MYSQL_PASSWORD')
    )

# get database connection if exists
def get_db():
    db = g.get("database", None)
    if db is None:
        db = g.database = mysql_connection()
    return db

# close database connection
@app.teardown_appcontext
def teardown_db(exception):
    db = g.get("database", None)
    if db is not None:
        db.close()

# define report route
@app.route("/report/<dept_no>", methods=["GET"])
@response_headers
def report(dept_no):

    year = request.args.get('year', default=2000, type=int)
    quarter = request.args.get('quarter', default=1, type=int)

    db = get_db()
    cursor = db.cursor()
    cursor.callproc('get_salary_sums', (year, quarter, dept_no))
    results = {"dept_no": dept_no, "year": year, "quarter": quarter, "dept_name": "", "salary_paid": 0}

    # print out the result
    for result in cursor.stored_results():
        response = result.fetchall()
        if len(response) > 0:
            resultSet = response[0]
            results = {
                "year": resultSet[0], 
                "quarter": resultSet[1], 
                "dept_no": resultSet[2], 
                "dept_name": resultSet[3], 
                "salary_paid": float(resultSet[4])
            }
    
    cursor.close()
    
    return jsonify(results)

# define department list route
@app.route("/departments", methods=["GET"])
@response_headers
def departments():
    conn = get_db()
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
