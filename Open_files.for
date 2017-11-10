	SUBROUTINE Open_files

	IMPLICIT NONE


	! Open files where I will write the output data					

	OPEN (UNIT = 1, FILE = 'Risultati\t.dat', STATUS = 'UNKNOWN')	    !Time t	 

	OPEN (UNIT = 2, FILE = 'Risultati\x.dat', STATUS = 'UNKNOWN')	    !Droplet position x		 

	OPEN (UNIT = 3, FILE = 'Risultati\r.dat', STATUS = 'UNKNOWN')       !Droplet radius r

	OPEN (UNIT = 4, FILE = 'Risultati\eps.dat', STATUS = 'UNKNOWN')     !Interaction range eps

	OPEN (UNIT = 5, FILE = 'Risultati\V_bridge.dat', STATUS = 'UNKNOWN')    !Water volume deposited on the bridges and left there (because droplets were too small to nucleate as spherical)

	OPEN (UNIT = 6, FILE = 'Risultati\phi.dat', STATUS = 'UNKNOWN')         !Water flux over the droplets: phi
	
	OPEN (UNIT = 7,FILE='Risultati\phi_bridge.dat',STATUS= 'UNKNOWN')   !Water flux over the bridges between the droplets.phi_b
   
	OPEN (UNIT = 8, FILE = 'Risultati\n_drop.dat', STATUS = 'UNKNOWN')  !Droplets number n
			 
	OPEN (UNIT = 9, FILE = 'Risultati\icoll_j.dat',STATUS = 'UNKNOWN')  !Index of the merging i / i+1



	OPEN (UNIT = 11, FILE = 'Risultati\i_NewDrops.dat',STATUS =
     &		'UNKNOWN')    !Index of new nucleated droplets
	OPEN (UNIT = 12, FILE = 'Risultati\x_NewDrops.dat',STATUS =
     &		'UNKNOWN')    !Position of center of new nucleated droplets
	OPEN (UNIT = 13, FILE = 'Risultati\r_NewDrops.dat',STATUS = 
     &		'UNKNOWN')    !Radius of new nucleated droplets
	OPEN (UNIT = 14, FILE = 'Risultati\eps_NewDrops.dat', STATUS = 
     &'UNKNOWN')  !Interaction range of new nucleated droplets

     
	OPEN (UNIT = 15, FILE = 'Risultati\i_merge_AfterNucl.dat',
     &        STATUS = 'UNKNOWN')  !Index of merging droplets after nucleation  
     								 ! and absorbtion of water from bridges
	OPEN (UNIT = 16, FILE = 'Risultati\i_AfterMerge.dat',
     &        STATUS = 'UNKNOWN')  !Index of droplets originating from merging after nucleation  
     								 ! and absorbtion of water from bridges
	OPEN (UNIT = 17, FILE = 'Risultati\nNewDrop_per_bridge.dat',
     &        STATUS = 'UNKNOWN')  !Number of droplets nucleated per bridge


	OPEN (UNIT = 18, FILE = 'Risultati\t_rMin_rMax.dat',
     &        STATUS = 'UNKNOWN')  !Max and min radius

	OPEN (UNIT = 19, FILE = 'Risultati\t_porosity.dat',
     &        STATUS = 'UNKNOWN')  !Porosity

	OPEN (UNIT = 20, FILE = 'Risultati\age.dat',
     &        STATUS = 'UNKNOWN')  !Age of droplets (=instant when they were created)



	OPEN (UNIT = 100, FILE = 'Risultati\parameters.dat',
     &		STATUS = 'UNKNOWN')  !Initial parameters


	END SUBROUTINE 



