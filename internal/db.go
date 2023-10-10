package db

type ErrNotFound struct {
	// id is the ID that wasn't found.
	id string
	// entityType is the type of the entity that the caller was looking for.
	entityType string

	dog string
}
