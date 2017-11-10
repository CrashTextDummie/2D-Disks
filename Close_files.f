	SUBROUTINE Close_files

	IMPLICIT NONE


	! Close files where I write output

	CLOSE (1)    !Time t
	CLOSE (2)    !Position of the droplet centre: x
	CLOSE (3)    !Droplet radius: r
	CLOSE (4)    !Interaction range: eps
	CLOSE (5)    !Water volume on the bridges between the droplets (when no new drops nucleate as they are too small)
	CLOSE (6)    !Water flux over the droplets: phi
	CLOSE (7)    !Water flux over the bridges between the droplets.phi_b
	CLOSE (8)    !Droplet number: n
	CLOSE (9)    !Index of the merging droplets (i/ i+1) : icoll

	CLOSE (11)	 !Index of new nucleated droplets
	CLOSE (12)   !Position of centre of new drops
	CLOSE (13)	 !Radius
	CLOSE (14)   !Eps

	CLOSE (15)   !Index of merging droplets after nucleation and absorbtion of water from bridges
	CLOSE (16)   !Index of new droplets originating from merging after nucleation and absorbtion
	CLOSE (17)   !Number of droplets nucleated per bridge

	CLOSE (18)   !Rmin, Rmax
	CLOSE (19)   !Porosity
	CLOSE (20)   !Age of droplets

	CLOSE (100)   !Initial parameters


	END SUBROUTINE 

