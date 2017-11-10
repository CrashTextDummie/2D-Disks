	SUBROUTINE Print_output(j,icoll,flagcoll,error,ierr,
     &						warning_3_drops_merging,dtcoll,
     &						n_before,x_before,r_before,
     &						n,x,r,eps,phi,phi_b)


	! Scrive sullo schermo le posizioni e le velocità delle particelle 

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	
	INCLUDE 'Formats.fi'

	!TIME INSTANT
	WRITE (*,199) t
	WRITE (*,200) j       !Number of the instant
	WRITE (*,201) icoll



	!DATI INERENTI LA COLLISIONE ALL'ISTANTE DI TEMPO CONSIDERATO
	
	IF (t.NE.0) THEN

		WRITE (*,198) n
 		WRITE (*,202) dtcoll

		IF (flagcoll==0) THEN 							
						  WRITE (*,203)         !"No merging"
						 ELSEIF	(icoll.NE.n) THEN 
						  WRITE (*,204) icoll,(icoll+1)
										     ELSE 
						  WRITE (*,205),n
		ENDIF	
				
	END IF
	WRITE (*,206) 


	!POSITION OF THE CENTRE AND RADIUS at the moment when collision happens
!	DO i=1,n 
!		WRITE (*,207) i,x(i)
!	END DO
!	WRITE (*, 206)


	IF ((t.NE.0).AND.(flagcoll.NE.0)) THEN
	!******************************************************
	!Radii BEFORE considering water from the bridges and 
	! nucleation (if t.NE.0)
!		DO i=1,n_before	
!			WRITE (*,208) i,r_before(i)
!		END DO
!		WRITE (*,206) 


		!Radii AFTER considering water from bridges and nucleation (if t.NE.0)
!		DO i=1,n
!			WRITE (*,209) i,r(i)
!		END DO
!		WRITE (*,206) 

	!******************************************************

	ELSEIF (t.EQ.0.d0) THEN  !If t=0, I am at the beginning of the simulation

		DO i=1,n
			WRITE (*,210) i,r(i)
		END DO
		WRITE (*,206) 

				    ELSE 
		DO i=1,n   !???
			WRITE (*,211) i,r(i)
		END DO
		WRITE (*,206) 

	END IF

	!INTERACTION RANGE eps(i) AND FLUXES phi(i)
!	IF ((t.NE.0).AND.(flagcoll.NE.0).AND.(icoll.NE.0)) THEN

!		WRITE (*,212) eps(icoll) + eps(icoll+1)
!		WRITE (*,*)
!		WRITE (*,213) phi(icoll)
!		WRITE (*,*)
!		WRITE (*,214) phi(icoll+1)
!		WRITE (*,*)
!		WRITE (*,215) phi_b(icoll)

!		WRITE (*,206)

!	END IF


	!dtcoll had to be corrected
	IF (warning_3_drops_merging.EQ.1) THEN								
		WRITE (*,*) 'More than 2 drops merging'
		WRITE (*,*)
	END IF 

	!********************************************************************
	!ERROR MESSAGES 

	!Overlapping of two drops (from Check_compenetration)
	IF (error==1) THEN 
		WRITE (*,300) ierr,(ierr+1)
		STOP
	END IF 

	!Drop n-th has x(n) too large (from Check_xn_Rn)
	IF (error==2) THEN									!(from TEST 1)	
		WRITE (*,301) ierr
		STOP
	END IF 

	!Overlap of drops (n) and (n+1) (i.e. (1) )
	IF (error==3) THEN									!(from TEST 2)
		WRITE (*,302) ierr
		STOP
	END IF 




	WRITE (*,*)


	END SUBROUTINE 