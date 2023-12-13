#include "OBCS_OPTIONS.h"

      SUBROUTINE OBCS_CALC( futureTime, futureIter,
     &                      uVel, vVel, wVel, theta, salt,
     &                      myThid )
C     *==========================================================*
C     | SUBROUTINE OBCS_CALC
C     | o Calculate future boundary data at open boundaries
C     |   at time = futureTime
C     *==========================================================*
      IMPLICIT NONE

C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#ifdef ALLOW_EXCH2
#include "W2_EXCH2_SIZE.h"
#endif /* ALLOW_EXCH2 */
#include "SET_GRID.h"
#include "GRID.h"
#include "OBCS_PARAMS.h"
#include "OBCS_GRID.h"
#include "OBCS_FIELDS.h"
#include "EOS.h"

C     == Routine arguments ==
      INTEGER futureIter
      _RL futureTime
      _RL uVel (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL vVel (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL wVel (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL theta(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL salt (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      INTEGER myThid

#ifdef ALLOW_OBCS

C     == Local variables ==
      INTEGER bi, bj
      INTEGER I, J ,K

      _RL obTimeScale,Uinflow,rampTime2
      _RL vertStructU(Nr), vertStructW(Nr), N2(Nr), N2o(Nr) 
      _RL vertStructUo(Nr)
      _RL kx
      _RL tmpsum

        data vertStructUo / 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
     &  0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
     &  0.5, 0.4, 0.3, 0.2, 0.1, 0.05, 0.005,
     & -0.005,-0.05,-0.1,-0.2,-0.3,-0.4,-0.5,
     & -0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,
     & -0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,
     & -0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,
     & -0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,
     & -0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,
     & -0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,
     & -0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,
     & -0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5, 
     & -0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,   
     & -0.5,-0.5,-0.5,-0.5,-0.5,-0.5,-0.5,
     & -0.5,-0.5,-0.5 /
        data vertStructW /0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     & 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     & 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     & 0,0,0,0,0,0,0,0,0,0,0,0,0 /
        data N2o / 0, 0,0,0,0,0,0,0.0001117,
     & 0.0001106, 0.0001059, 0.00010132, 0, 9.66863214573893e-05,
     & 0.000179500037765250,0.000160993099004095,0.000142509764837232,
     & 0.000124047404630238,0.000105603397717548,4.58875477061704e-05,
     & 4.12827568117890e-05, 0,0,0,0,0,0,0,0,0,0,0,0,0,
     & 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     & 3.66794725205700e-05, 0,0,0,0,0,0,0,0, 0, 5.95565533226762e-05,
     & 4.11562599546940e-05, 2.27626169958993e-05, 4.48505077549223e-06,
     & -1.12012974898263e-07, 0,0,0,0,0,0,0,0,
     & 0,-4.70902680671938e-06,0,0,0,0,0,0,0,
     & 0,0,-4.07844252199138e-06,0,0,0,0,0,0,0 /

      do K=1,Nr
       N2(K) = N2o(K)
      enddo
C Vertical mode number
C      mz=1.0 _d 0


C Create a vertical structure function with zero mean
      tmpsum=0.
      do K=1,Nr
C       vertStructWst(K)=cos(mz*PI* (rC(K)/rF(Nr+1)) )
       tmpsum=tmpsum+vertStructUo(K)*drF(K)
      enddo
      tmpsum=tmpsum/rF(Nr+1)
      do K=1,Nr
       vertStructU(K)=vertStructUo(K)-tmpsum
      enddo
c
      obTimeScale = 44567.0 _d 0
       kx=2. _d 0*pi/(2.0*4700.0 _d 0)
     &  *sqrt((2.0 _d 0*pi*2.0 _d 0*pi/(obTimeScale*obTimeScale)
     & - f0*f0)/(1.0 _d -6
     & - 2.0 _d 0*pi*2.0 _d 0*pi/(obTimeScale*obTimeScale)))
        Uinflow = 0.5 _d 0
C *NOTE* I have commented out the ramp function below
C just to speed things up. You will probably want to use it
C for smoother looking solutions.
      rampTime2 = 44567.0 _d 0

      DO bj=myByLo(myThid),myByHi(myThid)
      DO bi=myBxLo(myThid),myBxHi(myThid)

C     Western OB
      IF (useOrlanskiWest) THEN
        CALL ORLANSKI_WEST(
     &          bi, bj, futureTime, 
     &          uVel, vVel, wVel, theta, salt, 
     &          myThid )
      ELSE
        DO K=1,Nr
          DO J=1-Oly,sNy+Oly
          OBWu(J,K,bi,bj)=0. _d 0
     &       +Uinflow
     &       *vertStructU(K)
     &       *sin(2. _d 0*PI*futureTime/obTimeScale)
     &       *(exp(futureTime/rampTime2)
     &   - exp(-futureTime/rampTime2))
     &   /(exp(futureTime/rampTime2)
     &  + exp(-futureTime/rampTime2))
     &   *cos(kx*(3. _d 0-2. _d 0-0.5 _d 0)*delX(1))
          OBWv(J,K,bi,bj)=0. _d 0
     &       +Uinflow
     &       *f0/(2.0 _d 0*PI/obTimeScale)
     &       *vertStructU(K)
     &       *cos(2. _d 0*PI*futureTime/obTimeScale )
     & * (exp(futureTime/rampTime2)
     &   - exp(-futureTime/rampTime2))
     &   /(exp(futureTime/rampTime2)
     &  + exp(-futureTime/rampTime2))
          OBWt(J,K,bi,bj)=tRef(K)
     & + Uinflow*vertStructW(K)
     & * sin(2.0 _d 0*PI*futureTime/obTimeScale)
     & /(2.0 _d 0*PI/obTimeScale)
     & *(N2(K)/(tAlpha*gravity))
     & * (exp(futureTime/rampTime2)
     &   - exp(-futureTime/rampTime2))
     &   /(exp(futureTime/rampTime2)
     &  + exp(-futureTime/rampTime2))
#ifdef ALLOW_NONHYDROSTATIC
          OBWw(J,K,bi,bj)= 0.0 
     &       -Uinflow
     &       * vertStructW(K)
     &       *cos(2. _d 0*PI*futureTime/obTimeScale)
     &       *(exp(futureTime/rampTime2)
     &   - exp(-futureTime/rampTime2))
     &   /(exp(futureTime/rampTime2)
     &  + exp(-futureTime/rampTime2))
#endif
          ENDDO
        ENDDO
      ENDIF
C--   end bi,bj loops.
      ENDDO 
      ENDDO

#endif /* ALLOW_OBCS */
      RETURN
      END












