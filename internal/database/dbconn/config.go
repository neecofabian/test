package dbconn

import (
	"github.com/jackc/pgx/v5"
	// "github.com/sourcegraph/sourcegraph/internal/env"
	// "github.com/sourcegraph/sourcegraph/lib/errors"

	"github.com/caarlos0/env/v9"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

type config struct {
	DataSource      string `env:"PGDATASOURCE"`
	ApplicationName string `env:"PGAPPLICATIONNAME" envDefault:"articulate"`
}

// buildConfig takes either a Postgres connection string or connection URI,
// parses it, and returns a config with additional parameters.
func buildConfig(dataSource, app string) (*pgx.ConnConfig, error) {
	cfg_env := config{}
	if err := env.Parse(&cfg_env); err != nil {
		log.Err(err)
		return nil, err
	}

	cfg, err := pgx.ParseConfig(cfg_env.DataSource)
	if err != nil {
		return nil, err
	}

	// if cfg.RuntimeParams == nil {
	// 	cfg.RuntimeParams = make(map[string]string)
	// }
	//
	// // pgx doesn't support dbname so we emulate it
	// if dbname, ok := cfg.RuntimeParams["dbname"]; ok {
	// 	cfg.Database = dbname
	// 	delete(cfg.RuntimeParams, "dbname")
	// }
	//
	// // pgx doesn't support fallback_application_name so we emulate it
	// // by checking if application_name is set and setting a default
	// // value if not.
	// if _, ok := cfg.RuntimeParams["application_name"]; !ok {
	// 	cfg.RuntimeParams["application_name"] = cfg_env.ApplicationName
	// }

	return cfg, nil
}
