        !COMPILER-GENERATED INTERFACE MODULE: Thu Nov 02 10:42:30 2017
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CHECK_OVERLAP_NEIGHBOURS__genmod
          INTERFACE 
            SUBROUTINE CHECK_OVERLAP_NEIGHBOURS(XL,XM,XR,RL,RM,RR,EPSL, &
     &EPSM,EPSR,FLAG_MERGE,WARNING_3_DROPS_MERGING)
              REAL(KIND=8) :: XL
              REAL(KIND=8) :: XM
              REAL(KIND=8) :: XR
              REAL(KIND=8) :: RL
              REAL(KIND=8) :: RM
              REAL(KIND=8) :: RR
              REAL(KIND=8) :: EPSL
              REAL(KIND=8) :: EPSM
              REAL(KIND=8) :: EPSR
              INTEGER(KIND=4) :: FLAG_MERGE
              INTEGER(KIND=4) :: WARNING_3_DROPS_MERGING
            END SUBROUTINE CHECK_OVERLAP_NEIGHBOURS
          END INTERFACE 
        END MODULE CHECK_OVERLAP_NEIGHBOURS__genmod
