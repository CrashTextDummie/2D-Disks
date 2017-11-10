	SUBROUTINE Save_output(h,n,j,icoll,i_NewDrops,i_merging_AfterNucl,
     &				      i_AfterMerge,n_drop_per_bridge,x_NewDrops,
     &					  r_NewDrops,eps_NewDrops,x,r,eps,phi,phi_b,Vb,
     &					  r_min,r_max,porosity,age)

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	

	INTEGER :: h
!	REAL(8) :: Pout(n),Bout(n),Vout(n)

	INCLUDE 'Formats.fi'


	! Scrittura dei dati in uscita 					
	SELECT CASE (h)


	CASE(1) 

		WRITE (1,101,ADVANCE='YES') j,t


	CASE(2)  !Centre of the droplets: x
			
		 WRITE(2,'()')
		 WRITE (2,100,ADVANCE='NO') t
		 WRITE (2,100,ADVANCE='NO') x(1:n)
		 WRITE (2,'()')


	CASE(3)  !Radius of the droplets: r

		WRITE (3,'()')
		WRITE (3, 100,ADVANCE='NO') t
		WRITE (3, 100,ADVANCE='NO') r(1:n)
		WRITE (3,'()')


	CASE(4)  !Interaction range of each droplet:eps

		WRITE(4,'()')
		WRITE (4,100,ADVANCE='NO') t
		WRITE (4,100,ADVANCE='NO') eps(1:n)
		WRITE (4,'()')




	CASE(8)
	
		WRITE  (9,102,ADVANCE='YES') j,icoll



	CASE(10)  

      !Time instants: t
	 WRITE (1,'()')
	 WRITE (1,110,ADVANCE='NO') j
	 WRITE (1,100,ADVANCE='NO') t
	 WRITE (1,'()')


      !Position of the centre of the droplets: x
!	 WRITE (2,'()')
!	 WRITE (2,100,ADVANCE='NO') t
!	 WRITE (2,100,ADVANCE='NO') x(1:isize_save)
!	 WRITE (2,'()')

       WRITE (2,'()')
	 WRITE (2,500) t, x(1:isize_save)
!	 WRITE (2,'()')

	!Radius: r
!	 WRITE (3,'')
!	 WRITE (3,100,ADVANCE='NO') t
!	 WRITE (3,100,ADVANCE='NO') r(1:isize_save)
!	 WRITE (3,'')
       
       WRITE (3,'()')
	 WRITE (3,500) t, r(1:isize_save)

	!Interaction range of each droplet: eps
!	 WRITE (4,'')
!	 WRITE (4,100,ADVANCE='NO') t
!	 WRITE (4,100,ADVANCE='NO') eps(1:isize_save)
!	 WRITE (4,'')

       WRITE (4,'()')
       WRITE (4,500) t, eps(1:isize_save)
       
	!Residual water volume deposited on the bridges: vb 
!	 WRITE (5,'')
!	 WRITE (5,100,ADVANCE='NO') t
!	 WRITE (5,100,ADVANCE='NO') Vb(1:isize_save)
!	 WRITE (5,'')

       WRITE (5,'()')
	 WRITE (5,500) t, Vb(1:isize_save)
       
	!Flux over each droplet: phi
!	 WRITE (6,'')
!	 WRITE (6,100,ADVANCE='NO') t
!	 WRITE (6,100,ADVANCE='NO') phi(1:isize_save)
!	 WRITE (6,'')

	!Flux over each bridge between the droplets
!	 WRITE (7,'')
!	 WRITE (7,100,ADVANCE='NO') t
!	 WRITE (7,100,ADVANCE='NO') phi_b(1:isize_save)
!	 WRITE (7,'')


	!Number of droplets: n				 
	 WRITE  (8,104,ADVANCE='YES') t,n
	
	!Index of the droplet (i) merging with (icoll+1): icoll
	 WRITE  (9,104,ADVANCE='YES') t,icoll

	!New nucleated droplets
