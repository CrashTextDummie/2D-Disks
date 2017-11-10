        !COMPILER-GENERATED INTERFACE MODULE: Thu Nov 02 10:42:30 2017
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE CONDITIONS_FOR_NUCLEATION__genmod
          INTERFACE 
            SUBROUTINE CONDITIONS_FOR_NUCLEATION(N,X,R,EPS,LB,N_NEW_DROP&
     &,FLAG_NUCLEATION,N_DROP_PER_BRIDGE,X_NUCLEATION)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: X(100)
              REAL(KIND=8) :: R(100)
              REAL(KIND=8) :: EPS(100)
              REAL(KIND=8) :: LB(100)
              INTEGER(KIND=4) :: N_NEW_DROP
              INTEGER(KIND=4) :: FLAG_NUCLEATION(100)
              INTEGER(KIND=4) :: N_DROP_PER_BRIDGE(100)
              REAL(KIND=8) :: X_NUCLEATION(100)
            END SUBROUTINE CONDITIONS_FOR_NUCLEATION
          END INTERFACE 
        END MODULE CONDITIONS_FOR_NUCLEATION__genmod
