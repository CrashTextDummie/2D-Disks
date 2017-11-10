	SUBROUTINE Nucleation_new_droplets(j_time,n_old,icoll,
     &		       flag_nucleation,flag_too_small,n_drop_per_bridge,
     &			   x_nucleation,Vb,Vb_drop,x_old,r_old,eps_old,age_old,
     &		  	   i_nucl,x_nucl,r_nucl,eps_nucl,n,x,r,eps,Vb_res,age)
								     !(j,n,icoll,
				  !flag_nucleation,flag_too_small,n_drop_per_bridge,
				  !x_nucleation,Vb,Vb_drop,x,r,eps,age,
     				  !i_NewDrops,x_NewDrops,r_NewDrops,eps_NewDrops,	    
     				  !n_AfterNucl,x_AfterNucl,r_AfterNucl,eps_AfterNucl,
     				  !Vb_res_AfterNucl,age_AfterNucl)
	
	!I create the vectors of the droplets after considering the reabsorbtion 
	!of the water fallen in the bridges between the droplets and the nucleation of new droplets

	 ! lb(i)        = length of cylindrical bridge between dorp (i) and (i-1)
	 ! flag_absorb  =  1: the water collected by the bridge between droplets is reabsorbed by the droplets
	 !				   0: the water collected by the bridge is NOT reabsorbed by the droplets
	 ! x_new	    = location where the instability start to grow and the droplet is formed (random), inside bridge
 	 ! r_new        = radius of the droplet I can form with the water volume that I accumulate between the droplets
	 ! eps_new      = protruding foot from the new droplet
	 ! i_absorb     = index of the droplet which is absorbing the water collected by the bridge
	 ! i_nucl       = vector containing the indexes of the new nucleated droplets
	 ! j_time       = index of the time instant
	 ! age          = time instant where the droplets were created

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	

	INTEGER::ii,nn,i_new_drop,kk,n_new_drop_bridge,j_vol,jj
	INTEGER::nR_new_drop,jL_bridge,jR_bridge
	INTEGER::j_time     
	INTEGER,DIMENSION(isize)::flag_absorb
	INTEGER,DIMENSION(isize)::i_nucl

	REAL(8):: x_new_drop,r_new_drop,eps_new_drop,deltaL,deltaR
	REAL(8):: V_new_drop, rR
	! x_old,r_old	 !Vector of the position of the center and radius of the droplets 
					 !before considering water cumulated in the bridges between the drops
					 !and nucleation
	REAL(8),DIMENSION(isize):: x_nucl,r_nucl,eps_nucl
							  !Vector of the position of the center and radius of the new droplets 
!	INTEGER,DIMENSION(isize):: nL_merging_per_bridge
!	INTEGER,DIMENSION(isize):: nR_merging_per_bridge

	REAL(8):: INTERACT_RANGE


	DO ii = 1,isize
		x(ii)   = 0.d0
		r(ii)   = 0.d0
		eps(ii) = 0.d0
	    Vb_res(ii) = 0.d0       !Residual volume between the NEW droplets
		i_nucl(ii) = 0		
		x_nucl(ii) = 0.d0
		r_nucl(ii) = 0.d0
		eps_nucl(ii) = 0.d0
		flag_absorb(ii) = 10
!		nL_merging_per_bridge(ii) = 0
!		nR_merging_per_bridge(ii) = 0
	END DO

	!Check condition for instability of the cyclindrical water bridge between two droplets
	! FIRST:  I do a scan in order to set up a flag, that tells me where the water volume 
	!         cumulated on the i-th bridge goes
