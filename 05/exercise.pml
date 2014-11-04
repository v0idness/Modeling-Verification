/* series 5 : Lift Control System */
/* laura.rettig@unifr.ch */

#define true 1
#define false 0

mtype = {none, up, down};
mtype = {top, floor3, floor2, floor1, ground};

typedef array { bool d[2] = {false, false} }; array illum_f[9];

/* keeping the channel small to reduce the execution of the controller */
chan request = [10] of {mtype, mtype};

active proctype floors() {
	do
		:: len(request) < 10
			if
				/* at any time, any button can be pressed */
				:: atomic { illum_f[ground].d[up-1] = true; request!ground,up }
				:: atomic { illum_f[floor1].d[up-1] = true; request!floor1,up }
				:: atomic { illum_f[floor1].d[down-1] = true; request!floor1,down }
				:: atomic { illum_f[floor2].d[up-1] = true; request!floor2,up }
				:: atomic { illum_f[floor2].d[down-1] = true; request!floor2,down }
				:: atomic { illum_f[floor3].d[up-1] = true; request!floor3,up }
				:: atomic { illum_f[floor3].d[down-1] = true; request!floor3,down }
				:: atomic { illum_f[top].d[down-1] = true; request!top,down }
			fi
	od
}

active [2] proctype elevator() {
	mtype loc = ground;
	mtype dir = none;
	bool illum_e[9]; 	/* buttons inside elevator: where to bring */
	mtype req_loc = none;		/* buttons outside: where to pick up */
	mtype req_dir;

	do	
		/* have a direction and move */
		:: (dir==up && loc!=top); 
			loc++;
			if 
				:: loc==req_loc -> 
					illum_f[loc].d[dir-1] = false; req_loc = none; illum_e[loc] = false;
				:: else
			fi
			if 
				:: illum_e[loc] -> illum_e[loc] = false;
					if
						:: !(illum_e[ground] || illum_e[floor1] || 
							illum_e[floor2] || illum_e[floor3] || illum_e[top]) ->
					 		dir = none;
					 	:: else
					 fi
				:: else
			fi
		:: (dir==down && loc!=ground);
			loc--;
			if 
				:: loc==req_loc -> 
					illum_f[loc].d[dir-1] = false; req_loc = none; illum_e[loc] = false;
				:: else
			fi
			if 
				:: illum_e[loc] -> illum_e[loc] = false;
					if
						:: !(illum_e[ground] || illum_e[floor1] || 
							illum_e[floor2] || illum_e[floor3] || illum_e[top]) ->
					 		dir = none;
					 	:: else
					 fi
				:: else
			fi
		/* any button can be pressed inside the elevator */
		:: loc != ground; illum_e[ground] = true; dir = down;
		:: loc != floor1; illum_e[floor1] = true; 
			if
				:: loc < floor1 -> dir = up;
				:: loc > floor1 -> dir = down;
			fi
		:: loc != floor2; illum_e[floor2] = true; 
			if
				:: loc < floor2 -> dir = up;
				:: loc > floor2 -> dir = down;
			fi
		:: loc != floor3; illum_e[floor3] = true; 
			if
				:: loc < floor3 -> dir = up;
				:: loc > floor3 -> dir = down;
			fi
		:: loc != top; illum_e[top] = true; dir = up;

		/* read request for elevator issued at floors */
		:: req_loc = none; request??req_loc,req_dir;
			if
				:: req_loc == loc && req_dir == dir -> illum_f[loc].d[dir-1] = false;
				:: (req_loc < loc && dir == down) || (req_loc > loc && dir == up) -> 
					illum_e[req_loc] = true;
				:: dir == none && req_loc < loc -> dir = down; illum_e[req_loc] = true;
				:: dir == none && req_loc > loc -> dir = up; illum_e[req_loc] = true;
				:: else request!req_loc,req_dir; /* re-insert to channel if not matching any */
			fi		
	od
}
