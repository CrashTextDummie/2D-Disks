        !COMPILER-GENERATED INTERFACE MODULE: Thu Nov 02 10:42:29 2017
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE FIND_MERGING__genmod
          INTERFACE 
            SUBROUTINE FIND_MERGING(N,X,R,EPS,WARNING_3_DROPS_MERGING,  &
     &WARNING_NO_MERGING,FLAG_MERGING,I_MERGING)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: X(100)
              REAL(KIND=8) :: R(100)
              REAL(KIND=8) :: EPS(100)
              INTEGER(KIND=4) :: WARNING_3_DROPS_MERGING
              INTEGER(KIND=4) :: WARNING_NO_MERGING
              INTEGER(KIND=4) :: FLAG_MERGING(100)
              INTEGER(KIND=4) :: I_MERGING(100)
            END SUBROUTINE FIND_MERGING
          END INTERFACE 
        END MODULE FIND_MERGING__genmod
