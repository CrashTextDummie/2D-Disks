	SUBROUTINE Set_periodic_BC(n,x,r,eps,phi,phi_b,age)

	!Set a 'ghost' droplet (n+1), equal to the first one

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'


	x(n+1)   = x(1) + l_wire
	r(n+1)   = r(1)
	eps(n+1) = eps(1)
	phi(n+1) = phi(1)

	phi_b(n+1) = phi_b(1)   !This is not needed: it's the flux between DROP(2) and DROP(1)

	age(n+1) = age(1)


	END SUBROUTINE