/*
 * scheduler:
 * process for recieving unscheduled task data and computing a relative schedule.
 * it opens to handle args, persists until externally closed, and pipes output to stdout.
 */

#include "vectors.h"

vector_array* schedule(vector block, int* tasks) {
    vector_array* sched = new_vector_array();

    int head = block.x;
    for (int i = 0; i < 3; i++) {
        vector process = {head, head + tasks[i]};
        head += tasks[i];
        push_vector(sched, process);
    }

    return sched;
}

int main(int argc, char* argv[]) {
    vector users_time = {9, 17};
    int* tasks = malloc(sizeof(int) * 3);
    tasks[0] = 1;
    tasks[1] = 3;
    tasks[2] = 4;


    vector_array* sched = schedule(users_time, tasks);

    write_vector_array(sched, STDOUT_FILENO);


    return 0;
}