	SUBROUTINE Find_dtcoll (n,x,r,eps,phi,dtcoll,icoll,flagcoll)

	!Find MININUM time for the first merging 
	! (Hp: NO nucleation occurs,
	!      we neclect the ammount of water collected in the bridges between the droplets)

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	

	REAL(8):: a,beta, c, delta,Ds
	REAL(8):: x1,x2,r1,r2,phi1,phi2,phi_const, eps_coll    !dummy arguments
	REAL(8):: dt_1,dt_2


	!Initialization
	DO i = 1,isize 

		dt(i) = time_tot
		
	END DO



	!i = index for droplets
	!j = index for time instants
	!eps(i) = protruding "foot" of droplet (i)
	!dt(i)  = time to have collision between droplets: (i), (i+1)


	!We impose that mergings between two nearby droplets (i) and (i+1) occur and 
	!find the required time intervals dt(i)
	!NB: To consider the merging of droplet (1) and (n) (PERIODIC BOUNDARY CONDITIONS)
      !    we added a droplet (n+1) 

	DO i= 1,n    

			x1 = x(i)
			x2 = x(i+1)
			r1 = r(i)
			r2 = r(i+1)	
			phi1 = phi(i)
			phi2 = phi(i+1)
	
			eps_coll = eps(i) + eps(i+1)   != total distance where the droplets 
									       !  start to interact


		IF 	(flag_const_interaction_range.EQ.1) THEN 

			Ds = (x2- x1- eps_coll)**2.d0 - r2**2.d0 - r1**2.d0   
			
												ELSE										
			Ds = ( (x2- x1)/(percentage_eps + 1.d0) )**2.d0 - r2**2.d0 
     &													    - r1**2.d0   								    
		END IF 


	  !IF phi = const for all droplets
	  !--------------------------------------------------------------------------------------
	   IF (phi1.EQ.phi2) THEN 

			 phi_const = phi1

!			 dt(i)= A_adim * ( -4.d0*(r2*r1)**2.d0 + Ds**2.d0) / 
!    &		                 (r1**2.d0 + r2**2.d0 + Ds) / phi_const

              !collision time in case of disks
               dt(i)= A_dim * ((x2 - x1)/(percentage_eps + 1.d0)
     &						- r1 - r2) / phi_const

						  ELSE

	  !IF phi = different for different droplets
	  !---------------------------------------------------------------------------------------
	     !Solve 2nd order equation    
		
	     !Coefficients.
	  	   a    = ( (phi1 - phi2) / pi_gr)**2.d0

		   beta = - (phi1 *( Ds + 2.d0* r2**2.d0) + 
     &				 phi2 *( Ds + 2.d0* r1**2.d0)) / pi_gr

		   c    = Ds**2.d0 - 4.d0*(r1*r2)**2.d0 

		 !Determinant
		 delta = beta**2.d0 - a*c

		 !Check that determinant > 0
		 IF (delta.LT.0.d0) THEN
		   WRITE(*,*) 'Error in calculation of dtcoll(',i,') at t = ',
     &t
		   WRITE(*,*)
		   WRITE(*,*) 'Determinant = ', delta, ' <0 '
				STOP
		 ELSE 

				dt_1 = C_adim * (- beta - DSQRT(delta))/a
				dt_2 = C_adim * (- beta + DSQRT(delta))/a  

				IF (dt_1*dt_2 .LT. 0.d0)  THEN   !One is positive and the other is negative

				     dt(i) = DMAX1(dt_1,dt_2)    !The positive one is the one to be chosen


			    ELSEIF ((dt_1.LT.0.d0).AND.(dt_2.LT.0.d0)) THEN   !Both negative: the merging took place in the past

				     WRITE(*,*) 'Error!The merging of droplets (',i,') 
     &and the following one at t = ', t ,  ' took place in the past'
				     STOP

														   ELSE   !Both positive					
				     dt(i) = DMIN1(dt_1,dt_2)  												
				
				END IF 

		 END IF

	   END IF 

	END DO 




	!Find dt(i) MINIMUM , i.e. dt corrisponding to the first merging 

	dtcoll=	time_tot-t	  !Inizializzo ad un valore alto, che presumibilmente non si raggiunge mai tra una collisione e l'altra 		
	icoll = 0			  !Initialization
	flagcoll=0			  !***Forse dovrei inizializzare con dtcoll=tempotot-t  ad ogni iterazione temporale ----anche sotto nell'ultimo IF**


	DO  i=1,n
	
	 IF (dt(i).GT.0) THEN    !There is a merging	
		IF (dt(i).LE.dtcoll) THEN 
		
			dtcoll=dt(i)
			icoll=i  		!icoll = collisione in cui si ha il dt minimo. Il suo valore i indica che la collisione si ha tra la goccia i e (i-1)
			flagcoll=1		!flagcoll=1 --> a merging took place,     flagcoll=0--> there was NO merging 

		END IF	
	 END IF 

	END DO




	END SUBROUTINE 