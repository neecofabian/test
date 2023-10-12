package database

import (
	"articulate/internal/database/basestore"
	"context"
	"time"

	"github.com/keegancsmith/sqlf"
	// "github.com/sourcegraph/sourcegraph/internal/database/basestore"
)

// CodeMonitorStore is an interface for interacting with the code monitor tables in the database
type PromptStore interface {
	basestore.ShareableStore
	Transact(context.Context) (PromptStore, error)
	Done(error) error
	Now() time.Time
	Clock() func() time.Time
	Exec(ctx context.Context, query *sqlf.Query) error

	// CreateMonitor(ctx context.Context, args MonitorArgs) (*Monitor, error)
	// UpdateMonitor(ctx context.Context, id int64, args MonitorArgs) (*Monitor, error)
	// UpdateMonitorEnabled(ctx context.Context, id int64, enabled bool) (*Monitor, error)
	// DeleteMonitor(ctx context.Context, id int64) error
	// GetMonitor(ctx context.Context, monitorID int64) (*Monitor, error)
	// ListMonitors(context.Context, ListMonitorsOpts) ([]*Monitor, error)
	// CountMonitors(ctx context.Context, userID *int32) (int32, error)

	CreateQueryTrigger(ctx context.Context, monitorID int64, query string) (*QueryTrigger, error)
	UpdateQueryTrigger(ctx context.Context, id int64, query string) error
	GetQueryTriggerForMonitor(ctx context.Context, monitorID int64) (*QueryTrigger, error)
	ResetQueryTriggerTimestamps(ctx context.Context, queryID int64) error
	SetQueryTriggerNextRun(ctx context.Context, triggerQueryID int64, next time.Time, latestResults time.Time) error
	GetQueryTriggerForJob(ctx context.Context, triggerJob int32) (*QueryTrigger, error)
	// EnqueueQueryTriggerJobs(context.Context) ([]*TriggerJob, error)
	// ListQueryTriggerJobs(context.Context, ListTriggerJobsOpts) ([]*TriggerJob, error)
	// CountQueryTriggerJobs(ctx context.Context, queryID int64) (int32, error)

	// UpdateTriggerJobWithResults(ctx context.Context, triggerJobID int32, queryString string, results []*result.CommitMatch) error
	// DeleteOldTriggerJobs(ctx context.Context, retentionInDays int) error
}

// promptStore exposes methods to read and write codemonitors domain models
// from persistent storage.
type promptStore struct {
	*basestore.Store
	now func() time.Time
}

var _ PromptStore = (*promptStore)(nil)

// Now returns the current UTC time with time.Microsecond truncated
// because Postgres 9.6 does not support saving microsecond. This is
// particularly useful when trying to compare time values between Go
// and what we get back from the Postgres.
func Now() time.Time {
	return time.Now().UTC().Truncate(time.Microsecond)
}

// CodeMonitorsWith returns a new Store backed by the given database.
func CodeMonitorsWith(other basestore.ShareableStore) *promptStore {
	return CodeMonitorsWithClock(other, Now)
}

// CodeMonitorsWithClock returns a new Store backed by the given database and
// clock for timestamps.
func CodeMonitorsWithClock(other basestore.ShareableStore, clock func() time.Time) *promptStore {
	handle := basestore.NewWithHandle(other.Handle())
	return &promptStore{Store: handle, now: clock}
}

// Clock returns the clock of the underlying store.
func (s *promptStore) Clock() func() time.Time {
	return s.now
}

func (s *promptStore) Now() time.Time {
	return s.now()
}

// Transact creates a new transaction.
// It's required to implement this method and wrap the Transact method of the
// underlying basestore.Store.
func (s *promptStore) Transact(ctx context.Context) (PromptStore, error) {
	txBase, err := s.Store.Transact(ctx)
	if err != nil {
		return nil, err
	}
	return &promptStore{Store: txBase, now: s.now}, nil
}

type JobTable int

const (
	TriggerJobs JobTable = iota
	ActionJobs
)

type JobState int

const (
	Queued JobState = iota
	Processing
	Completed
	Errored
	Failed
)
