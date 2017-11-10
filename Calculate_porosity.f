	SUBROUTINE  Calculate_porosity(n,r,porosity)

	!tot_covered_area  = area covered by the droplets on the wire
	!porosity          = area non-covered by the droplets on the wire

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'
	
	!*****************************************************
	
	tot_covered_area = 0.d0

	DO i = 1,n

		tot_covered_area = tot_covered_area + (2.d0*r(i))

	END DO



	porosity = l_wire - tot_covered_area
	

	END SUBROUTINE 