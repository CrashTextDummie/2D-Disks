	SUBROUTINE Calculate_interaction_ranges (n,r,eps)
	
	! Calculate the length of the protruding feet of the droplets

	! x = droplet position
	! R = droplet radius
	! eps = protruding feet

	USE DFPORT

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	


	DO i=1,n

		!Length of protruding "foot"
		IF (flag_const_interaction_range.EQ.1) THEN 
			eps(i) = eps0
		ELSE 
			eps(i) = percentage_eps * r(i)
	
		END IF


	END DO


	END SUBROUTINE 