!	 WRITE  (11,'')
!	 WRITE  (11,100,ADVANCE='NO') t
!	 WRITE  (11,105,ADVANCE='NO') i_NewDrops(1:isize_save)
!	 WRITE  (11,'')

       WRITE (11,'()')
	 WRITE (11,501) t, i_NewDrops(1:isize_save)
       
!	 WRITE  (12,'')
!	 WRITE  (12,100,ADVANCE='NO') t
!	 WRITE  (12,100,ADVANCE='NO') x_NewDrops(1:isize_save)
!	 WRITE  (12,'')
       
       WRITE (12,'()')
	 WRITE (12,500) t, x_NewDrops(1:isize_save)

!	 WRITE  (13,'')
!	 WRITE  (13,100,ADVANCE='NO') t
!	 WRITE  (13,100,ADVANCE='NO') r_NewDrops(1:isize_save)
!	 WRITE  (13,'')
       
       WRITE (13,'()')
	 WRITE (13,500) t, r_NewDrops(1:isize_save)

!	 WRITE  (14,'')
!	 WRITE  (14,100,ADVANCE='NO') t
!	 WRITE  (14,100,ADVANCE='NO') eps_NewDrops(1:isize_save)
!	 WRITE  (14,'')
       
       WRITE (14,'()')
	 WRITE (14,500) t, eps_NewDrops(1:isize_save)


	!Index of merging droplets after nucleation and absorbtion of wtaer from bridges
!	 WRITE  (15,'')
!	 WRITE  (15,100,ADVANCE='NO') t
!	 WRITE  (15,105,ADVANCE='NO') i_merging_AfterNucl(1:isize_save)
!	 WRITE  (15,'')

       WRITE (15,'()')
	 WRITE (15,501) t, i_merging_AfterNucl(1:isize_save)

	!Index of new droplets originating from merging after absorbtion of water from bridges
!	 WRITE  (16,'')
!	 WRITE  (16,100,ADVANCE='NO') t
!	 WRITE  (16,105,ADVANCE='NO') i_AfterMerge(1:isize_save)
!	 WRITE  (16,'')

       WRITE (16,'()')
	 WRITE (16,501) t, i_AfterMerge(1:isize_save)
       
	!Number of droplets nucleated per bridge
!	 WRITE  (17,'')
!	 WRITE  (17,100,ADVANCE='NO') t
!	 WRITE  (17,105,ADVANCE='NO') n_drop_per_bridge(1:isize_save)
!	 WRITE  (17,'')

       WRITE (17,'()')
	 WRITE (17,501) t, n_drop_per_bridge(1:isize_save)

	!Min and max radius
	 WRITE (18,'()')
	 WRITE (18,100,ADVANCE='NO') t
	 WRITE (18,106,ADVANCE='NO') r_min
	 WRITE (18,106,ADVANCE='NO') r_max
	 WRITE (18,'()')


	!Porosity
	 WRITE (19,'()')
	 WRITE (19,100,ADVANCE='NO') t
	 WRITE (19,100,ADVANCE='NO') porosity
	 WRITE (19,'()')


	!Age of droplets 
!	 WRITE (20,'')
!	 WRITE (20,100,ADVANCE='NO') t
!	 WRITE (20,114,ADVANCE='NO') age(1:isize_save)
!	 WRITE (20,'')

       WRITE (20,'()')
	 WRITE (20,501) t, age(1:isize_save)


	CASE(20) 

	  WRITE (100,400) r0_dimens*1.d6    ![um]
	  WRITE (100,401) eps0_dimens*1.d6
	  WRITE (100,402) l_wire_dimens*1.d6
	  WRITE (100,403) r_wire_dimens*1.d6
	  WRITE (100,404) r_equi*1.d6
	  WRITE (100,405) phi0_dimens*1.d12 ![um^2/s]
	  WRITE (100,406) n0
	  WRITE (100,407) isize
	  WRITE (100,408) lambda0
	  WRITE (100,409) t_equi


	END SELECT 
 
 
	END SUBROUTINE Save_output


