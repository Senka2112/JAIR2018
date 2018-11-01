(define
(domain toys)

(:requirements :strips :typing :fluents :disjunctive-preconditions :durative-actions)

(:types
	object
	robot waypoint toy box - object
	block cup car - toy
)

(:predicates
	(robot_at ?v - robot ?wp - waypoint)
	(box_at ?b - box ?wp - waypoint)

	(can_fit_inside ?t - toy ?b - box)
	(can_stack_on ?t1 ?t2 - toy)
	(can_pickup ?r - robot ?t - toy)
	(can_push ?r - robot ?t - toy)
)

;; Move to any waypoint, avoiding terrain
(:durative-action goto_waypoint
	:parameters (?v - robot ?from ?to - waypoint)
	:duration ( = ?duration 10)
	:condition (and
		(at start (robot_at ?v ?from))
	)
	:effect (and
		(at end (robot_at ?v ?to))
		(at start (not (robot_at ?v ?from)))
	)
)

;; push an object
(:durative-action push_toy
	:parameters (?v - robot ?from ?to - waypoint ?t - toy)
	:duration ( = ?duration 10)
	:condition (and
		(at start (robot_at ?v ?from))
		(at start (can_push ?v ?t))
	)
	:effect (and
		(at end (robot_at ?v ?to))
		(at start (not (robot_at ?v ?from)))
	)
)

;; pickup a toy
(:durative-action pickup_toy
	:parameters (?v - robot ?wp - waypoint ?t - toy)
	:duration ( = ?duration 1)
	:condition (and
		(at start (robot_at ?v ?wp))
		(at start (can_pickup ?v ?t))
	)
	:effect (and
		(at end (robot_at ?v ?wp))
	)
)

;; stack a toy
(:durative-action stack_toy
	:parameters (?v - robot ?wp - waypoint ?t1 ?t2 - toy)
	:duration ( = ?duration 1)
	:condition (and
		(at start (robot_at ?v ?wp))
		(at start (can_stack_on ?t1 ?t2))
		(at start (can_pickup ?v ?t1))
	)
	:effect (and
		(at end (robot_at ?v ?wp))
	)
)

;; stack a toy
(:durative-action put_in_box
	:parameters (?v - robot ?wp - waypoint ?t1 - toy ?b - box)
	:duration ( = ?duration 1)
	:condition (and
		(at start (robot_at ?v ?wp))
		(at start (box_at ?b ?wp))
		(at start (can_fit_inside ?t1 ?b))
		(at start (can_pickup ?v ?t1))
	)
	:effect (and
		(at end (robot_at ?v ?wp))
	)
)

)
