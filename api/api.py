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

    # default report layout
    report = {
        "dept_no": dept_no, 
        "year": year, 
        "quarter": quarter, 
        "dept_name": "", 
        "salary_paid": 0
    }

    # result sets from sproc
    result_sets = []
    # print out the result
    for result in cursor.stored_results():
        result_sets.append(result.fetchall())

    cursor.close()

    if len(result_sets) > 0:
        result = result_sets[0][0]
        dept_name = ''.join(result[3])
        report = {
            "dept_no": dept_no, 
            "year": year, 
            "quarter": quarter, 
            "dept_name": dept_name, 
            "salary_paid": float(result[4])
        }

    return jsonify(report)

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
