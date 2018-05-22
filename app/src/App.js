import React, { Component } from "react";
import axios from "axios";
import logo from "./logo.svg";
import "./App.css";

const API_HOST = process.env.REACT_APP_API_HOST;
const API_PORT = process.env.REACT_APP_API_PORT;
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
      error: ""
    };
  }
  componentDidMount() {
    API.get(`/departments`).then(res => {
      let departments = res.data;
      this.setState({
        departments
      });
    });
  }
  selectDepartment(e) {
    let dept_no = e.currentTarget.value;
    let department = this.getDepartmentById(dept_no);
    this.setState({
      dept_no: department.dept_no,
      dept_name: department.dept_name
    });
  }
  getDepartmentById(id) {
    let department = {};
    this.state.departments.forEach(dep => {
      if (dep.dept_no === id) {
        department = dep;
      }
    });
    return department;
  }
  getReport() {
    const { dept_no, year, quarter } = this.state;
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

    API.get(`/report/${dept_no}?year=${year}&quarter=${quarter}`).then(res => {
      let report = res.data;
      this.setState({
        report
      });
    });
  }
  onChange(e) {
    this.setState({
      [e.currentTarget.name]: e.currentTarget.value
    });
  }
  render() {
    const departments = this.state.departments.map((department, index) => (
      <option key={index} value={department.dept_no}>
        {department.dept_name}
      </option>
    ));
    const report = this.state.report;
    const error = this.state.error;

    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">Welcome to React</h1>
        </header>
        <select
          value={this.state.dept_no}
          onChange={this.selectDepartment.bind(this)}
        >
          <option value="">Select a department</option>
          {departments}
        </select>
        <input
          name="year"
          value={this.state.year}
          placeholder="Year"
          onChange={this.onChange.bind(this)}
        />
        <input
          name="quarter"
          value={this.state.quarter}
          placeholder="Quarter"
          onChange={this.onChange.bind(this)}
        />
        <input
          type="button"
          value="Get Report"
          onClick={this.getReport.bind(this)}
        />
        {error.length ? <div>{error}</div> : null}
        {report ? (
          <table>
            <thead>
              <tr>
                <th>Department Name:</th>
                <th>Year:</th>
                <th>Quarter:</th>
                <th>Salary Paid:</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>{report.dept_name || this.state.dept_name}</td>
                <td>{report.year}</td>
                <td>{report.quarter}</td>
                <td>${report.salary_paid}</td>
              </tr>
            </tbody>
          </table>
        ) : null}
      </div>
    );
  }
}

export default App;
