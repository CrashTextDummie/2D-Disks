	SUBROUTINE  Reset_old (n,x,r,eps,phi,phi_b,Vb,age,
     &			           n_old,x_old,r_old,eps_old,phi_old,phi_b_old,
     &					     Vb_old,age_old)

	!Save x,r,eps,phi at time integration instant (j) in order to use them 
	!at instant (j+1) 


	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	

!	***********************************************************************

	
	!Numebr of droplets
	n_old = n

	!Save x(i), r(i) at time instant (j)
	DO i=1,n
	
		x_old(i)   = x(i)
		
		r_old(i)   = r(i)

		eps_old(i) = eps(i)

		phi_old(i)   = phi(i)

	    phi_b_old(i) = phi_b(i)

		Vb_old(i) = Vb(i)         !Water left on the bridges

	    age_old(i) = age(i)

	END DO





	END SUBROUTINE 