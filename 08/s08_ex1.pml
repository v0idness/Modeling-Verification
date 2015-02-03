/* series 8: model with never claim */
/* laura.rettig@unifr.ch */

#define p process[p1]@critical
#define q process[p2]@critical

bool t;
byte p1, p2;
bool x[2];
byte count;

proctype process(bool me, other) {
do
	:: x[me] = true;
	t = other;
	(x[other] == false || t == me);
critical:	x [me] = false
od
}

never {
	T0_init:
	do 
		:: !(p) -> goto accept_S1;
		:: !(q) -> goto accept_S3;
		:: 1 -> goto S2;
		:: 1 -> goto S4;
	od;
	accept_S1:
	do 
		:: !(p) -> goto accept_S1;
	od;
	S2:
	do 	
		:: !(p) -> goto accept_S1;
		:: 1 -> goto S2;
	od;
	accept_S3:
	do 
		:: !(q) -> goto accept_S3;
	od;
	S4:
	do 
		:: !(q) -> goto accept_S3;
		:: 1 -> goto S4;
	od;
}

init { atomic {p1 = run process(0,1); p2 = run process(1,0)} }
