        !COMPILER-GENERATED INTERFACE MODULE: Thu Nov 02 10:42:29 2017
        ! This source file is for reference only and may not completely
        ! represent the generated interface used by the compiler.
        MODULE NUCLEATION_NEW_DROPLETS__genmod
          INTERFACE 
            SUBROUTINE NUCLEATION_NEW_DROPLETS(J_TIME,N_OLD,ICOLL,      &
     &FLAG_NUCLEATION,FLAG_TOO_SMALL,N_DROP_PER_BRIDGE,X_NUCLEATION,VB, &
     &VB_DROP,X_OLD,R_OLD,EPS_OLD,AGE_OLD,I_NUCL,X_NUCL,R_NUCL,EPS_NUCL,&
     &N,X,R,EPS,VB_RES,AGE)
              INTEGER(KIND=4) :: J_TIME
              INTEGER(KIND=4) :: N_OLD
              INTEGER(KIND=4) :: ICOLL
              INTEGER(KIND=4) :: FLAG_NUCLEATION(100)
              INTEGER(KIND=4) :: FLAG_TOO_SMALL(100)
              INTEGER(KIND=4) :: N_DROP_PER_BRIDGE(100)
              REAL(KIND=8) :: X_NUCLEATION(100)
              REAL(KIND=8) :: VB(100)
              REAL(KIND=8) :: VB_DROP(100)
              REAL(KIND=8) :: X_OLD(100)
              REAL(KIND=8) :: R_OLD(100)
              REAL(KIND=8) :: EPS_OLD(100)
              INTEGER(KIND=4) :: AGE_OLD(100)
              INTEGER(KIND=4) :: I_NUCL(100)
              REAL(KIND=8) :: X_NUCL(100)
              REAL(KIND=8) :: R_NUCL(100)
              REAL(KIND=8) :: EPS_NUCL(100)
              INTEGER(KIND=4) :: N
              REAL(KIND=8) :: X(100)
              REAL(KIND=8) :: R(100)
              REAL(KIND=8) :: EPS(100)
              REAL(KIND=8) :: VB_RES(100)
              INTEGER(KIND=4) :: AGE(100)
            END SUBROUTINE NUCLEATION_NEW_DROPLETS
          END INTERFACE 
        END MODULE NUCLEATION_NEW_DROPLETS__genmod
