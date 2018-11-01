(define (domain rovers)
	(:requirements :strips :typing :fluents :disjunctive-preconditions :durative-actions)
	
	(:types
		waypoint
		bad_waypoint - waypoint
		rover
		sample
		bad_sample - sample
	)
	
	(:functions
		(battery-amount ?r - rover)
		(battery-capacity)
	)
	
	(:predicates
	
		(at ?r - rover ?wp - waypoint)
		(been-at ?r - rover ?wp - waypoint)

		(is-in ?s - sample ?wp - waypoint)
		(carry ?r - rover ?s - sample)
		(stored-sample ?s - sample)

		(is-recharging-dock ?wp - waypoint)
		(is-dropping-dock ?wp - waypoint)
		
		(adjacent ?wp1 ?wp2 - waypoint)
		(same-type ?s1 ?s2 - sample)
		(same-size ?s1 ?s2 - sample)

		(can-move ?r - rover ?to - waypoint)
		(can-sample ?r - rover ?s - sample)
		(can-sample-at ?r - rover ?wp - waypoint)
	)
	
	(:action move
		:parameters (?r - rover ?from - waypoint ?to - waypoint)
		:precondition (and 
				(at ?r ?from)
				(can-move ?r ?to)
				(> (battery-amount ?r) 8)
				)
		:effect (and 
				(at ?r ?to)
				(been-at ?r ?to)
				(not (at ?r ?from))
				(decrease (battery-amount ?r) 8)
				)
	)

	(:action take-sample
		:parameters (?r - rover ?s - sample ?wp - waypoint)
		:precondition (and 
				(is-in ?s ?wp)
				(at ?r ?wp)
				(> (battery-amount ?r) 3)
				(can-sample ?r ?s)
				(can-sample-at ?r ?wp)
				)
		:effect (and 
				(not (is-in ?s ?wp))
				(carry ?r ?s)
				(decrease (battery-amount ?r) 3)
				)
	)
	
	(:action drop-sample
		:parameters (?r - rover ?s - sample ?wp - waypoint)
		:precondition (and 
				(is-dropping-dock ?wp)
				(at ?r ?wp)
				(carry ?r ?s)
				(> (battery-amount ?r) 2))					 		   
		:effect (and 
				(is-in ?s ?wp) 
				(not (carry ?r ?s))
				(stored-sample ?s)
				(decrease (battery-amount ?r) 2)
				)
	)
	
	(:action recharge
		:parameters (?r - rover ?wp - waypoint)
		:precondition (and
				(at ?r ?wp)
				(is-recharging-dock ?wp) 
				(< (battery-amount ?r) 20)
				)
		:effect (and 
				(increase (battery-amount ?r) (- (battery-capacity) (battery-amount ?r)) )
				)
	)
)
