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

/* Provide a pointer to a new empty dynamic_array. (no specific type) */
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

/* Get the (typeless) block at a provided index from a dynamic array. */
void* get_block(
    dynamic_array* arr,
    int i
);


/* Vectors */

/* Contains two floating point components. */
typedef struct {
    float x, y;
} float_vector;

/* Contains two integer components. */
typedef struct {
    int x, y;
} int_vector;


/* Scheduling data */

/* This is returned by each chunk scheduling call answered by the scheduler. */
typedef struct {
    dynamic_array* chunk;       // Tasks that were scheduled into the provided block.
    dynamic_array* overflow;    // Overflow tasks that were not fitted in provided block.
} schedule_out;

/* Provide a pointer to a new empty schedule_result. */
schedule_out* new_schedule_out();

/* Contains all attributes associated with a particular task. */
typedef struct {
    char name[16];  // Human-readable name (no expectation of uniqueness)
    float duration; // Duration of the task (total time it must be given to resolve)
} task;

#endif