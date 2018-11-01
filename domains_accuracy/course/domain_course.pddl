(define (domain course)
	(:requirements :strips :typing :fluents :disjunctive-preconditions :durative-actions)

	(:types
		student
		top_student med_student - student
		course
		program
	)

	(:predicates

		(passed ?s - student ?c - course)
		(not_passed ?s - student ?c - course)
		(not_taking ?s - student ?c - course)

		(prerequisite ?c1 ?c2 - course)
		(in_program ?c - course  ?p - program)

		(completed ?s - student ?p - program)
		(can-take ?s - student ?c - course)
	)

	(:functions
		(course-count ?p - program)
		(courses-completed ?s - student ?p - program)
	)


	;; take-course
	(:durative-action take_course
		:parameters (?s - student ?c1 ?c2 - course ?p - program)
		:duration ( = ?duration 10)
		:condition (and
			(at start (passed ?s ?c1))
			(at start (not_passed ?s ?c2))
			(at start (not_taking ?s ?c2))
			(at start (in_program ?c2 ?p))
			(at start (prerequisite ?c1 ?c2))
			(at start (can-take ?s ?c2))
			)
		:effect (and
			(at start (not (not_taking ?s ?c2)))
			(at end (not_taking ?s ?c2))
			(at end (not (not_passed ?s ?c2)))
			(at end (passed ?s ?c2))
			(at end (increase (courses-completed ?s ?p) 1))
			)
	)

	;; complete-program
	(:durative-action complete_program
		:parameters (?s - student ?p - program)
		:duration ( = ?duration 1)
		:condition (and
			(at start (>= (courses-completed ?s ?p) (course-count ?p)))
			)
		:effect (and
			(at end (completed ?s ?p))
			)
	)

)
