        !COMPILER-GENERATED INTERFACE MODULE: Thu Nov 02 10:42:28 2017
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE GROW_DROPS__genmod
          INTERFACE 
            SUBROUTINE GROW_DROPS(N,DELTA_T,PHI,R_OLD,R)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: DELTA_T
              REAL(KIND=8) :: PHI(100)
              REAL(KIND=8) :: R_OLD(100)
              REAL(KIND=8) :: R(100)
            END SUBROUTINE GROW_DROPS
          END INTERFACE 
        END MODULE GROW_DROPS__genmod
