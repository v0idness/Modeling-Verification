/* series 6 exercise 1 */
/* laura.rettig@unifr.ch */

#define true 1
#define false 0

bool t;
byte count;
bool xy[2];

proctype process(bool idx) {
	start:
	xy[idx] = true;
	t = 1-idx;
	(xy[1-idx] == false || t == idx);
	count++; /* critical section */
	count--;
	xy[idx] = false;
	goto start
}

never {
	do
		:: count > 1; break;
		:: else;
	od
}

init { atomic {run process(0); run process(1)} }
