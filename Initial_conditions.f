	SUBROUTINE Initial_conditions (n,x,r,eps,phi,phi_b,Vb,age)
	
	! Assegna i valori iniziali in modo casuale, con doppia precisione

	! x = droplet position
	! R = droplet radius
	! phi = normal water flux at location x

	USE DFPORT

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	


	INTEGER ::flag
	REAL(8) ::dx


	dx   = l_wire/n		!Intervallo di equispaziatura che avrei se le particelle fossero ugualmente distribuite

	flag = 1      !(se flag=1,il generatore di numeri casuali prende il primo, se flag=0 va avanti)


	DO i = 1,n

		!Droplet position
		!x(i)= dx*(i-1) + DRAND(flag)*dx		
  	    x(i)= dx*(i-1)

		!flag=0
	
		!Droplet radius
!		r(i) = DRAND(flag)*r0				  !Initial radii are RANDOM, all positive
		r(i) = r0 * (1.d0 + DRAND(flag)*percentage_r0_random)	 
		flag = 0
	
		!Length of protruding "foot"
		IF (flag_const_interaction_range.EQ.1) THEN 
			eps(i) = eps0
		ELSE 
			eps(i) = percentage_eps * r(i)
	
		END IF

		!Water flux per unit length, normal to the wire, at location x(i)
		!phi(i)= 2.0*(0.5-DRAND(flag))*phi0	   !Initial fluxes are RANDOM, negative and positive
		phi(i) = phi0 

		!Water flux per unit length, normal to the wire, on the bridge(i), between DROP(i) and DROP(i+1)
		phi_b(i) = phi0 

		!Volume of the bridges betweent he droplets
		Vb(i) = 0.d0

		!Age of the droplets
		age(i) = 0

	END DO


	DO i = n+1 ,isize

		phi(i)   = phi0
		phi_b(i) = phi0

	END DO

	END SUBROUTINE 