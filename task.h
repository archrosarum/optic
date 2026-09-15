#ifndef TASK_H
#define TASK_H


#include <stdint.h>
#include <stdbool.h>

#include "date.h"


typedef struct {
	uint16_t 	id;				// Unique identifier used in database.
	char* 		name;			// Human-readable cosmetic identifier.
	bool 		criticality;	// Flag for the sorter and scheduler.
	uint16_t	priority;		// Determines scheduling precedence.
	datetime_t	deadline;		// Last time to safely resolve task.
	uint8_t		volume;			// Time (in mins) to resolve task.
} task_t;

#endif