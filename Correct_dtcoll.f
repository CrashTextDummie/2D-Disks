	SUBROUTINE  Correct_dtcoll(warning_3_drops_merging,
     &						   warning_no_merging,icoll, 
     &						   dtcoll,n_dtcoll_correct)

	!If I have error ( = merging of more than 2 neighbouring droplets), I reduce the time step 
	  

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	



	   !Check 3 droplets merging
	   IF (warning_3_drops_merging.EQ.1) THEN 
			
			dtcoll = dtcoll / 2.d0
	
			n_dtcoll_correct = n_dtcoll_correct + 1   !I update the counter that tells me the N of times I had to correct the time step

			icoll = 0								  !I expect no collisions taking place due to the mass deposited directly on the droplets, in dt_coll/2

			warning_3_drops_merging = 0

	   END IF 


	  !Check no merging
  	   IF (warning_no_merging.EQ.1) THEN 

			dtcoll = dtcoll + dtcoll/2.d0

   			n_dtcoll_correct = n_dtcoll_correct + 1   !I update the counter that tells me the N of times I had to correct the time step

			warning_no_merging = 0

	   END IF 



	END SUBROUTINE 