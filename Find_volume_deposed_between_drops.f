	SUBROUTINE Find_volume_deposed_between_drops
     &					 (n,warning_3_drops_merging,n_drop_per_bridge,
     &		 			  dtcoll,x,r,phi,phi_b,Vb_old,Vb,Vb_drop,
     &					  flag_too_small)
     						!(n,warning_3_drops_merging,n_drop_per_bridge,
     						! dtcoll,x_old,r_old,phi,phi_b,Vb_old,Vb,Vb_drop,
     						! flag_too_small)
   
	!Find how much water volume is deposited on the bridges between the droplets 

	! HP: The bridges remains cylindrical during dtcoll and their diameter 
	!      do not change because they istantaneously diffuse towards the droplets
	!      Therefore the dT/dr can be considered constant over time 
	!      NB: Check analitically in the moving reference with w=z/length_bridge(t) !!
	! Strictly speaking this hypothesis is ok only when the bridge remains cylindrical 
	! but not when it starts to nucleate a droplet (the instability grows)

	USE DFPORT

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	

	REAL(8)::x1,x2,r1,r2,phi1,phi2
	REAL(8)::r_drop_main,eps_drop_main
	REAL(8)::Vb_random,Vb_left
	REAL(8)::Vb_drop_main,Vb_drop_random
	REAL(8)::INTERACT_RANGE
	INTEGER::nb,jL_bridge

	!Find water volume depositing on the moving bridge connecting 2 droplets: i and (i+1)
	! during the time dtcoll


	!Vb       = volume of bridge
	!Vb_old   = volume of bridge before merging
	!phi_b    = flux perpendicular to the wire per unit area = volume / (lenght*t) in the bridge between drop (i) and (i+1)
	!x1       = position of the centre of drop (i)
	!x2		  = position of the centre of drop (i+1)
	!r1		  = radius of drop (i)
	!r2       = radius of drop (i+1)
	!phi1     = flux on drop (i)=   volume/(length * t)
	!phi2     = flux on drop (i+1)	

	DO i = 1,isize
	  Vb(i)      = 0.d0
	  Vb_drop(i) = 0.d0
	  flag_too_small(i) = 0
	END DO 


	j = 0	

	DO i=1,n
	
		x1 = x(i)
		x2 = x(i+1)
		r1 = r(i)
		r2 = r(i+1)
		phi1 = phi(i) 	
		phi2 = phi(i+1)
		nb = n_drop_per_bridge(i)

	   !Volume deposited in total on each bridge
	    Vb(i) = Vb_old(i) + 
     &	        phi_b(i)* ( B_adim*dtcoll*(x2 - x1) - 2.d0/3.d0*pi_gr* 
     &	        ( ((B_adim*phi1*dtcoll/pi_gr + r1**2.d0)**(3.d0/2.d0) - 
     &  		        r1**3.d0) / phi1 + 
     &	          ((B_adim*phi2*dtcoll/pi_gr + r2**2.d0)**(3.d0/2.d0) - 
     &			    r2**3.d0) / phi2  )  )   
		

	  !Volume of each nucleating droplet (I store this information in a global vector)	  
	   IF (nb.EQ.0. OR. nb.EQ.1) THEN 

		   j = j + 1	
	       Vb_drop(j) = Vb(i) 

		   !Check if the new drop is too small (compared to the radius of the wire) 
		   !	  to be considered spherical and set a flag if it is
		   IF (nb.EQ.1) THEN

		   		 r_drop_main = (3.d0/(4.d0*pi_gr)*Vb_drop(j))**(1.d0/3.d0)
				 IF (r_drop_main.LT.r_drop_MIN) THEN
					flag_too_small(i) = 1
				 END IF
		   
		   END IF 	
			
		ELSE


		   IF (flag_merging_2by2.EQ.1) THEN       !DROPLETS CAN MERGE ONLY 2 BY 2	
	      !-----------------------------------------------------------------------------------
		     Vb_random = percentage_Vb_random * Vb(i)   !Tot Volume to redistribute non-uniformly among 
													    !the droplets nucleated on bridge (i)
			 Vb_drop_main = (Vb(i) - Vb_random)/nb    !Amount of the water from the bridge, equal for
													  !all the droplets nucleated on the bridge
		     Vb_left = Vb_random       !Inizialization; Vb_left = quantity used to be sure that I know 
									   !                          how much volume is randomly distributed
                                         !                          (left = remaining)
		     jL_bridge = j     !Save index of the first droplet at the left of the bridge in the vector
							   !  of the volumes of the nucleated droplets 
							   ! (Note: in this vector I include also the droplets that will be reabsorbed)
			
		   !=======================================================================	
		   !							 CHECKS
		   !=======================================================================
		   !If the droplets in the necklace overlap 
		   !   NB: I overestimate the radius of the single droplet a bit, 
		   !	   to avoid repeating this check for all the droplets in the necklace) 
		    r_drop_main = (3.d0/(4.d0*pi_gr)*Vb_drop_main)**(1.d0/3.d0)
		    eps_drop_main = INTERACT_RANGE(r_drop_main)

			IF (r_drop_main.LT.r_drop_MIN) THEN 
					flag_too_small(i) = 1

			!If the droplets are too big and overlap with each other in the necklace
			!  NB: If the droplets are too small it doesn't make sense to check this, 
			!      because they are not spherical!	
			ELSEIF (r_drop_main + eps_drop_main.GE.lambda0/2.d0) THEN  			
					warning_3_drops_merging = 1

		    END IF 
		   !========================================================================
	
			IF (flag_too_small(i).NE.1) THEN  !Droplets can nucleate as spherical

		        DO k = 1,nb			
  				   j = j + 1
				   Vb_drop_random = DRAND(0) * Vb_random/nb  ! I add some randomness to the volume of the new droplets
			       Vb_left    = Vb_left - Vb_drop_random     ! 'left' = remaining
				   Vb_drop(j) = Vb_drop_main + Vb_drop_random 
		         END DO 

		         j = jL_bridge
 		         DO k = 1,nb				
			        j = j + 1
			        Vb_drop(j) = Vb_drop(j) + Vb_left/nb
		         END DO 


			ELSE  !I have no droplet chain nucleating, only a volume of water depositing in the bridge

			   j = j + 1			
			   Vb_drop(j) = Vb(i) 

			END IF 



		  ELSE  !THE DROPLETS CAN MERGE ALSO IN LARGER GROUPS
			     !  The total volume is divided in equal fractions
		  !--------------------------------------------------------------------------------------
			   Vb_drop_main  = Vb(i)/nb

			   r_drop_main = (3.d0/(4.d0*pi_gr)*Vb_drop_main)**(1.d0/3.d0)

			   IF (r_drop_main.LT.r_drop_MIN) THEN

					flag_too_small(i) = 1
					j = j + 1
					Vb_drop(j) = Vb(i)

											  ELSE
					DO k = 1,nb 
						 j = j + 1
						 Vb_drop(j) = Vb_drop_main
					END DO

			   END IF



		   END IF 
	  

	  END IF 
	 

	END DO



	END SUBROUTINE 