	PROGRAM Breath_figures

	! Declaration of variables
      
	IMPLICIT NONE

	INTEGER ::Allocatestatus,h,correggi			     !These are flagg
	INTEGER ::errore_dtcoll   !,esci,ciclo_correz    !Flag (+ a counter) related to correction cycle of dtcoll
	INTEGER ::n_max   
					  

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'
	INCLUDE 'Parameters_liquid.fi'



	!INPUT: generation of initial data 
	!*****************************************************
	!Generation of intial position and radius of the droplets
	n = n0                          !Initial number of droplets
	CALL Initial_conditions(n,x,r,eps,phi,phi_b,Vb,age)


	!Inizialization
	t=0
	j=0
	dtcoll=0
	icoll=0
	flagcoll=0
	error=0
	ierr=0

	x_old = x
	r_old = r
	eps_old = eps
	phi_old = phi
	phi_b_old = phi_b
	Vb_old = Vb
	age_old = age


!	 Calculate relevant quantity
!	*******************************************************
	  !Min and Max radius
	  CALL Calculate_rmin_rmax(n,r,r_min,r_max)

	  !Porosity
	  CALL Calculate_porosity(n,r,porosity)


!	OPEN FILES
!	*******************************************************
	CALL Open_files


	!Save initial simulation parameters
	h=20																		
	CALL Save_output(h,n,j,icoll,i_NewDrops,i_merging_AfterNucl,
     &			 	 i_AfterMerge,n_drop_per_bridge,x_NewDrops,
     &				 r_NewDrops,eps_NewDrops,x,r,eps,phi,phi_b,Vb,
     &				 r_min,r_max,porosity,age)
				   !(h,n,j,icoll,i_NewDrops,x_NewDrops,r_NewDrops,
				   ! eps_NewDrops,x,r,eps,phi,phi_b,Vb,r_min,r_max,porosity)

	!Save position and radii of the droplets at the beginning
	h = 10
	CALL Save_output(h,n,j,icoll,i_NewDrops,i_merging_AfterNucl,
     &			 	 i_AfterMerge,n_drop_per_bridge,x_NewDrops,
     &				 r_NewDrops,eps_NewDrops,x,r,eps,phi,phi_b,Vb,
     &				 r_min,r_max,porosity,age)


	!TIME LOOP: GROWTH & MERGING OF THE DROPLETS
	!*****************************************************
!**	DO WHILE (t.LT.time_tot)
		DO WHILE (j.LT.100)

		j=j+1

		WRITE (*,*) 'Begin cycle',j

		!Calculate the length of the protruding feet of each droplet: eps(i)
		CALL Calculate_interaction_ranges(n,r,eps)

		!Set a ghost droplet with index (n+1) in order to impose periodic 
          ! boundary conditions at the end/beginning of the wire
		CALL Set_periodic_BC(n,x,r,eps,phi,phi_b,age)


		!Calculate the length of the bridges between the droplets: lb(i)
		CALL Calculate_water_bridges(n,x,r,eps,lb)

		!Find possible nucleation sites for the new droplets
	    CALL Conditions_for_nucleation(n,x,r,eps,lb,n_new_drop,
     &				   flag_nucleation,n_drop_per_bridge,x_nucleation)

		!Find the smallest time interval (dt) before a merging event takes place
          !  (neglecting nucleation events between the droplets)
		CALL Find_dtcoll(n,x,r,eps,phi,dtcoll,icoll,flagcoll)
	 

	    !Reset the 'old' values 
		DO i = 1, n+1 
			x_old(i) = x(i)
			r_old(i) = r(i)
			eps_old(i) = eps(i)
	        Vb_old(i)  = Vb(i)   !hp:The water is staying in the bridges between the droplets
			age_old(i) = age(i)
		END DO
	
	 !==========================================================================
	 !LOOP TO VERIFY IF I HAVE THE RIGHT dtcoll
	 !==========================================================================
	   !Initialization 
		warning_3_drops_merging = -1   !Warning flag (if != 0 I have droplets merging 3 by 3). 
		warning_no_merging      = -1   !Warning flag (if != 0: no collisions take place when they should)
	    n_dtcoll_correct	    = 0    !N of times that I correct the dtcoll
      
          !Note: I set the warning flags = -1 because I want to force the first entrance
          ! inside the loop that controls the growth of the droplets     

	   DO WHILE ((n_dtcoll_correct.LE.n_dtcoll_correct_max .AND. 
     &									  warning_no_merging.NE.0) .OR.
     &			  warning_3_drops_merging.NE.0)	  		
