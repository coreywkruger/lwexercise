package main

import (
	"encoding/json"
	"net/http"
)

// App provides a context for various long-lived application-wide resources.
type App struct {
	ds Datastore
}

// Report
type Report struct {
	Taco string `json:"taco"`
}

// SalaryReport provides an endpoint for user signup.
func (app *App) SalaryReport(w http.ResponseWriter, r *http.Request) {
	err := app.ds.SalaryReport()
	if err != nil {
		http.Error(w, http.StatusText(http.StatusInternalServerError), http.StatusInternalServerError)
	} else {
		w.Header().Add("Content-Type", "application/json")
		w.WriteHeader(http.StatusCreated)
		json.NewEncoder(w).Encode(Report{"shrimp"})
	}
}
