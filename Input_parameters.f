	SUBROUTINE Input_parameters(n)					   

	!questo programma legge solo i parametri del programma dal file parametri

	IMPLICIT NONE

	INCLUDE 'Declarations.fi'
	INCLUDE 'Parameters.fi'	

	INTEGER::status



	!**PARAMETRI DA ACQUISIRE

	!mp=massa della particella (in qto caso ho pp aventi tutte la stessa massa)
	!vo=vtà di normalizzazione 
	!f= forza applicata dall'esterno sulla pp n
	!l=lunghezza approssimativa della barra
	!tempotot= tempo totale di integrazione, su cui guardiamo la dinamica delle pp



	status=0

	OPEN (UNIT = 3, FILE = 'Input\parameters.dat', STATUS = 'UNKNOWN',
     &		ACTION='READ',IOSTAT=status)
	Openif: IF (status/=0) THEN 
			            WRITE (*,*) 'Errore di apertura del file param
     &etri :IOSTAT= ',status
					 
						ELSE Openif
					 	   REWIND 3 
						READ (3,120,IOSTAT=status) time_tot
						   IF (status/=0) THEN 
						       WRITE (*,*) 'Error reading (time tot)'
			               END IF							   
						READ (3,121,IOSTAT=status) n
						   IF (status/=0) THEN 
						       WRITE (*,*) 'Error reading (n)= number 
     &of droplets'
			               END IF
						READ (3,120,IOSTAT=status) r0
						   IF (status/=0) THEN 
						      WRITE (*,*) 'Error reading (r0)'
			               END IF
						READ (3,120,IOSTAT=status) phi0
						   IF (status/=0) THEN 
						      WRITE (*,*) 'Errore di lettura di phi0 = 
     &normal flux'
			               END IF
						READ (3,120,IOSTAT=status) l0
						   IF (status/=0) THEN 
						       WRITE (*,*) 'Errore di lettura di l0 = 
     &initial length'
			               END IF
				
	    END IF Openif

	INCLUDE 'Formats.fi'

 
	CLOSE (3)


	END SUBROUTINE Input_parameters


				


