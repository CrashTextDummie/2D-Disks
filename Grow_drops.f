
	SUBROUTINE  Grow_drops(n,delta_t,phi,r_old,r)

	!Find new dimension of the droplets, due to the water flux, in the time dtcoll, 
	! required for the first collision to take place
	!After this I have to check the overlapping and the merging
	

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	

	REAL(8)::delta_t



	DO i=1,n
	
!		r(i) = DSQRT( r_old(i)**2.d0 + 
!     &			      B_adim/pi_gr* phi(i)*delta_t)

          !growth law for disks instead of spheres
          r(i) = r_old(i)+ B_adim/pi_gr*phi(i)*delta_t
          
	END DO


	!Periodic boundary condition
	r(n+1) = r(1)


	END SUBROUTINE 