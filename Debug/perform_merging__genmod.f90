        !COMPILER-GENERATED INTERFACE MODULE: Thu Nov 02 10:42:29 2017
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE PERFORM_MERGING__genmod
          INTERFACE 
            SUBROUTINE PERFORM_MERGING(N_OLD,X_OLD,R_OLD,EPS_OLD,       &
     &VB_RES_OLD,AGE_OLD,FLAG_MERGING_OLD,I_MERGING_OLD,I_FROM_MERGING,N&
     &,X,R,VB_RES,AGE)
              INTEGER(KIND=4) :: N_OLD
              REAL(KIND=8) :: X_OLD(100)
              REAL(KIND=8) :: R_OLD(100)
              REAL(KIND=8) :: EPS_OLD(100)
              REAL(KIND=8) :: VB_RES_OLD(100)
              INTEGER(KIND=4) :: AGE_OLD(100)
              INTEGER(KIND=4) :: FLAG_MERGING_OLD(100)
              INTEGER(KIND=4) :: I_MERGING_OLD(100)
              INTEGER(KIND=4) :: I_FROM_MERGING(100)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: X(100)
              REAL(KIND=8) :: R(100)
              REAL(KIND=8) :: VB_RES(100)
              INTEGER(KIND=4) :: AGE(100)
            END SUBROUTINE PERFORM_MERGING
          END INTERFACE 
        END MODULE PERFORM_MERGING__genmod
