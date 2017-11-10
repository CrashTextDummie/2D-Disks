        !COMPILER-GENERATED INTERFACE MODULE: Thu Nov 02 10:42:30 2017
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE SAVE_OUTPUT__genmod
          INTERFACE 
            SUBROUTINE SAVE_OUTPUT(H,N,J,ICOLL,I_NEWDROPS,              &
     &I_MERGING_AFTERNUCL,I_AFTERMERGE,N_DROP_PER_BRIDGE,X_NEWDROPS,    &
     &R_NEWDROPS,EPS_NEWDROPS,X,R,EPS,PHI,PHI_B,VB,R_MIN,R_MAX,POROSITY,&
     &AGE)
              INTEGER(KIND=4) :: H
              INTEGER(KIND=4) :: N
              INTEGER(KIND=4) :: J
              INTEGER(KIND=4) :: ICOLL
              INTEGER(KIND=4) :: I_NEWDROPS(100)
              INTEGER(KIND=4) :: I_MERGING_AFTERNUCL(100)
              INTEGER(KIND=4) :: I_AFTERMERGE(100)
              INTEGER(KIND=4) :: N_DROP_PER_BRIDGE(100)
              REAL(KIND=8) :: X_NEWDROPS(100)
              REAL(KIND=8) :: R_NEWDROPS(100)
              REAL(KIND=8) :: EPS_NEWDROPS(100)
              REAL(KIND=8) :: X(100)
              REAL(KIND=8) :: R(100)
              REAL(KIND=8) :: EPS(100)
              REAL(KIND=8) :: PHI(100)
              REAL(KIND=8) :: PHI_B(100)
              REAL(KIND=8) :: VB(100)
              REAL(KIND=8) :: R_MIN
              REAL(KIND=8) :: R_MAX
              REAL(KIND=8) :: POROSITY
              INTEGER(KIND=4) :: AGE(100)
            END SUBROUTINE SAVE_OUTPUT
          END INTERFACE 
        END MODULE SAVE_OUTPUT__genmod
