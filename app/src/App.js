import React, { Component } from "react";
import axios from "axios";
import logo from "./logo.svg";
import "./App.css";

const API_HOST = process.env.REACT_APP_API_HOST;
const API_PORT = process.env.REACT_APP_API_PORT;

class App extends Component {
  componentDidMount() {
    const API = axios.create({
      baseURL: `http://${API_HOST}:${API_PORT}`
    });

    API.get(`/report/${"d005"}?year=${2000}&quarter=${1}`).then(res =>
      console.log(res)
    );
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
