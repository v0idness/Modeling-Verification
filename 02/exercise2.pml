/* series 2 exercise 2 */
/* laura.rettig@unifr.ch */

chan global = [0] of {bool};

proctype sender() {
	loop:
		if
			:: global!0;
			:: global!1;
		fi;
		goto loop
}

proctype receiver() {
	byte counter0 = 0;
	byte counter1 = 0;

	loop:
		if
			:: global?0 -> counter0++;
			:: global?1 -> counter1++;
		fi;
		goto loop
}

init { atomic { run sender(); run receiver() } }
