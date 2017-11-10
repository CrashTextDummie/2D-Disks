	SUBROUTINE Conditions_for_nucleation
     &			            (n,x,r,eps,lb,n_new_drop,flag_nucleation,
     &			              n_drop_per_bridge,x_nucleation)

	 ! lb(i)              = length of cylindrical bridge between drop (i) and (i+1)
	 ! flag_nucleation(i) = 1: there can be nucleation between droplet (i) and (i+1)
	 !						0: there cannot
	 ! x_nucleation(i)    = location where the instability start to grow and the droplet is formed (random), inside bridge
	 ! n_newdrops         = number of new nucleated droplets

	USE DFPORT

	IMPLICIT NONE


	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	

	
	n_new_drop = 0
	i_new = 0					   !Counter of the vector of the new droplets
	DO i = 1,isize
	    flag_nucleation(i)   = 10
		n_drop_per_bridge(i) = -1
		x_nucleation(i)      = 0.d0
		x_nucl_1st_drop(i)   = 0.d0 
	END DO
	

	!Check condition for instability of the cyclindrical water bridge between two droplets

	DO i =1,n

 	  IF (lb(i).GE. lambda0) THEN    !NUCLEATION NEW DROPLET(S)

		  !Flag that tells me if there is nucleation of new droplets
	 	  flag_nucleation(i) = 1

		  !I can nucleate only one droplet in each bridge	
		  IF (flag_nucl_one_drop.EQ.1) THEN	 
  		 !---------------------------------------------------------------------------------
			 n_drop_per_bridge(i) = 1
			 x_nucleation(i) = x(i) + r(i) + eps(i) + DRAND(0)*lb(i)

									   ELSE	  
		  !I can nucleate a necklace of droplets in each bridge
		  !---------------------------------------------------------------------------------
			  n_drop_per_bridge(i) = FLOOR(lb(i)/lambda0)  !Number of droplets in the necklace on bridge(i)
			
			 !Position of the first droplet nucleated on the bridge	
			  x_nucl_1st_drop(i) = x(i) + r(i) + eps(i) + 
     &							    MOD(lb(i),lambda0)/2.d0 + 
     &							    DRAND(0)*lambda0

			  DO j = 1, n_drop_per_bridge(i)   
  				 i_new = i_new + 1
				 x_nucleation(i_new) = x_nucl_1st_drop(i)   
     &				                       + (j-1)*lambda0	
			  END DO

		   !---------------------------------------------------------------------------------
		   END IF 

		  !Number of new nucleated droplets
		  n_new_drop = n_new_drop + n_drop_per_bridge(i)



							   ELSE     !NO NUCLEATION OF NEW DROPLET(S)	
		flag_nucleation(i) = 0 
		n_drop_per_bridge(i) = 0

 	  END IF 

	END DO

	

	END SUBROUTINE 