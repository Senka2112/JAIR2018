(define (problem rover-single)
	(:domain rovers)
    
    (:objects
        waypoint1 waypoint2 waypoint3 waypoint4 waypoint5 waypoint6 
        waypoint7 waypoint8 waypoint9 waypoint10 waypoint11 waypoint12 - waypoint
        
        sample1 sample2 sample3 sample4 sample5 sample6 sample7 sample8 
        sample9 - sample
        
        rover1 - rover
    )
    
    (:init
        (= (battery-capacity) 1000)
        
        (can-move rover1 waypoint1)
        (can-move rover1 waypoint2)
        (can-move rover1 waypoint3)
        (can-move rover1 waypoint4)
        (can-move rover1 waypoint5)
        (can-move rover1 waypoint6)
        (can-move rover1 waypoint7)
        (can-move rover1 waypoint8)
        (can-move rover1 waypoint9)

        (can-sample-at rover1 waypoint1)
        (can-sample-at rover1 waypoint2)
        (can-sample-at rover1 waypoint3)
        (can-sample-at rover1 waypoint4)
        (can-sample-at rover1 waypoint5)
        (can-sample-at rover1 waypoint6)
        (can-sample-at rover1 waypoint7)
        (can-sample-at rover1 waypoint8)
        (can-sample-at rover1 waypoint9)

        (can-sample rover1 sample1)
		(can-sample rover1 sample2) 
        (can-sample rover1 sample3)
		(can-sample rover1 sample4)
        (can-sample rover1 sample5)
		(can-sample rover1 sample6)
        
        (is-in sample1 waypoint2)
		(is-in sample2 waypoint3) 
        (is-in sample3 waypoint9)
		(is-in sample4 waypoint8)
        (is-in sample5 waypoint3)
		(is-in sample6 waypoint3)   
        
        (is-recharging-dock waypoint1)
        (is-dropping-dock waypoint7)
        
        (at rover1 waypoint6)
        (= (battery-amount rover1) 400) 
    )
    
    (:goal
        (and 
            (stored-sample sample1)
            (stored-sample sample2)
            (stored-sample sample3)
            (stored-sample sample4)
            (stored-sample sample5)
            (stored-sample sample6)

            (at rover1 waypoint1))
    )
)
