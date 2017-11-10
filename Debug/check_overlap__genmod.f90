        !COMPILER-GENERATED INTERFACE MODULE: Thu Nov 02 10:42:29 2017
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CHECK_OVERLAP__genmod
          INTERFACE 
            SUBROUTINE CHECK_OVERLAP(N,ICOLL,X,R,EPS,                   &
     &WARNING_3_DROPS_MERGING,FLAG_MERGING)
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: ICOLL
              REAL(KIND=8) :: X(100)
              REAL(KIND=8) :: R(100)
              REAL(KIND=8) :: EPS(100)
              INTEGER(KIND=4) :: WARNING_3_DROPS_MERGING
              INTEGER(KIND=4) :: FLAG_MERGING(100)
            END SUBROUTINE CHECK_OVERLAP
          END INTERFACE 
        END MODULE CHECK_OVERLAP__genmod