!	   DO WHILE (warning_3_drops_merging.NE.0)
	  !==========================================================================
	    CALL Correct_dtcoll(warning_3_drops_merging,warning_no_merging,
     &					     icoll,dtcoll,n_dtcoll_correct)


		!I increase the size of the droplets, as an effect of the impinging water 
          ! flux (deposited vapour) during the time interval dtcoll 	
		CALL Grow_drops(n,dtcoll,phi,r_old,r)

		!Calculate the length of the protruding feet of each droplet: eps(i)
		CALL Calculate_interaction_ranges(n,r,eps)

		!Set a ghost droplet (n+1) in order to impose periodic boundary conditions
		CALL Set_periodic_BC(n,x,r,eps,phi,phi_b,age)


		!Check if I have overlapping where I should not have it	(if I didn't correct dtcoll yet)	
	    CALL Check_overlap(n,icoll,x,r,eps,warning_3_drops_merging,
     &										   		   flag_merging)

	    !***************************************************************************
	   	!If I already know that some chains have 3 overlapping droplets,
		!	 I skip the next calculations  ****
	    IF (warning_3_drops_merging.NE.1) THEN 
	    !***************************************************************************
	        !Find how much water volume is deposited on the bridges between the droplets
              ! during the time interval dtcoll (and recheck for mergings 3 by 3)
	        CALL Find_volume_deposed_between_drops
     &			      (n,warning_3_drops_merging,n_drop_per_bridge,
     &			       dtcoll,x_old,r_old,phi,phi_b,Vb_old,Vb,Vb_drop,
     &			       flag_too_small)
 
		    !***************************************************************************
			!If I already know that some chains have 3 overlapping droplets, 
			!	I skip the next calculations  ****
		    !***************************************************************************
	 	     IF (warning_3_drops_merging.NE.1) THEN 


			   !I create the vectors of the droplets after considering the reabsorbtion 
			   !of the water fallen in the bridges between the droplets and the  
			   !nucleation of new droplets
			   CALL Nucleation_new_droplets(j,n,icoll,flag_nucleation,
     &			      flag_too_small,n_drop_per_bridge,x_nucleation,
     &				  Vb,Vb_drop,x,r,eps,age,i_NewDrops,x_NewDrops,
     &				  r_NewDrops,eps_NewDrops,n_AfterNucl,x_AfterNucl,
     &				  r_AfterNucl,eps_AfterNucl,Vb_res_AfterNucl,
     &				  age_AfterNucl)



			   !Find which droplets are overlapping, after having considered the 
			   !  water from the bridges
			    CALL Find_merging(n_AfterNucl,x_AfterNucl,r_AfterNucl,
     &			            eps_AfterNucl,warning_3_drops_merging,
     &			            warning_no_merging,flag_merging_AfterNucl,
     &						i_merging_AfterNucl)
							!(n,x,r,eps,
							!warning_3_drops_merging,warning_no_merging,
							!flag_merging,i_merging)
		    !***************************************************************************
			 END IF 

	    !***************************************************************************
		 END IF 
	  				
	 END DO 
	

	  !Check if the droplets are overlapping, after having considered 
	  ! the water from the bridges. If they are, I merge them 
	  CALL Perform_merging(n_AfterNucl,x_AfterNucl,r_AfterNucl,
     &				     eps_AfterNucl,Vb_res_AfterNucl,age_AfterNucl,
     &				     flag_merging_AfterNucl,i_merging_AfterNucl,
     &				     i_AfterMerge,n_new,x_new,r_new,Vb_res_new,
     &					 age_new)
						 !(n_old,x_old,r_old,eps_old,Vb_res_old,age_old,
     						 ! flag_merging_old,i_merging_old,i_from_merging,
     						 ! n,x,r,Vb_res,age)



	  !CHECK DROPLET POSITION
	  !***********************************************************************************
		 !Calculate the length of the protruding feet of each droplet: eps(i)
		  CALL Calculate_interaction_ranges(n_new,r_new,eps_new)

	     !Check periodic boundary conditions on the last drop
		  CALL Check_xn_Rn(n_new,x_new,r_new,eps_new,error,ierr)   
  
	  !***********************************************************************************
	  !Calculate the new time instant 
	   t = t + dtcoll												

	
	  n = n_new

	  DO i = 1,n+1
		  x(i) = x_new(i)
		  r(i) = r_new(i)	
		  eps(i)     = eps_new(i) 
		  Vb(i)      = Vb_res_new(i)
	      Vb_res(i)  = 0.d0
		  age(i) = age_new(i)
	  END DO 
	
	  DO i = n+2,isize
		  x(i) = 0.d0
		  r(i) = 0.d0
	      eps(i) = 0.d0
		  Vb_res(i) = 0.d0
	      Vb(i)     = 0.d0
		  age(i) = -1
	  END DO 	




!	 Calculate relavant quantities
!	*******************************************************
	  !Min and Max radius
	  CALL Calculate_rmin_rmax(n,r,r_min,r_max)

	  !Porosity
	  CALL Calculate_porosity(n,r,porosity)



!	 OUTPUT
!	*******************************************************
!      Print screen          
	  CALL Print_output(j,icoll,flagcoll,error,ierr,
     &					warning_3_drops_merging,dtcoll,
     &					n_AfterNucl,x_AfterNucl,r_AfterNucl,
     &					n,x,r,eps,phi,phi_b)


	  IF (t.GE.t_save_min) THEN
		h=10	
          !Save on file
		CALL Save_output(h,n,j,icoll,i_NewDrops,i_merging_AfterNucl,
     &				   i_AfterMerge,n_drop_per_bridge,x_NewDrops,
     &				   r_NewDrops,eps_NewDrops,x,r,eps,phi,phi_b,Vb,
     &				   r_min,r_max,porosity,age)
        END IF 
	 !*********************************************************************************************************************	
	
	 !Save in the variables 'old' the values of x,r,etc related to the instant I just considered 
       ! At the next time instant (j+1), these will be the values at instant (j)
	  CALL Reset_old(n,x,r,eps,phi,phi_b,Vb,age,
     &		         n_old,x_old,r_old,eps_old,phi_old,phi_b_old,
     &				 Vb_old,age_old)


	END DO 


	CALL Close_files



	END PROGRAM


	!***********************************************************
	INCLUDE 'functions.fi'