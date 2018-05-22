import React, { Component } from "react";
import axios from "axios";
import numeral from "numeral";
import "./App.css";

const API_HOST = process.env.REACT_APP_API_HOST;
const API_PORT = process.env.REACT_APP_API_PORT;
// initialize api client
const API = axios.create({
  baseURL: `http://${API_HOST}:${API_PORT}`
});

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      dept_name: "",
      dept_no: "",
      departments: [],
      year: 2000,
      quarter: 1,
      report: null,
      loading: false,
      error: null
    };
  }
  componentDidMount() {
    // get all departments and place in dropdown
    API.get(`/departments`).then(res => {
      let departments = res.data;
      this.setState({ departments });
    });
  }
  selectDepartment(e) {
    let department = this.getDepartmentById(e.currentTarget.value);
    if (!department) {
      return;
    }
    // select department to be used in report
    this.setState({
      dept_no: department.dept_no,
      dept_name: department.dept_name
    });
  }
  getDepartmentById(dept_no) {
    let department = {};
    this.state.departments.forEach(dep => {
      // select department by dept_no
      if (dep.dept_no === dept_no) {
        department = dep;
      }
    });
    return department;
  }
  getReport() {
    // clear error message if any
    this.setState({ error: null, loading: true, report: null });

    const { dept_no, year, quarter } = this.state;

    // validate arguments
    if (!dept_no.length) {
      return this.setState({
        error: "Please select a department."
      });
    } else if (!year || year.toString().length !== 4) {
      return this.setState({
        error: "Please enter a valid year."
      });
    } else if (!quarter || quarter > 4 || quarter < 1) {
      return this.setState({
        error: "Please enter a valid quarter."
      });
    }

    // make request to the api
    API.get(`/report/${dept_no}?year=${year}&quarter=${quarter}`).then(res => {
      let report = res.data;
      // display report
      this.setState({ report, loading: false });
    });
  }
  onChange(e) {
    this.setState({
      [e.currentTarget.name]: e.currentTarget.value
    });
  }
  render() {
    // departments for dropdown selection
    const departments = this.state.departments.map((department, index) => (
      <option key={index} value={department.dept_no}>
        {department.dept_name}
      </option>
    ));
    const { report, loading, error } = this.state;

    return (
      <div className="container">
        <div className="heading">Salary Quarterly Report:</div>
        <div className="form">
          <select
            className="field"
            value={this.state.dept_no}
            onChange={this.selectDepartment.bind(this)}
          >
            <option value="">Select a department</option>
            {departments}
          </select>
          <input
            className="field"
            name="year"
            value={this.state.year}
            placeholder="Year"
            onChange={this.onChange.bind(this)}
          />
          <input
            className="field"
            name="quarter"
            value={this.state.quarter}
            placeholder="Quarter"
            onChange={this.onChange.bind(this)}
          />
          <input
            className="field"
            type="button"
            value="Get Report"
            onClick={this.getReport.bind(this)}
          />
          {error ? <div>{error}</div> : null}
        </div>
        {loading ? <div className="loading">Loading ...</div> : null}
        {report ? (
          <div className="report">
            <table>
              <tbody>
                <tr>
                  <td className="header">Department Name:</td>
                  <td>{report.dept_name || this.state.dept_name}</td>
                </tr>
                <tr>
                  <td className="header">Year:</td>
                  <td>{report.year}</td>
                </tr>
                <tr>
                  <td className="header">Quarter:</td>
                  <td>{report.quarter}</td>
                </tr>
                <tr>
                  <td className="header">Salary Paid:</td>
                  <td>${numeral(report.salary_paid).format("0,0.00")}</td>
                </tr>
              </tbody>
            </table>
          </div>
        ) : null}
      </div>
    );
  }
}

export default App;
