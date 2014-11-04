/* series 4 */
/* laura.rettig@unifr.ch */

#define here 1
#define there 0

mtype = {self, wolf, sheep, cabbage};
chan boat = [1] of {byte};

active proctype thisSide() {
	bool present[4] = {1, 1, 1, 1};
	bool farmer = here;
	do	
		:: empty(boat) && farmer;
			if
				:: present[wolf] -> boat!wolf; present[wolf] = 0;
				:: present[sheep] -> boat!sheep; present[sheep] = 0;
				:: present[cabbage] -> boat!cabbage; present[cabbage] = 0;
				:: boat!self;	/* empty ride */
			fi
			farmer = there;
			/* block the bad situation */
			!((present[sheep] && present[cabbage] || present[wolf] && present[sheep]) && !farmer);
		:: nempty(boat); 
			if
				:: boat?wolf -> present[wolf] = 1;
				:: boat?sheep -> present[sheep] = 1;
				:: boat?cabbage -> present[cabbage] = 1;
				:: boat?self;
			fi
			farmer = here;
	od
}

active proctype otherSide() {
	bool present[4] = {0, 0, 0, 0}
	bool farmer = there;
	do	
		:: empty(boat) && farmer;
			if
				:: present[wolf] -> boat!wolf; present[wolf] = 0;
				:: present[sheep] -> boat!sheep; present[sheep] = 0;
				:: present[cabbage] -> boat!cabbage; present[cabbage] = 0;
				:: boat!self;	/* empty ride */
			fi
			farmer = there;
			/* block the bad situation */
			!((present[sheep] && present[cabbage] || present[wolf] && present[sheep]) && !farmer);
		:: nempty(boat); 
			if
				:: boat?wolf -> present[wolf] = 1;
				:: boat?sheep -> present[sheep] = 1;
				:: boat?cabbage -> present[cabbage] = 1;
				:: boat?self;
			fi
			farmer = here;
			/* target situation as assertion violation */
			assert(!(present[wolf] && present[sheep] && present [cabbage]));
	od
}