!	******************************************************************************************
	ii = 0          !Index of the vector of the new droplets (ONLY NUCLEATED)
	i_new_drop = 0  !Index used to scan the vector x_nucleation
	j  = 0          !Index for the vector of the TOTAL new drops (OLD + NUCLEATED) 
	n_new_drop = 0  !Number of nucleated droplets
	nR_new_drop = 0  !Number of new droplets nucleated between droplet (n) and (n+1), 
					 !that have to be reinserted at the beginning (before droplet 1 
	j_vol = 0       !Index of the vector of the volumes that will constitute the new droplets (if not absorbed) or will be absorbed

	DO i =1,n_old

		!flag_absorb(j) =  Flag that tells the index of the droplet where the water
		!cumulated in the bridge(i) (between drop(i) and (i+1)) will go.
		!  -1: water of bridge(i) is collected in drop(i) 
		!   0: nucleation of new drop
		!  +1. water of bridge(i) is collected in drop (i+1)
						    
		IF (flag_nucleation(i).EQ.1) THEN  !If nucleation is possible

			 !If the new droplet is too small, I consider that  
			 !	the volume deposited stays in the precursor film
		     IF (flag_too_small(i).EQ.1) THEN  
			 !====================================================   
					j = j + 1              !Counter for vector of total droplets (OLD + NUCLEATED)
			        j_vol = j_vol + 1	   !Counter for water volumes deposited between the droplets	
					flag_absorb(j) = 2               !I have no effective nucleation, but the precursor film grows

		     ELSE		    

			   DO k = 1,n_drop_per_bridge(i)
			   !****************************************************
				 j = j + 1                     !Counter for the vector of the total droplets (OLD + NUCLEATED)
				 i_new_drop = i_new_drop + 1   !Counter for the new nucleated droplets

			     !Position where the new droplet should nucleate
			     x_new_drop =  x_nucleation(i_new_drop)  
			 

			     !Radius of the new droplet 
		         j_vol = j_vol + 1
			     V_new_drop = Vb_drop(j_vol)
!			     r_new_drop =(3.d0/(4.d0*pi_gr)*V_new_drop)**(1.d0/3.d0)
                   r_new_drop = (V_new_drop / pi_gr) ** (1.d0/2.d0) !radius calculated for a disc
			     eps_new_drop = INTERACT_RANGE(r_new_drop)


				 !Check if the new droplet grows too much and overlaps with one of the others
				 ! NB: This checks if some droplets of the necklace are overlapping with the  
				 ! old droplets at the extremes of the bridge.They can't overlap 3 by 3 among them,  
				 ! because I check this in 'Find_volume_deposed_between_drops'. In any case, 
				 ! if they do, it will be detected by the 3 by 3 merging general check later --> dtcoll = dtcoll/2
				 !---------------------------------------------------------------------------------
				 CALL Check_overlap_neighbours
     &			   (x_old(i),x_new_drop,x_old(i+1),r_old(i),r_new_drop,
     &			   r_old(i+1),eps_old(i),eps_new_drop,eps_old(i+1),
     &			   flag_absorb(j),warning_3_drops_merging )
				   ! ( xL   ,xM       ,xR    ,rL  ,rM		 ,rR    ,
				   !   epsL ,epsM         ,epsR    ,flag_merging)
			
				 !No overlapping: there is NUCLEATION of a new droplet	
				  IF (flag_absorb(j).EQ.0) THEN    
			  					   		
					   n_new_drop = n_new_drop + 1 	!Number of new nucleated droplets
					   ii = ii + 1				    !Index of the new nucleated droplets						

					   x_nucl(ii) = x_new_drop   !Position of the center of the new drop
				  	   r_nucl(ii) = r_new_drop   !Radius of the new drop
					   eps_nucl(ii) = eps_new_drop	
		
					   IF (x_nucl(ii).GT.l_wire)  THEN
							nR_new_drop = nR_new_drop + 1  !Number of nucleated droplets at the end 
														   !that I have to reintroduce at the beginning
					   END IF		

			      !I create a vector telling me how may droplets are absorbed 
				  ! on the left (right) of each bridge 
!				  ---------------------------------------------------------------
!				  ELSEIF (flag_absorb(j).EQ.-1)  THEN
!				   nL_merging_per_bridge(i)=nL_merging_per_bridge(i)+1

!				  ELSEIF (flag_absorb(j).EQ.1) THEN
!				   nR_merging_per_bridge(i)=nR_merging_per_bridge(i)+1
					  					
				  END IF					   
					   					   
			 !****************************************************
			 END DO

		   !=====================================================
		    END IF


		ELSE   !The water of the bridge is collected inside the bigger droplet

		    j = j + 1            !Index for the vector of the new drops (OLD + NUCLEATED)
			j_vol = j_vol + 1    !Index of the vector of the volumes that will constitute the new droplets (if not absorbed) or will be absorbed

			IF (r(i).GT.r(i+1))     THEN

				flag_absorb(j) = -1
			   				        ELSE
				flag_absorb(j) = 1
			
			END IF	

		END IF	 

	END DO
	
	!Total number of droplets after nucleation 
	nn = n_old + n_new_drop


!	I create the vectors of the droplets after considering the reabsorbtion 
!		of the water fallen in the bridges between the droplets and the nucleation
!	***************************************************************************************
	j  = 0		!Index of the vector of all the droplets after considering the 
				!	absorbtion of the water deposed in the bridges and the nucleation
	ii = 0      !Index of the vector of the new nucleated droplets
	kk  = 0     !Index of the vector where I write the indexes of the new nucleated droplets

	!Initialization of the vector of the position of the center and radii of the droplets 
	IF ( nR_new_drop.NE.0) THEN

		DO j = 1,nR_new_drop
			x(j)   = x_nucl(n_new_drop - nR_new_drop + j) - l_wire
			r(j)   = r_nucl(n_new_drop - nR_new_drop + j)
			eps(j) = eps_nucl(n_new_drop - nR_new_drop + j)	
			age(j) = j_time	

			kk = kk + 1
		    i_nucl(kk) = j			 
		END DO
			
		j = nR_new_drop
		
	END IF

	x(j+1)   = x_old(1)  
	r(j+1)   = r_old(1)	 
	eps(j+1) = eps_old(1)
	age(j+1) = age_old(1)
	!-----------------------------------------------------------------------------------
	
	
	j_vol = 0   !Index of the volume of which I want to know if it is reabsorbed or not
	
	DO i=1,n_old    !Scansion of the vector of the bridges between droplets (old + nucleated)


	    !**************************************************************************
		 IF (n_drop_per_bridge(i).LE.1     .OR.  	
     &			flag_too_small(i) .EQ.1)   THEN    !ONLY ONE DROPLET NUCLEATES IN THE BRIDGE OR NONE   			
	    !**************************************************************************
	 		 j     = j + 1        !Counter for vector of total droplets (OLD + NUCLEATED)
               j_vol = j_vol + 1    !Counter for water volumes deposited between the droplets	

			
			 IF (flag_absorb(j_vol).EQ.0)  THEN !Nucleation of a new droplet inside bridge (i) -between drop(i) and (i+1)-
		     !__________________________________________________________________________________
			  !NEW DROP NUCLEATED ON BRIDGE (i)
		 	    ii = ii +1               !Index inside the vector of the new nucleated droplets			
			    x(j+1) = x_nucl(ii) 
			    r(j+1) = r_nucl(ii)		
			    eps(j+1) = eps_nucl(ii)
				age(j+1) = j_time        !Age of the droplet newly created

				kk = kk + 1 
				i_nucl(kk) = j + 1       !I create a vector with the indexes of the new droplets			
	
			  !DROP ON THE RIGHT OF THE BRIDGE (i)
			    x(j+2) = x_old(i+1)
			    r(j+2) = r_old(i+1)
			    eps(j+2) = eps_old(i+1)
				age(j+2) = age_old(i+1)
		
			   !Index of the vector of the droplets (TOT) after considering absorbtion and nucleation		   	
			    j  = j + 1                


		     ELSEIF (flag_absorb(j_vol).EQ.-1) THEN	 !The water goes only to the drop on the left of bridge (i)	
		    !__________________________________________________________________________________
		      !DROP ON THE LEFT OF BRIDGE (i)
		 	    x(j) =  x_old(i)			 
!			    r(j) = (3.d0/(4.d0*pi_gr)*Vb(i) + 
!     &									r(j)**3.d0)**(1.d0/3.d0)
                  r(j) = (Vb(i) / pi_gr + r(j)**2.d0)**(1.d0/2.d0) !radius changed for disk
			    eps(j) = INTERACT_RANGE(r(j))
				age(j) = age_old(i)	       			

		      !DROP ON THE RIGHT OF BRIDGE (i)
		       IF (i.NE.n_old) THEN  
			  	 x(j+1) = x_old(i+1)
				 r(j+1) = r_old(i+1)
				 eps(j+1) = eps_old(i+1)
				 age(j+1) = age_old(i+1)	       			


						       ELSE   !The first droplet may have grown as an effect of adding Vb(1)
				 x(j+1)   = x(1) + l_wire   ! = x_old(i+1)
				 r(j+1)   = r(1)
				 eps(j+1) = eps(1)
				 age(j+1) = age_old(1)	       			

		       END IF	
			

			ELSEIF (flag_absorb(j_vol).EQ.+1) THEN !The water goes only to the drop on the right of bridge (i)
		   !__________________________________________________________________________________
			!NB: I don't impose r(j) = r_old(i) because I would neglect the 
			!	 absorbtion of water to the right drop of bridge (i-1)
					
		    !DROP ON THE RIGHT OF BRIDGE (i)
		   	    
			  !Center position
			   x(j+1) = x_old(i+1)

			  !Radius
			   IF (i.NE.n_old) THEN 
!				 r(j+1) = (3.d0/(4.d0*pi_gr)*Vb(i) + 
!     &							  r_old(i+1)**3.d0)**(1.d0/3.d0)
				r(j+1) = (Vb(i) / pi_gr) + 
     &							  r_old(i+1)**3.d0)**(1.d0/2.d0) !radius of circle
