/* data.c
 * This file contains definitions for functions that do work with the datatypes defined in the matching header.
 */

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>

#include "data.h" // Datatypes are defined here

/* Dynamic arrays */

dynamic_array* new_dynamic_array(int block_size) {

    // Allocate and populate some memory for the struct
    vector_array* arr = malloc(sizeof(vector_array));
    *arr = (dynamic_array){NULL, block_size, 0};

    return arr; // Give the pointer to the caller
}

void free_dynamic_array(dynamic_array* arr, free_dynamic_array_flag flag) {

    // If the blocks are pointers then free them all
    if (flag == FREE_BLOCKS) {
        void** blocks = arr->blocks;
        for (int i = 0; i < arr->length; i++) free(blocks[i]);
    }

    // Free the dynamic array
    free(arr->blocks);
    free(arr);
}

void insert_block(dynamic_array* arr, void* block, int i) {

    // Resize the dynamic array
    size_t new_size = ((size_t)arr->length + 1) * arr->block_size;
    arr->blocks = realloc(arr->blocks, new_size);

    // Calculate location and size of data to move forwards
    size_t ptr_offset = (size_t)i * arr->block_size;
    char* push_to = (char*)arr->blocks + ptr_offset;

    char* next_block = push_to + arr->block_size;

    size_t blocks_ahead = (size_t)(arr->length - i);
    size_t bytes_ahead = blocks_ahead * arr->block_size;

    // Move data forwards to make room for new block
    memmove(next_block, push_to, bytes_ahead);

    // Copy the provided block into the empty space
    memcpy(push_to, block, arr->block_size);
}

void remove_block(dynamic_array* arr, int i) {

    // Calculate location and size of data to move backwards
    int ptr_offset = (size_t)i * arr->block_size;
    char* block = (char*)arr->blocks + ptr_offset;

    char* next_block = block + arr->block_size;

    size_t blocks_ahead = (size_t)(arr->length - i - 1);
    size_t bytes_ahead = blocks_ahead * arr->block_size;

    // Move data backwards to overwrite old block
    memmove(block, next_block, bytes_ahead);

    // Shrink the dynamic array afterwards
    arr->length -= 1;
    int new_size = (size_t)arr->length * arr->block_size;
    arr->blocks = realloc(arr->blocks, new_size);
}

void* get_block(dynamic_array* arr, int i) {

    int ptr_offset = i * arr->block_size;
    return (char*)arr->blocks + ptr_offset;
}


/* Scheduling data */

task_array* new_task_array();
void push_task(task_array* arr, task task);

// Provide a new schedule_result for the scheduler to populate and return. 
schedule_result* new_schedule_result() {

    schedule_result* result = malloc(sizeof(schedule_result));

    result->block = new_vector_array();
    result->overflow = new_vector_array();

    return result;
}