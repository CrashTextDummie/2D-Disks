	SUBROUTINE Check_overlap(n,icoll,x,r,eps,warning_3_drops_merging,
     &													flag_merging)

!	   flag_merging = +1: merging between droplets M and R
!					   0: NO merging
!					  -1: merging between droplets M and L				  

!	This subroutine is used to check if the new nucleated droplets are overlapping to 
!	 the existing ones 

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	


	IF (icoll.NE.0) THEN

	  DO i = 2,n 

			
 		 CALL Check_overlap_neighbours(x(i-1),x(i),x(i+1),r(i-1),r(i),
     &				  r(i+1),eps(i-1),eps(i),eps(i+1),flag_merging(i),
     &				  warning_3_drops_merging)


			!ERROR MESSAGES
 	      IF ( (flag_merging(i).EQ.1).AND.(i.NE.icoll) ) THEN 

			 WRITE(*,*)		
			 WRITE(*,*) 'Error at t = ',t,'. Overlapping between drops 
     &(',i,') and (',i+1,') while icoll = ',icoll
			 WRITE(*,*)		

		  ELSEIF ( (flag_merging(i).EQ.-1).AND.(i.NE.icoll+1) ) THEN 

			 WRITE(*,*)		
			 WRITE(*,*) 'Error at t = ',t,'. Overlapping between drops 
     &		     (',i,') and (',i-1,') while icoll = ',icoll
			 WRITE(*,*)		

		  ELSEIF ( (flag_merging(i).NE.1).AND. (i.EQ.icoll) ) THEN
			 
			 WRITE(*,*)		
			 WRITE(*,*) 'Error at t = ',t,'. No overlapping between dro
     &ps (',i,') and (',i+1,') while icoll = ',icoll			
			 WRITE(*,*)		


	   END IF 		


	  END DO

	END IF

	END SUBROUTINE 