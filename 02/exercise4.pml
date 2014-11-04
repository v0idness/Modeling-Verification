/* series 2 exercise 4 */
/* laura.rettig@unifr.ch */

mtype = { P, C };
mtype turn = P;

active proctype producer() {
	do 						/* loop instead of label/goto */
		:: turn == P;		/* process blocked if statement is false */
			printf("Produce\n");
			turn = C;
							/* no need for the else; will remain waiting
							for the statement to be unblocked */
    od
}

active proctype consumer() {
	do
		:: turn == C;
			printf("Consume\n");
			turn = P;
	od
}