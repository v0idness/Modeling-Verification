/* series 2 exercise 1 */
/* laura.rettig@unifr.ch */

byte count = 0;

proctype processA() {
	loop:
		count<255; count++;
		assert(count<255);	/* the assertion is violated as soon as 
							processA increments count to 255 */
		goto loop
}

proctype processB() {
	loop:
		count>0; count--;
		goto loop
}

init { atomic { run processA(); run processB() } }