	SUBROUTINE Find_merging(n,x,r,eps,
     &					   warning_3_drops_merging,warning_no_merging,
     &					   flag_merging,i_merging)

!	This subroutine is used to check which droplets are overlapping. 
!     If there are droplets merging 3 by 3 (or more), it sets a flag 
!	    (that will be used in 'Main' to reduce the timestep (dtcoll)

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	

	INTEGER:: ii,kk
	INTEGER,DIMENSION(isize)::i_merging



	!Initialization
	DO i = 1,isize
		
		flag_merging(i) = 0
		i_merging(i) = 0

	END DO



	!Check if, by adding the water of the bridges, some droplets have OVERLAPPED 
	! with the one on their RIGHT!
	! NB: If more than 2 droplets have overlapped, I consider the whole group as merged
	!*********************************************************************
	!Initialization of counter of the vector of the indexes of the 
	! droplets (i) merging (with (i+1))
	  kk =0

      !Periodic BOUNDARY CONDITIONS
	x(n+1) = x(1) + l_wire
	r(n+1) = r(1)
	eps(n+1) = eps(1)

	DO i = 1,n

		IF (x(i+1) - x(i) - r(i+1) - r(i) .LE. eps(i)+eps(i+1)) THEN
		 		
			   flag_merging(i) = 1   !Between drop (i) and (i+1)
		
			  !I save the index (i) in the vector of the indexes of 
			  !the merging droplets	
			   kk = kk + 1
 			   i_merging(kk) = i
																 ELSE						
			   flag_merging(i) = 0				

		END IF 	
	
	END DO

	flag_merging(n+1) = flag_merging(1)


	!CHECK IF I HAD DROPLETS MERGING MORE THAN 2 BY 2, OR I HAD NO MERGING AT ALL
	!*********************************************************************
	!Check for more than 2 droplets merging
	warning_3_drops_merging = 0    !Flag that tells me if I have merging of 
								   !   more than 2 neighbouring droplets 
	i = 1
	DO WHILE (i.LE.n .AND. warning_3_drops_merging.NE.1) 

		IF (flag_merging(i).EQ.1 .AND. flag_merging(i+1).EQ.1) THEN 

			    warning_3_drops_merging =  1
															   ELSE 
				i = i + 1			

		END IF

	END DO


      !Check for no merging
	warning_no_merging = 1		   !Flag that tells me that there were no droplets merging 
	i = 1
	DO WHILE (i.LE.n .AND. warning_no_merging.EQ.1) 

		IF (flag_merging(i).EQ.0) THEN 

				i = i + 1
								  ELSE 

				warning_no_merging = 0

		END IF 

	END DO


	IF ((warning_3_drops_merging.EQ.1).AND.
     &		(warning_no_merging.EQ.1))  THEN 
			WRITE(*,*)  'Error! 3 drops merging and no merging'
			STOP
	END IF 




	END SUBROUTINE 