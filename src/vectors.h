/*
 * VECTOR:
 * This header provides functions and types for vectors, and for dynamic arrays of vectors.
 * (Please note that the defenitions and declarations are all contained within this file.)
 */

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>


typedef struct {
    int x, y;
} vector;

typedef struct {
    vector* vectors;
    int length;
} vector_array;

vector_array* new_vector_array() {
    vector_array* arr = malloc(sizeof(vector_array));
    arr->vectors = NULL;
    arr->length = 0;
    return arr;
}

// destination argument uses UNIX file descriptors.
void write_vector_array(vector_array* from, int to) {
    for (int i = 0; i < from->length; i++) {
        int length = snprintf(NULL, 0, "(%d, %d)\n",
                              from->vectors[i].x,
                              from->vectors[i].y);

        char* vector_string = malloc(length + 1);

        snprintf(vector_string, length + 1, "(%d, %d)\n",
                 from->vectors[i].x,
                 from->vectors[i].y);

        write(to, vector_string, length);
        free(vector_string);
    }
}

void push_vector(vector_array* arr, vector vec) {
    arr->vectors = realloc(arr->vectors, sizeof(vector) * (arr->length + 1));
    arr->length++;
    arr->vectors[arr->length - 1] = vec;
}