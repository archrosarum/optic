/* scheduler.c
 * This is the process for recieving unscheduled task data and computing a relative schedule.
 */

#include "data.h"


/* Schedule an unsorted array of tasks into a given block of time. */
schedule_result* schedule(vector block, int* tasks, int num_tasks) {

    schedule_result* scheduled = new_schedule_result();

    int head = block.x;
    for (int i = 0; i < num_tasks; i++) {

        // Can this task no longer fit?
        if (head + tasks[i] > block.y) return scheduled;

        push_vector(scheduled->block, (vector){head, head + tasks[i]});
        head += tasks[i];
    }

    return scheduled;
}

/* Write scheduled block to a POSIX file number. */
void write_schedule(vector_array* schedule, int fd) {

    write_vector_array(schedule, fd);
}



// test
int main() {

}