(define (domain pandora)

(:requirements :strips :typing :fluents :disjunctive-preconditions :durative-actions :timed-initial-literals :duration-inequalities)

(:types
		waypoint
		inspectionpoint
		pillar
		panel
		valve
		chain
		vehicle
)

(:predicates

	(waypoint_not_occupied ?wp - waypoint)
	(connected ?wp1 ?wp2 - waypoint)

	(at ?v - vehicle ?wp - waypoint)
	(near ?v - vehicle ?wp - waypoint)
	(not_illuminating ?v - vehicle)

	(observed_pillar ?p - pillar)
	(pillar_illuminated ?p - pillar)

	(examined ?p - panel)
	(on ?a - valve ?p - panel)
	(valve_blocked ?a - valve)
	(valve_free ?a - valve)

	(chainat ?c - chain ?wp - waypoint)
	(chain_examined ?c - chain)

	(can-see ?wp - waypoint ?ip - inspectionpoint)	
	(can-see_pillar ?wp - waypoint ?p - pillar)	
	(can-examine ?wp - waypoint ?p - panel)
	(can-reach ?wp - waypoint ?p - panel)
	(can-turn ?v - vehicle ?a - valve)
	(can-hover ?wp1 ?wp2 - waypoint)
)

(:functions

		(arm_calibration ?auv - vehicle)

		(observed ?ip - inspectionpoint)
		(obs ?ip - inspectionpoint ?wp - waypoint)

		(distance ?wp1 ?wp2 - waypoint)

		(valve_goal ?va - valve)
		(valve_state ?va - valve)
		(valve_goal_completed ?va - valve)
)


(:durative-action do_hover_controlled
	:parameters (?v - vehicle ?from ?to - waypoint)
	:duration ( = ?duration (* (distance ?from ?to) 2))
	:condition (and
			(at start (at ?v ?from)) 
			(at start (connected ?from ?to))
			(at start (can-hover ?from ?to))
			)
	:effect (and 
			(at start (not (at ?v ?from)))
			(at end (at ?v ?to))
			)
)

(:durative-action correct_position
	:parameters (?v - vehicle ?target - waypoint)
	:duration ( = ?duration 10)
	:condition (at start (near ?v ?target))
	:effect (and (at start (not (near ?v ?target))) (at end (at ?v ?target)))
)

(:durative-action observe_inspection_point
	:parameters (?v - vehicle ?wp - waypoint ?ip - inspectionpoint)
	:duration ( = ?duration 10)
	:condition (and
				(at start (at ?v ?wp))
				(at start (can-see ?wp ?ip)))
	:effect (and 
				(at start (not (can-see ?wp ?ip)))
				(at start (not (at ?v ?wp)))
				(at end (increase (observed ?ip) (obs ?ip ?wp)))
				(at end (near ?v ?wp)))
)

(:durative-action illuminate_pillar
	:parameters (?v - vehicle ?wp - waypoint ?p - pillar)
	:duration ( = ?duration 50)
	:condition (and
				(at start (at ?v ?wp))
				(at start (can-see_pillar ?wp ?p)))
	:effect (and 				
				(at start (pillar_illuminated ?p))
				(at start (not (not_illuminating ?v)))
				(at start (not (at ?v ?wp)))
				(at end (not (pillar_illuminated ?p)))
				(at end (not_illuminating ?v))
				(at end (near ?v ?wp)))
)

(:durative-action observe_pillar
	:parameters (?v - vehicle ?wp - waypoint ?p - pillar)
	:duration ( = ?duration 10)
	:condition (and
				(at start (at ?v ?wp))
				(at start (can-see_pillar ?wp ?p))
				(at start (not_illuminating ?v))
				(over all (pillar_illuminated ?p)))
	:effect (and 
				(at start (not (can-see_pillar ?wp ?p)))
				(at start (not (at ?v ?wp)))
				(at end (observed_pillar ?p))
				(at end (near ?v ?wp)))
)

(:durative-action examine_panel
	:parameters (?v - vehicle ?wp - waypoint ?p - panel)
	:duration ( = ?duration 10)
	:condition (and
				(at start (at ?v ?wp))
				(at start (can-examine ?wp ?p)))
	:effect (and
				(at start (not (can-examine ?wp ?p)))
				(at end (examined ?p)))
)

(:durative-action turn_valve
	:parameters (?v - vehicle ?wp - waypoint ?p - panel ?a - valve)
	:duration ( = ?duration 10)
	:condition (and 
				(at start (at ?v ?wp))
;				(at start (examined ?p))
				(at start (can-reach ?wp ?p))
				(at start (can-turn ?v ?a))
				(at start (on ?a ?p))
				(at start (<= (arm_calibration ?v) 0))
				(at start (valve_free ?a)))
	:effect (and
				(at start (not (valve_free ?a)))
				(at end (assign (valve_state ?a) (valve_goal ?a)))
				(at start (not (at ?v ?wp)))
				(at end (near ?v ?wp))
				(at end (increase (valve_goal_completed ?a) 1))
				(at end (increase (arm_calibration ?v) 1))
				(at end (valve_blocked ?a)))
)

(:durative-action recalibrate_arm
	:parameters (?v - vehicle ?wp - waypoint)
	:duration ( = ?duration 60)
	:condition (and 
				(at start (>= (arm_calibration ?v) 1)))
	:effect (and
				(at end (assign (arm_calibration ?v) 0)))
)
)
