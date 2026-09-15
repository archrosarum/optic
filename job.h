#ifndef JOB_H
#define JOB_H


#include <stdint.h>

#include "task.h"


typedef struct {
	task_t 		task;		// Task this job is for.
	uint8_t		progress;	// Time (in mins) spent on task.
} job_t;

#endif
