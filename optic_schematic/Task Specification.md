*Total size:* 24 bits
#### **Attributes:**

**Archetype**:
*Size:* 16 bits
*Representing:* A binary expression

The archetype of a task is identical to the archetype of allocated time.
For a task to qualify to be scheduled into a particular allocated time slot, all of the activated bits in the tasks archetype must also be activated in the allocated time slots archetype (for absolute clarity, the time slot can permit more activated bits as well).

**Criticality**:
*Size:* 1 bit
*Representing:* A boolean condition

* The criticality of a task is either critical (1) or non-critical (0). 
* A task flagged as critical tells the scheduler that resolving it before its deadline is more important than resolving any non-critical task no matter its deadline.
* Non-critical tasks will not begin to be scheduled until all critical tasks have been scheduled.
* CRITICAL tasks have the power to extend your allocated time if its not marked as immutable

**Priority**:
*Size:* 8 bits
*Representing:* A positive integer

* 