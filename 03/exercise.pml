/* series 3 */
/* laura.rettig@unifr.ch */

/* same model for left turns or going straight: no car on the right or on the intersection */
mtype = {leftORstraight, right};
/* bools are 1 when there is a car on the respective road or intersection */
/* intersection is basically a mutex */
byte intersection = 0; 	
byte carNorth, carEast, carSouth, carWest = 0; 
/* yield priority */
mtype = {Nturn, Eturn, Sturn, Wturn};
byte turn;

active proctype roadNorth() {
	do	/* nondeterministically there is either a car here or not */
		:: carNorth = 1 ->
			turn = Wturn;
			if /* nondet. decide for a direction */
				:: leftORstraight ->
					carWest == 0;
					((turn == Nturn && intersection == 0) || (carEast == 0 && carSouth == 0 && carWest == 0 && intersection == 0));
					intersection++; carNorth = 0; /* move onto the intersection */
					assert(intersection <= 1); 	/* not more than one car in the intersection */
					intersection = 0; 	/* leave the intersection */
				:: right ->
					((turn == Nturn && intersection == 0) || (carEast == 0 && carSouth == 0 && carWest == 0 && intersection == 0)); 	
					intersection++; carNorth = 0;
					assert(intersection <= 1); 	/* not more than one car in the intersection */
					intersection = 0; 	/* leave the intersection */
			fi
			/* not blocked forever */
			progress: skip
		:: skip
	od
}

active proctype roadEast() {
	do	/* nondeterministically there is either a car here or not */
		:: carEast = 1 ->
			turn = Nturn;
			if /* nondet. decide for a direction */
				:: leftORstraight ->
					carNorth == 0;
					((turn == Eturn && intersection == 0) || (carNorth == 0 && carSouth == 0 && carWest == 0 && intersection == 0));
					intersection++; carEast = 0; /* move onto the intersection */
					assert(intersection <= 1); 	/* not more than one car in the intersection */
					intersection = 0; 	/* leave the intersection */
				:: right ->
					((turn == Eturn && intersection == 0) || (carNorth == 0 && carSouth == 0 && carWest == 0 && intersection == 0)); 	
					intersection++; carEast = 0;
					assert(intersection <= 1); 	/* not more than one car in the intersection */
					intersection = 0; 	/* leave the intersection */
			fi
		:: skip
	od
}

active proctype roadSouth() {
	do	/* nondeterministically there is either a car here or not */
		:: carSouth = 1 ->
			turn = Eturn;
			if /* nondet. decide for a direction */
				:: leftORstraight ->
					carEast == 0;
					((turn == Sturn && intersection == 0) || (carEast == 0 && carNorth == 0 && carWest == 0 && intersection == 0));
					intersection++; carSouth = 0; /* move onto the intersection */
					assert(intersection <= 1); 	/* not more than one car in the intersection */
					intersection = 0; 	/* leave the intersection */
				:: right ->
					((turn == Sturn && intersection == 0) || (carEast == 0 && carNorth == 0 && carWest == 0 && intersection == 0)); 	
					intersection++; carSouth = 0;
					assert(intersection <= 1); 	/* not more than one car in the intersection */
					intersection = 0; 	/* leave the intersection */
			fi
		:: skip
	od
}

active proctype roadWest() {
	do	/* nondeterministically there is either a car here or not */
		:: carWest = 1 ->
			turn = Sturn;
			if /* nondet. decide for a direction */
				:: leftORstraight ->
					carSouth == 0;
					((turn == Wturn && intersection == 0) || (carEast == 0 && carSouth == 0 && carNorth == 0 && intersection == 0));
					intersection++; carWest = 0; /* move onto the intersection */
					assert(intersection <= 1); 	/* not more than one car in the intersection */
					intersection = 0; 	/* leave the intersection */
				:: right ->
					((turn == Wturn && intersection == 0) || (carEast == 0 && carSouth == 0 && carNorth == 0 && intersection == 0)); 	
					intersection++; carWest = 0;
					assert(intersection <= 1); 	/* not more than one car in the intersection */
					intersection = 0; 	/* leave the intersection */
			fi
		:: skip
	od
}

/* deadlock situation */
never {
	do
		:: carNorth == 1 && carEast == 1 && carSouth == 1 && carWest == 1; break;
		:: else ;
	od
}
