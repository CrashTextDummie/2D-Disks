	SUBROUTINE  Check_overlap_neighbours(xL,xM,xR,rL,rM,rR,epsL,epsM,
     &						  epsR,flag_merge,warning_3_drops_merging)

!	   flag_merging = +1: merging between droplets M and R
!					   0: NO merging
!					  -1: merging between droplets M and L				  

!	This subroutine is used to check if the new nucleated droplets are overlapping to 
!	 the existing ones 

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	

	INTEGER::flag_merge

	REAL(8)::xL,xR,xM,rL,rM,rR
	REAL(8)::deltaL,deltaR,epsL,epsM,epsR





	!Check if the new droplet grows too much and it overlaps with one of the others
	!--------------------------------------------------------------------------------------
		  deltaL = xM - xL - rM - rL   !Overlapping with drop on the LEFT
		  deltaR = xR - xM - rR - rM   !Overlapping with drop on the RIGHT
	
			  			  	
	!Overlapping with both droplet (i) AND (i+1)   (NB: I am neglecting case with double merging)
	 IF (  ( deltaL .LT. epsL + epsM + TOL)   .AND.
     &	   ( deltaR .LT. epsM + epsR + TOL) ) THEN 

		   IF (flag_merging_2by2.EQ.1)   THEN    !Merging of 2 droplets

				   warning_3_drops_merging = 1	

			       IF (deltaL.GT.deltaR) THEN 				   		   
					      flag_merge = -1		   
										 ELSE 
					      flag_merge = 1
				   END IF   	 

									     ELSE    !Merging of 3 droplets
				   flag_merge = 2  
	
		   END IF
		

	!Overlapping with LEFT droplet 
	 ELSEIF ( deltaL .LT. (epsL + epsM + TOL) )  THEN
    	   		      flag_merge = -1	

	!Overlapping with RIGHT droplet 
	 ELSEIF ( deltaR .LT. (epsM + epsR + TOL) )  THEN  								  
		          flag_merge = 1
					    
	!NO OVERLAPPING
								        ELSE 
			      flag_merge = 0																	
	END IF 



	END SUBROUTINE 