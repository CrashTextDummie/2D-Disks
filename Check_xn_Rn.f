	SUBROUTINE  Check_xn_Rn (n,x,r,eps,error,ierr)

	!I check the position and the radius of the last drop. 

	! If  x(n) >  l_wire:                                ERROR! In how I enforce periodic boundary conditions
	! If (x(1)+l_wire-R(1)) - (x(n)+R(n)) < eps(n) + eps(1) : ERROR!There is a merging that I am neglecting  


	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	


	!	*******************************************************************************************


!	Check if the position of the centre of the last droplet overexceed l_wire
	IF (x(n).GT.l_wire) THEN 

		error=3
		ierr=n

	END IF 



!	Check if there was merging between the last drop and the first one that I am neglecting
	x(n+1)   = x(1) + l_wire
	r(n+1)   = r(1)
	eps(n+1) = eps(1)

	IF ( x(n+1) - x(n) - r(n+1) - r(n) .LE. eps(n) + eps(n+1)) THEN
	
		error=4
		ierr=n

	END IF  



	END SUBROUTINE 