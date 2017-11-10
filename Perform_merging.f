	SUBROUTINE Perform_merging(n_old,x_old,r_old,eps_old,Vb_res_old,
     &					       age_old,flag_merging_old,i_merging_old,
     &						   i_from_merging,n,x,r,Vb_res,age)

!	This subroutine is used to check if the droplets are overlapping, 
!	after having considered the water from the bridges. If they are, I merge them 
!	 (not necessarily 2 by 2: it can be also by 3 or 4).

	    

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	

	INTEGER:: ii,kk
	INTEGER:: nL_BC,nR_BC        !N droplets merging with drop)n) on the left and on the right
	INTEGER:: i_BC,n_BC			 !i_BC = Index to scan the additional drops to enforce periodic BC
	INTEGER::n_dum,n_merged
	INTEGER::age_new_drop,age_merged_tot
	INTEGER,DIMENSION(isize)::age_dum
	INTEGER,DIMENSION(isize)::i_merging_old,i_from_merging

	REAL(8)::numerat_xmerged,Vdrop,Vmerged_tot,Vbridge
	REAL(8)::x_new_drop,r_new_drop  !Dummy variables created in order to verify if the
								    !   new drop is inside the limits (0-l_length)
	REAL(8)::Vb_res_new_drop  !Dummy variable containing the residual volume in the bridge 
							  ! located AFTER the new droplet from the merging

	REAL(8),DIMENSION(isize)::x_dum,r_dum,Vb_res_dum   !Dummy vectors created to enforce periodic BC
	!************************************************************************************************

	!Initialize the value of n
	n = n_old 

	!Initialization
	DO i = 1,isize
		
		x_dum(i) = 0.d0
		r_dum(i) = 0.d0
		flag_merging_dum(i)   = 0	
		age_dum(i) = -1

		x(i) = 0.d0
		r(i) = 0.d0
		eps(i) = 0.d0
		flag_merging(i) = 0

	    i_from_merging(i) = 0

	END DO



	!Periodic BOUNDARY CONDITIONS
	!*********************************************************************
	!Check how many drops merge with drop (n) at its LEFT
	!------------------------------------------------------
	nL_BC = 0	   !N of drops merging with drop (n) at its LEFT 
	i_BC  = n - 1

	DO WHILE (flag_merging_old(i_BC).EQ.1)	  
	    nL_BC = nL_BC + 1     !Update the N of drops merging on the left
	    i_BC  =  i_BC - 1
 	END DO


	!Check how many drops merge with drop (n) at its RIGHT
	!-------------------------------------------------------
	nR_BC = 0    !N of drops merging with drop (n) at its RIGHT
				 !  if I consider periodic boundary conditions
	i_BC = 0

	IF (flag_merging_old(n).EQ.1) THEN    
		
		 i_BC  = 1
		 nR_BC = 1		

	     DO WHILE (flag_merging_old(i_BC).EQ.1)	  
		   nR_BC = nR_BC + 1 	  !Update the N of drops merging on the right     
		   i_BC  = i_BC  + 1     
		 END DO

	END IF 




	!I create dummy vectors for x and r to enforce periodic
	! boundary condition
	!--------------------------------------------------------------
	 j = 1   !Index of the dummy vectors x and r (with the additional drops at 
			 !the beginning and at the end, to enforce periodic boundary cond.

	!Additional drops in the beginning (before x=0)		
	IF (nR_BC.NE.0) THEN   ! I add some drops at the beginning of the wire
		 	
	 DO i = (n - nL_BC),n		
	    x_dum(j) = x_old(i)  - l_wire   !x<0
	    r_dum(j) = r_old(i)  
		Vb_res_dum(j)         = Vb_res_old(i) !Residual volume in the bridge
	    flag_merging_dum(j)   = flag_merging_old(i)
		age_dum(j)			  = age_old(i)

		j = j + 1
	 END DO

	END IF 

	!Drops of the original vector
	 DO i = 1,n 
		x_dum(j)      = x_old(i)
		r_dum(j)      = r_old(i)
		Vb_res_dum(j) = Vb_res_old(i) 
		flag_merging_dum(j)   = flag_merging_old(i)
		age_dum(j)			  = age_old(i)

		j = j + 1		
	 END DO


	!Additional drops at the end (after x=l_wire)
 	 DO i = 1, nR_BC
		 x_dum(j)      = x_old(i) + l_wire	 
		 r_dum(j)      = r_old(i)
		 Vb_res_dum(j) = Vb_res_old(i) 
		 flag_merging_dum(j) = flag_merging_old(i)
	     age_dum(j)			 = age_old(i)

		 j = j + 1				 	
	 END DO 

	n_dum = j - 1    !n_dum = N of droplets in the dum vector
				



	!MERGING OF OVERLAPPING DROPLETS
	!**************************************************************************
	!Inizialization of the total volume of the merged droplets (2 by 2 or,by 3,etc)
	  Vmerged_tot = 0.d0
	  	
	  i  = nR_BC + 1	!nR_BC = Number of droplets merging with the last one (n) 
						!	            for periodic boundary conditions
	  ii = 1			!ii    = Index of the new droplets vector	
	  j = 1 		    !j     = Index to scan the vector of the old (overlapping) droplets
	
	  IF (nR_BC.NE.0) THEN 
		  n = n_dum - 1      !Initialization of the number of droplets 
	  END IF 
		
	!Initialization of counter of the vector of the indexes of the 
	! droplets resulting from merging
	  kk =0


	DO WHILE (j.LE.n_dum)  

	  !NO MERGING
	  !----------------------------------------------------------------------
	   IF (flag_merging_dum(j).EQ.0) THEN    
	
		  x_new_drop      = x_dum(j)
		  r_new_drop      = r_dum(j)
		  Vb_res_new_drop = Vb_res_dum(j)
		  age_new_drop    = age_dum(j)

		 !*********************************************************
	     !Check if the droplets are inside the wire or outside
	     !*********************************************************
	      IF ( (x_new_drop.GE.0.d0).AND.(x_new_drop.LE.l_wire) ) THEN

		     r(ii)      = r_new_drop
		     x(ii)      = x_new_drop
			 Vb_res(ii) = Vb_res_new_drop
			 age(ii)    = age_new_drop

		  !Index to scan the vector of the new droplets 
		  !(after merging)
		     ii = ii + 1  	
		  END IF
 	

	  !MERGING OF n_merged droplets		
	  !----------------------------------------------------------------------
							     	 ELSE							
		  !Initialization			
 		  n_merged    = 1                                    !Number of merging droplets	
		  Vdrop       = 4.d0/3.d0 * pi_gr * r_dum(j)**3.d0   !Volume of ONE drop
		  Vmerged_tot = Vdrop								 !Total volume in the merged drop
	      numerat_xmerged = x_dum(j)*Vdrop                   !Numerator to calculate x of the merged drop
		  Vbridge         = 0.d0                             !Residual water volume between the merging droplets                        
		  age_merged_tot  = age_dum(j)						 !Age of droplet = instant where it first appeared

 		  DO WHILE ( (flag_merging_dum(j).EQ.1).AND.(j.LE.n_dum) )    !NB:we can have more than two merging droplets

		      n_merged = n_merged + 1
			  
			!For the calculation of the RADIUS of the merged drops
			  Vbridge     = Vb_res_dum(j)
			  Vdrop       = 4.d0/3.d0 * pi_gr * r_dum(j+1)**3.d0	
			  Vmerged_tot = Vmerged_tot + Vdrop + Vbridge


			!For the calculation of the CENTRE of the merged drops (numerator) 
			!  xmerged = SUM(x_i*Vol_i) / SUM(Vol_i)   : centre of mass
			  numerat_xmerged  = numerat_xmerged + x_dum(j+1)*Vdrop
		
			!Age of the drop resulting from merging = age of the oldest
			  age_merged_tot = MIN(age_merged_tot,age_dum(j+1))


			j = j + 1		  
			
		   !Number of droplets, after merging
			n = n - 1  

	      END DO	

		   r_new_drop = (3.d0/(4.d0*pi_gr) * Vmerged_tot)**(1.d0/3.d0)
		   x_new_drop =  numerat_xmerged / Vmerged_tot			
		   Vb_res_new_drop = Vb_res_dum(j)
		   age_new_drop    = age_merged_tot

		  !*********************************************************
	      !Check if the droplets are inside the wire or outside
	      !*********************************************************
		   IF ( (x_new_drop.GE.0).AND.(x_new_drop.LE.l_wire) ) THEN

				r(ii)      = r_new_drop
				x(ii)      = x_new_drop
				Vb_res(ii) = Vb_res_new_drop 
				age(ii)    = age_new_drop

	  		    !I save the indexes (i) of the new droplets resulting 
		        !  from merging 
		         kk = kk + 1
 		         i_from_merging(kk) = ii
				
				!Index to scan the vector of the new droplets 
				!(after merging)
				 ii = ii + 1  	

		   END IF

	   END IF

	   j  = j  + 1  !Index to scan the vector of the old (overlapping) 
					!droplets
	END DO


 !**	   n = ii - 1	!CHECK
	

	!Check that the droplets do no overlap
	!****************************************************************
	CALL Calculate_interaction_ranges (n,r,eps)
	
	!Periodic BC 
	x(n+1)      = x(1) + l_wire
	r(n+1)      = r(1)
	eps(n+1)    = eps(1)
	Vb_res(n+1) = Vb_res(1)
	age(n+1)    = age(1)

	DO i = 1,n

		IF ( x(i+1)-x(i)-r(i+1)-r(i) .LE. eps(i)+eps(i+1)) THEN
		 										
			flag_merging(i) = 1   !Between drop (i) and (i+1)
	        WRITE(*,*) 'Error!Droplet (',i,') and (',i+1,') still 
     &overlapping at the end of Perform_merging.f at t = ',t
			STOP
														   ELSE						
			flag_merging(i) = 0				
		END IF 		

	END DO


	END SUBROUTINE 