package main

import (
	"database/sql"
)

// Datastore is the interface for the persistence layer.
type Datastore interface {
	SalaryReport() error
}

// DS is the concrete implementation of the Datastore interface.
type DS struct {
	db *sql.DB
}

// SalaryReport
type SalaryReport struct {
	Department    string
	SalaryExpense int
}

// SalaryReport
func (ds *DS) SalaryReport(date string) (*SalaryReport, error) {
	report := SalaryReport{}
	err := ds.db.QueryRow("SELECT id, email, password FROM users WHERE email = $1;", email).Scan(&user.ID, &user.Email, &user.Password)
	if err != nil {
		return nil, errors.Wrap(err, "Could not get user.")
	}
	return &SalaryReport, nil
}
