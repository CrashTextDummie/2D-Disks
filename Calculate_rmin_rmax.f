	SUBROUTINE  Calculate_rmin_rmax(n,r,r_min,r_max)

	!tot_covered_area  = area covered by the droplets on the wire
	!porosity          = area non-covered by the droplets on the wire

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'
	
	!*****************************************************
	

	 !Min and Max radius
	  r_min = MINVAL(r(1:n))
	  r_max = MAXVAL(r(1:n))

	
	 !Check
	  IF (r_min.LT.r_drop_MIN) THEN
		 WRITE (*,*) 'Error at t = ',t 
		 WRITE (*,*) ' Rmin is too small: Rmin     =',r_min
		 WRITE (*,*) '                    Rmin_LIM =',r_drop_MIN 
		 STOP
	  END IF

	END SUBROUTINE 