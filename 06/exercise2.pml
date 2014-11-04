/* series 6 exercise 2 */
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

never  {    /* <>(count>1) */
T0_init:
	do
	:: atomic { ((count>1)) -> assert(!((count>1))) }
	:: (1) -> goto T0_init
	od;
accept_all:
	skip
}

init { atomic {run process(0); run process(1)} }
