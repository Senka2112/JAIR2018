(define (problem course_task)
(:domain course)
(:objects
	s1 s2 - student
	c0 c1 c2 - course
	p1 - program
)
(:init
	(passed s1 c0)
	(passed s2 c0)

	(not_passed s1 c1)
	(not_passed s1 c2)
	(not_passed s2 c1)
	(not_passed s2 c2)
	
	(not_taking s1 c0)
	(not_taking s1 c1)
	(not_taking s1 c2)
	(not_taking s2 c0)
	(not_taking s2 c1)
	(not_taking s2 c2)

	(prerequisite c0 c1)
	(prerequisite c1 c2)

	(in_program c1 p1)
	(in_program c2 p1)

	(can-take s1 c1)
	(can-take s1 c2)
	(can-take s2 c1)
	(can-take s2 c2)

	(= (course-count p1) 2)
	(= (courses-completed s1 p1) 0)
	(= (courses-completed s2 p1) 0)
)
(:goal (and
		(completed s1 p1)
		(completed s2 p1)
		)
)
)
