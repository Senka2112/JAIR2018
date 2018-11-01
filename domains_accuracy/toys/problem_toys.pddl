(define (problem toys_task)
(:domain toys)
(:objects
    block0 block1 - block
    box0 - box
    car0 car1 - car
    cup0 cup1 - cup
    kenny - robot
    wp0 wp1 wp2 - waypoint
)
(:init
    (can_fit_inside car0 box0)
    (can_fit_inside car1 box0)
    (can_fit_inside cup0 box0)
    (can_fit_inside cup1 box0)
    (can_fit_inside block0 box0)
    (can_fit_inside block1 box0)

    (can_pickup kenny cup0)
    (can_pickup kenny cup1)
    (can_pickup kenny block0)
    (can_pickup kenny block1)
    (can_pickup kenny car0)
    (can_pickup kenny car1)

    (can_push kenny cup0)
    (can_push kenny cup1)
    (can_push kenny block0)
    (can_push kenny block1)

    (can_stack_on cup0 block0)
    (can_stack_on cup1 block0)
    (can_stack_on block0 block0)
    (can_stack_on block1 block0)
    (can_stack_on cup0 block1)
    (can_stack_on cup1 block1)
    (can_stack_on block0 block1)
    (can_stack_on block1 block1)

	(robot_at kenny wp0)
	(box_at box0 wp1)
)
(:goal (and
	(robot_at kenny wp1)
)
))
