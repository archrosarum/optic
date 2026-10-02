#ifndef DATA_H
#define DATA_H

/* Dynamic arrays */

typedef struct {
    void*   blocks;
    int     block_size;
    int     length;
} dynamic_array;

/* This enum is used as a flag when calling free_dynamic_array() to dictate behavior. */
typedef enum {
    FREE_BLOCKS,    // If the array contains pointers, this flag will free them all.
    FREE_JUST_THIS, // This flag will only free the dynamic array passed in.
} free_dynamic_array_flag;

/* Provide a pointer to a new empty dynamic array. (no specific type) */
dynamic_array* new_dynamic_array(
    int block_size
);

/* Free the memory given by a pointer to a dynamic array */
void free_dynamic_array(
    dynamic_array* arr, 
    free_dynamic_array_flag flag
);

/* Insert a new block onto a dynamic array at a certain index. */
void insert_block(
    dynamic_array* arr,
    void* block,
    int i
);

/* Remove a block at a given index from a dynamic array. */
void remove_block(
    dynamic_array* arr,
    int i
);

/* Get the typeless block at a provided index from a dynamic array. */
void* get_block(
    dynamic_array* arr,
    int i
);



/* Vector */

typedef struct {
    int x, y;
} vector;


/* Scheduling data */

// This struct is the return value of every individual block scheduling operation done by the scheduler.
typedef struct {
    vector_array* block;        // Tasks that were scheduled into the provided block.
    task_array* overflow;       // Overflow tasks that were not fitted in provided block.
} schedule_result;

schedule_result* new_schedule_result();

typedef struct {
    char name[16];
    int duration;
} task;

typedef struct {
    task* tasks;
    int length;
} task_array;

task_array* new_task_array();
void push_task(task_array* arr, task task);

#endif