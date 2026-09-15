#ifndef DATE_H
#define DATE_H


#include <stdint.h>


typedef struct {
	uint8_t 	s;		// Second. (0 <= s <= 60)
	uint8_t 	m;		// Minute. (0 <= m <= 60)
	uint8_t 	h;		// Hour.   (0 <= h <= 24)
} time_t;


typedef struct {
	uint8_t 	d;		// Day. (Between one and the calculated end of the month)
	uint8_t 	M;		// Month. (1 <= s <= 12)
	uint16_t 	y;		// Year.
} date_t;

typedef struct {
	/* Date */
	uint8_t 	d;
	uint8_t 	M;
	uint16_t 	y;

	/* Time */
	int8_t 		s;
	uint8_t 	m;
	uint8_t 	h;
} datetime_t;


#endif