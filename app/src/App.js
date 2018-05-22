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
      department: "",
      departments: [],
      year: 2000,
      quarter: 1,
      report: {}
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
  selectDepartment(department) {
    this.setState({
      department
    });
  }
  getReport() {
    API.get(
      `/report/${this.state.department}?year=${this.state.year}&quarter=${this
        .state.quarter}`
    ).then(res => {
      let report = res.data;
      this.setState({
        report
      });
    });
  }
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">Welcome to React</h1>
        </header>
        <p className="App-intro">
          To get started, edit <code>src/App.js</code> and save to reload.
        </p>
      </div>
    );
  }
}

export default App;
