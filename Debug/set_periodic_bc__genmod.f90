        !COMPILER-GENERATED INTERFACE MODULE: Thu Nov 02 10:42:30 2017
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE SET_PERIODIC_BC__genmod
          INTERFACE 
            SUBROUTINE SET_PERIODIC_BC(N,X,R,EPS,PHI,PHI_B,AGE)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: X(100)
              REAL(KIND=8) :: R(100)
              REAL(KIND=8) :: EPS(100)
              REAL(KIND=8) :: PHI(100)
              REAL(KIND=8) :: PHI_B(100)
              INTEGER(KIND=4) :: AGE(100)
            END SUBROUTINE SET_PERIODIC_BC
          END INTERFACE 
        END MODULE SET_PERIODIC_BC__genmod
