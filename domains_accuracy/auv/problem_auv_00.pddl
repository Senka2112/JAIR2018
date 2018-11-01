(define (problem valve_turning-task)

(:domain pandora_valve_turning)

(:objects
	auv - vehicle
	p1 - panel
	v1 - valve
	w0 w1 - waypoint
)

(:init

	(connected w0 w1) (= (distance w0 w1) 2)
	(connected w1 w0) (= (distance w1 w0) 2)
	(at auv w0)
	
	(on v1 p1)
	(valve_free v1)
	
	(= (valve_goal v1) 0)
	(= (valve_state v1) 0)
	(= (valve_goal_completed v1) 0)
	
	;; time window 1 [400--500: 45]
	(at 2 (= (valve_goal v1) 45))
	(at 400 (valve_blocked v1))
	(at 400 (not (valve_free v1)))
	
	(at 500 (not (valve_blocked v1)))
	(at 501 (valve_free v1))
	(at 502 (= (valve_goal v1) 135))
	
	;; time window 2 [700--1300: 135]
	(at 701 (valve_blocked v1))
	(at 702 (not (valve_free v1)))
	
	(at 1300 (not (valve_blocked v1)))
	(at 1301 (valve_free v1))

	(can-reach w1 p1)
	(can-turn auv v1)
	(can-hover w0 w1)
	(can-hover w1 w0)
)

(:goal (and
	(>= (valve_goal_completed v1) 2)
)))
