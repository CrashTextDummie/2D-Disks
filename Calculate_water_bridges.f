	SUBROUTINE Calculate_water_bridges(n,x,r,eps,lb)

	!Calculate the length of the water bridges between the droplets
	! lb(i) = length of bridge between DROP(i) and DROP(i+1)


	IMPLICIT NONE 
	
	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'
	
	
	
	DO i =1,n

		lb(i) = x(i+1) - x(i) - r(i+1) - r(i) - eps(i+1) - eps(i)

	END DO


	
	END SUBROUTINE 
	 