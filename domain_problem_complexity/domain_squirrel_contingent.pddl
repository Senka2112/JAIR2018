(define (domain squirrel_blocks_contingent)

(:requirements :strips :typing)

(:types
	waypoint
	robot
	object
	box
)

(:predicates
	(explored ?wp - waypoint)
	(robot_at ?v - robot ?wp - waypoint)
	(object_at ?o - object ?wp - waypoint)
	(box_at ?b - box ?wp - waypoint)
	(connected ?from ?to - waypoint)

	(gripper_empty ?r - robot)
	(holding ?r - robot ?o - object)

	(on ?o1 ?o2 - object)
	(clear ?o - object)

	(tidy ?o - object)
	(tidy_location_unknown ?o - object)
	(push_location ?o - object ?wp -waypoint)
	(tidy_location ?o - object ?wp -waypoint)

	(inside ?o - object ?b - box)

	(can_pickup ?v - robot ?o - object)
	(can_push ?v - robot ?o - object)

	(can_fit_inside ?o - object ?b - box)
	(can_stack_on ?o1 ?o2 - object)
)

;;observation acions
(:action observe_pickup
	:parameters (?v - robot ?wp - waypoint ?o1 - object)
	:condition (and
		(robot_at ?v ?wp)
		(object_at ?o1 ?wp))
	:observe((can_pickup ?v ?o1))
)

(:action observe_push
	:parameters (?v - robot ?wp - waypoint ?o1 - object)
	:condition (and
		(robot_at ?v ?wp)
		(object_at ?o1 ?wp))
	:observe((can_push ?v ?o1))
)

(:action observe_put_in_box
	:parameters (?v - robot ?wp - waypoint ?o1 - object ?b - box)
	:condition (and
		(robot_at ?v ?wp)
		(object_at ?o1 ?wp)
		(box_at ?b ?wp))
	:observe((can_fit_inside ?o1 ?b))
)

(:action observe_stack_object
	:parameters (?v - robot ?wp - waypoint ?o1 ?o2 - object)
	:condition (and
		(robot_at ?v ?wp)
		(object_at ?o2 ?wp)
		(clear ?o2)
		(holding ?v ?o1)
		)
	:observe((can_stack_on ?o1 ?o2))
)

;; Put object in a box
(:action put_object_in_box
	:parameters (?v - robot ?wp - waypoint ?o1 - object ?b - box)
	:condition (and
		(robot_at ?v ?wp)
		(box_at ?v ?wp)
		(holding ?v ?o1)
		(can_fit_inside ?o1 ?b)
)
	:effect (and
		(not (holding ?v ?o1))
		(gripper_empty ?v)
		(inside ?o1 ?b))
)


;; Unstack object
(:action unstack_object
	:parameters (?v - robot ?wp - waypoint ?o2 ?o1 - object)
	:condition (and
		(robot_at ?v ?wp)
		(object_at ?o1 ?wp)
		(on ?o2 ?o1)
		(gripper_empty ?v)
		(can_pickup ?v ?o2))
	:effect (and
		(not (gripper_empty ?v))
		(not (on ?o2 ?o1))
		(not (object_at ?o2 ?wp))
		(clear ?o1)
		(holding ?v ?o2))
)


;; Stack object
(:action stack_object
	:parameters (?v - robot ?wp - waypoint ?o1 ?o2 - object)
	:condition (and
		(robot_at ?v ?wp)
		(object_at ?o2 ?wp)
		(clear ?o2)
		(holding ?v ?o1)
		(can_stack_on ?o1 ?o2)
		)
	:effect (and
		(not (clear ?o2))
		(not (holding ?v ?o1))
		(gripper_empty ?v)
		(object_at ?o1 ?wp)
		(on ?o1 ?o2))
)


;; Pick-up object
(:action pickup_object
	:parameters (?v - robot ?wp - waypoint ?o - object)
	:condition (and
		(robot_at ?v ?wp)
		(clear ?o)
		(object_at ?o ?wp)
		(gripper_empty ?v)
		(can_pickup ?v ?o))
	:effect (and
		(not (gripper_empty ?v))
		(not (object_at ?o ?wp))
		(holding ?v ?o))
)


;; Put-down object
(:action putdown_object
	:parameters (?v - robot ?wp - waypoint ?o - object)
	:condition (and
		(robot_at ?v ?wp)
		(holding ?v ?o))
	:effect (and
		(not (holding ?v ?o))
		(gripper_empty ?v)
		(object_at ?o ?wp))
)


;; Use perception actions to search for objects at the current waypoint
(:action explore_waypoint
	:parameters (?v - robot ?wp - waypoint)
	:condition (and
		(robot_at ?v ?wp))
	:effect (and
		(explored ?wp))
)


;; Move between any two waypoints, avoiding terrain
(:action goto_waypoint
	:parameters (?v - robot ?from ?to - waypoint)
	:condition (and
		(robot_at ?v ?from))
	:effect (and
		(not (robot_at ?v ?from))
		(robot_at ?v ?to))
)


;; Push an object between two waypoints in an unobstructed straight line
(:action push_object
	:parameters (?v - robot ?ob - object ?from ?to ?obw - waypoint)
	:condition (and
		(robot_at ?v ?from)
		(object_at ?ob ?obw)
		(push_location ?ob ?from)
		(can_push ?v ?ob))
	:effect (and
		(not (robot_at ?v ?from))
		(not (object_at ?ob ?obw))
		(robot_at ?v ?to)
		(object_at ?ob ?to))
)


;; Tidy a classified object at its goal location
(:action tidy_object
	:parameters (?v - robot ?o - object ?wp - waypoint)
	:condition (and
		(robot_at ?v ?wp)
		(object_at ?o ?wp)
		(tidy_location ?o ?wp))
	:effect (and
		(tidy ?o))
)
)
