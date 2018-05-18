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
func (ds *DS) SalaryReport() error {
	return nil
}
