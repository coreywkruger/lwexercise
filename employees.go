package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"

	_ "github.com/go-sql-driver/mysql"

	"github.com/gorilla/mux"
	"github.com/rs/cors"
	"github.com/urfave/negroni"
)

func newDB(dsn string) (*DS, error) {
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		return nil, err
	}
	if err = db.Ping(); err != nil {
		return nil, err
	}
	return &DS{db}, nil
}

func main() {
	_, ok := os.LookupEnv("HOST")
	if !ok {
		os.Setenv("HOST", "0.0.0.0")
	}

	_, ok = os.LookupEnv("PORT")
	if !ok {
		os.Setenv("PORT", "3000")
	}

	_, ok = os.LookupEnv("DSN")
	if !ok {
		os.Setenv("DSN", "root:password@tcp(db:3306)/employees")
	}

	host := os.Getenv("HOST")
	port := os.Getenv("PORT")
	dsn := os.Getenv("DSN")

	ds, err := newDB(dsn)
	if err != nil {
		log.Panic(err)
	}

	app := &App{ds}

	router := mux.NewRouter()
	router.HandleFunc("/salary-report", app.SalaryReport).Methods("GET")

	n := negroni.New()
	n.UseHandler(router)

	serverAddress := fmt.Sprintf("%s:%s", host, port)
	log.Println("Starting server on: ", serverAddress)
	log.Fatal(http.ListenAndServe(serverAddress, cors.Default().Handler(n)))
}
