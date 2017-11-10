        !COMPILER-GENERATED INTERFACE MODULE: Thu Nov 02 10:42:30 2017
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE FIND_DTCOLL__genmod
          INTERFACE 
            SUBROUTINE FIND_DTCOLL(N,X,R,EPS,PHI,DTCOLL,ICOLL,FLAGCOLL)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: X(100)
              REAL(KIND=8) :: R(100)
              REAL(KIND=8) :: EPS(100)
              REAL(KIND=8) :: PHI(100)
              REAL(KIND=8) :: DTCOLL
              INTEGER(KIND=4) :: ICOLL
              INTEGER(KIND=4) :: FLAGCOLL
            END SUBROUTINE FIND_DTCOLL
          END INTERFACE 
        END MODULE FIND_DTCOLL__genmod