ELSE
!				 r(j+1) = (3.d0/(4.d0*pi_gr)*Vb(i) + 
!     &								    r(1)**3.d0)**(1.d0/3.d0)  !To consider that the droplet may 
																  !have already grown as an effect of Vb(1)	
				r(j+1) = (Vb(i) / pi_gr) + 
     &							r(1)**2.d0)**(1.d0/2.d0)	!radius of circle
			   END IF 

			  !Foot protruding from the nucleated droplet (interaction length)
			   eps(j+1) = INTERACT_RANGE(r(j+1))

			  !Age of the droplet (=instant when itwas created)
			   age(j+1) = age_old(i+1)


			  !*Periodic BC
			   IF (i.EQ.n_old) THEN 
				  r(1) = r(j+1)
				  eps(1) = eps(j+1)
			   END IF
		   

		   ELSEIF (flag_absorb(j_vol).EQ.+2) THEN 	!The volume deposited stays in the film (I can't nucleate yet)
		                                            !NB: The condition flag_absorb(j_vol)=2 is equivalent to flag_too_small(i) = 1
		   !__________________________________________________________________________________			
			   !Center position
			   x(j+1) = x_old(i+1)
	
			   !Residual volume in the bridge between drops (j) and (j+1)
			   Vb_res(j) = Vb(i)  
	
			  !Radius
			   IF (i.NE.n_old) THEN 
				 r(j+1) =  r_old(i+1)						 
								ELSE
				 r(j+1) =  r(1)       !To consider that the droplet may have already grown due to Vb(1)										  
			   END IF 

			  !Foot protruding from the nucleated droplet (interaction length)
			   eps(j+1) = INTERACT_RANGE(r(j+1))	  

			  !Age of the droplet (=instant when itwas created)
			   age(j+1) = age_old(i+1)
		   !__________________________________________________________________________________
			END IF


		 ELSE  
	    !**************************************************************************
			j = j + 1 
			n_new_drop_bridge = 0      !N of droplets EFFECTIVELY nucleating on the bridge (i)
			jL_bridge = j     !Index of the droplet on the LEFT of the bridge(i), in the new vector of droplets 
 
		    !+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			 DO  k = 1,n_drop_per_bridge(i)					
			!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				 !j = Index of the volume deposed between droplets (new + nucleated). 
				 !	  When there is no new droplets it is referred to the bridge;
				 !	  When there is a new droplet,  it is referred to the new droplet itself
				 !j_vol = Index of the deposited volume (either in the bridge or ina drop), nucleated + absorbed

			    j_vol = j_vol + 1	
			   
			    V_new_drop = Vb_drop(j_vol)


 			   IF (flag_absorb(j_vol).EQ.0) THEN  !Nucleation of a new droplet inside bridge (i) - between drop(i) and (i+1) -
		       !__________________________________________________________________________________
			     !NEW DROP NUCLEATED ON BRIDGE (i)
		 	      ii = ii +1               !Index inside the vector of the new nucleated droplets			
			      x(j+1) = x_nucl(ii) 
			      r(j+1) = r_nucl(ii)		
			      eps(j+1) = eps_nucl(ii)
				  age(j+1) = j_time         !Age of the droplet

				   !I create a vector with the indexes of the new droplets
				   IF (  i.NE.n_old .OR. 
     &				    (i.EQ.n_old .AND. 
     &				     k.LT.n_drop_per_bridge(i)-nR_new_drop) ) THEN
						kk = kk + 1  
						i_nucl(kk) = j + 1       			
				   END IF

					!DROP ON THE RIGHT OF THE BRIDGE (i)	
					IF (k.EQ.n_drop_per_bridge(i)) THEN 
						x(j+2) = x_old(i+1)
						r(j+2) = r_old(i+1)
						eps(j+2) = eps_old(i+1)
					    age(j+2) = age_old(i+1)
					END IF
		
			        j  = j + 1              !Index inside the vector of the droplets (TOT) 
										  !after considering the absorbtion and the nucleation		   
				    n_new_drop_bridge = n_new_drop_bridge + 1    !N of droplets effectively nucleated (not reabsorbed) on bridge (i)
	
			

			    ELSEIF (flag_absorb(j_vol).EQ.-1) THEN	 !The water goes only to the drop on the left of bridge (i)	
			   !__________________________________________________________________________________
		         !DROP ON THE LEFT OF BRIDGE (i)
		 	      x(jL_bridge) =  x_old(i)			 
!			      r(jL_bridge) = (3.d0/(4.d0*pi_gr) * V_new_drop + 
!     &								  r(jL_bridge)**3.d0)**(1.d0/3.d0)
                    r(jL_bridge) = (V_new_drop / pi_gri + r(jL_bridge)
     &								  **2.d0)**(1.d0/2.d0) !radius of circle               
			      eps(jL_bridge) = INTERACT_RANGE(r(jL_bridge))
				  age(jL_bridge) = age_old(i)		 
						       			
				  !DROP ON THE RIGHT OF BRIDGE (i)
				  IF (k.EQ.n_drop_per_bridge(i)) THEN 
				    IF (i.NE.n_old) THEN  
			  	      x(j+1) = x_old(i+1)
				      r(j+1) = r_old(i+1)
				      eps(j+1) = eps_old(i+1)
					  age(j+1) = age_old(i+1)
					 	        ELSE   !The first droplet may have grown as an effect of adding Vb(1)
				      x(j+1)   = x(1) + l_wire   ! = x_old(i+1)
				      r(j+1)   = r(1)
				      eps(j+1) = eps(1)
					  age(j+1) = age(1)
		            END IF
				  END IF


			    ELSEIF (flag_absorb(j_vol).EQ.+1) THEN !The water goes only to the drop on the right of bridge (i)
		       !__________________________________________________________________________________
			   !NB: I don't impose r(j) = r_old(i) because I would neglect the 
			   !	 absorbtion of water to the right drop of bridge (i-1)
					
		        ! DROP ON THE RIGHT OF BRIDGE (i)
		   	    
			    !Index of the droplet on the right of the bridge (in the new vector)
			      jR_bridge = jL_bridge + n_new_drop_bridge + 1     

			    !Center position
			      x(jR_bridge) = x_old(i+1)

			    !Radius
			      IF (k.GT.1 .AND. flag_absorb(j_vol-1).EQ.1)  THEN 
					 rR = r(jR_bridge)   !I may have already had merging with some droplets of the bridge						   
													           ELSE
			             IF (i.NE.n) THEN 
						   	   rR = r_old(i+1) 
				 		 ELSE	
						       rR = r(1)   !To consider that the droplet may have already grown as an effect of Vb(1)										   	
			             END IF 
                
			       END IF
			       
!			       r(jR_bridge) = (3.d0/(4.d0*pi_gr)*V_new_drop + 
!     &									rR**3.d0)**(1.d0/3.d0)
                     r(jR_bridge) = (V_new_drop / pi_gr + rR**2.d0)
     &									**(1.d0/2.d0) !radius of disk      

			    !Foot protruding from the nucleated droplet (interaction length)
			       eps(jR_bridge) = INTERACT_RANGE(r(jR_bridge))

				!Age of the droplet
				   age(jR_bridge) = age_old(i+1)


			    !*Periodic BC
			      IF (i.EQ.n_old. AND. k.EQ.n_drop_per_bridge(i)) THEN 
				     r(1)   = r(j+1)
				     eps(1) = eps(j+1)
			      END IF
		   !__________________________________________________________________________________
		    END IF

		!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		  END DO   ! k = 1, n_drop_bridge(i)
		!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


	   !*************************************************************************
	   END IF

	END DO

	


	!Check and set total number of droplets n, after considering nucleation
	IF (j.NE. nn + nR_new_drop) THEN 

		WRITE (*,*) 'Error! N of droplets after water absorbtion from' 
     		WRITE (*,*) 'the bridges and nucleation'

								ELSE		
		n = nn  
		
	END IF		

	END SUBROUTINE 