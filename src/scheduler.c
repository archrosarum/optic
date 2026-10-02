/* scheduler.c
 * This is the process for recieving unscheduled task data and computing a relative schedule.
 */

#include "data.h"
#include <stdio.h>


/* Schedule an unsorted array of tasks into a given chunk of time. */
schedule_out* schedule(float_vector chunk, task* tasks, int num_tasks) {

    schedule_out* scheduled = new_schedule_out(); // Get an empty output struct

    float head = chunk.x;

    // Iterate through all of the provided tasks
    for (int i = 0; i < num_tasks; i++) {

        // Check if task can fit in the chunks remaining capacity
        if (head + tasks[i].duration > chunk.y) {
            
            // Copy all unhandled tasks into the overflow
            for (int j = i; j < num_tasks; j++) {

                task entry = tasks[j];
                insert_block(scheduled->overflow, &entry, scheduled->overflow->length);
            }

            return scheduled; // Early return the schedule output
        }

        float_vector entry = {head, head + tasks[i].duration};
        insert_block(scheduled->chunk, &entry, scheduled->chunk->length);
        head += tasks[i].duration;
    }

    return scheduled; // Return with all tasks in the chunk
}




// test
int main() {
    task tasks[2] = {(task){"task1", 4.0}, (task){"task2", 9.0}};

    schedule_out* scheduled_chunk = schedule(
        (float_vector){9.0, 17.0}, tasks, 2
    );

    printf("first task: %s from %f to %f\n", 
        tasks[0].name,
        (*(float_vector*)get_block(scheduled_chunk->chunk, 0)).x,
        (*(float_vector*)get_block(scheduled_chunk->chunk, 0)).y
    );

    printf("first overflow: %s lasting %f\n", 
        tasks[1].name,
        (*(task*)get_block(scheduled_chunk->overflow, 0)).duration
    );
}