/* scheduler.c
 * This is the process for recieving unscheduled task data and computing a relative schedule.
 */

#include "vectors.h"
#include "datatypes.h"


/* Schedule an unsorted array of tasks into a given block of time. */
vector_array* schedule(vector block, int* tasks, int num_tasks) {
    vector_array* scheduled = new_vector_array();

    int head = block.x;
    for (int i = 0; i < num_tasks; i++) {
        vector process = {head, head + tasks[i]};
        push_vector(scheduled, process);

        head += tasks[i];
    }

    return scheduled;
}

/* Write scheduled block to a POSIX file number. */
void write_schedule(vector_array* schedule, int fd) {
    write_vector_array(schedule, fd);
}
