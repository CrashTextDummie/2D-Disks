        !COMPILER-GENERATED INTERFACE MODULE: Thu Nov 02 10:42:28 2017
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE PRINT_OUTPUT__genmod
          INTERFACE 
            SUBROUTINE PRINT_OUTPUT(J,ICOLL,FLAGCOLL,ERROR,IERR,        &
     &WARNING_3_DROPS_MERGING,DTCOLL,N_BEFORE,X_BEFORE,R_BEFORE,N,X,R,  &
     &EPS,PHI,PHI_B)
              INTEGER(KIND=4) :: J
              INTEGER(KIND=4) :: ICOLL
              INTEGER(KIND=4) :: FLAGCOLL
              INTEGER(KIND=4) :: ERROR
              INTEGER(KIND=4) :: IERR
              INTEGER(KIND=4) :: WARNING_3_DROPS_MERGING
              REAL(KIND=8) :: DTCOLL
              INTEGER(KIND=4) :: N_BEFORE
              REAL(KIND=8) :: X_BEFORE(100)
              REAL(KIND=8) :: R_BEFORE(100)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: X(100)
              REAL(KIND=8) :: R(100)
              REAL(KIND=8) :: EPS(100)
              REAL(KIND=8) :: PHI(100)
              REAL(KIND=8) :: PHI_B(100)
            END SUBROUTINE PRINT_OUTPUT
          END INTERFACE 
        END MODULE PRINT_OUTPUT__genmod
