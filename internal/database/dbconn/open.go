package dbconn

import (
	"database/sql"
	"strconv"
	"sync"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/stdlib"
	// "github.com/sourcegraph/sourcegraph/internal/env"
	// "github.com/sourcegraph/sourcegraph/lib/errors"
)

func newWithConfig(cfg *pgx.ConnConfig) (*sql.DB, error) {
	db, err := open(cfg)
	if err != nil {
		return nil, err
	}

	return db, nil
}

var registerOnce sync.Once

func open(cfg *pgx.ConnConfig) (*sql.DB, error) {
	db, err := sql.Open("postgres-proxy", stdlib.RegisterConnConfig(cfg))
	if err != nil {
		return nil, err
	}

	// Set max open and idle connections
	maxOpen, _ := strconv.Atoi(cfg.RuntimeParams["max_conns"])
	if maxOpen == 0 {
		maxOpen = 20
	}

	db.SetMaxOpenConns(maxOpen)
	db.SetMaxIdleConns(maxOpen)
	db.SetConnMaxIdleTime(time.Minute)

	return db, nil
}
