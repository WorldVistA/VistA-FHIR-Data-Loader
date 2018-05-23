SYNINIT ;OSEHRA/SMH - Initilization Code for Synthetic Data Loader;May 23 2018
 ;;1.0;Synthetic Data Loader;
; 
; NUMBER: 10                              HTTP VERB: POST                         URI: addcondition
; EXECUTION ENDPOINT: wsIntakeConditions^SYNFCON
 ;
LOADHAND ; [Public] Load URL handlers
 W !!,"LOADING URL HANDLERS",!
 N I,IEN F I=1:1 N LN S LN=$P($T(LH+I),";;",2,99) Q:LN=""  D  ; Read inline
 . N NREF S NREF=$P(LN,"=") ; variable name reference
 . I $E(NREF)="^" S NREF=$NA(@NREF) ; convert IEN to actual value
 . N TESTNODE S TESTNODE="" ; for $DATA testing
 . I $QS(NREF,2)="B" S TESTNODE=$NA(@NREF,5) ; Get all subs b4 IEN
 . I $L(TESTNODE),$D(@TESTNODE) DO  QUIT  ; If node exists in B index
 . . WRITE TESTNODE_" ALREADY INSTALLED",!  ; say so
 . . KILL ^%W(17.6001,IEN) ; and delete the stuff we entered
 . S @LN  ; okay to set.
 QUIT
LH ;; START
 ;;IEN=$O(^%W(17.6001," "),-1)+1
 ;;^%W(17.6001,IEN,0)="POST"
 ;;^%W(17.6001,IEN,1)="addpatient/*"
 ;;^%W(17.6001,IEN,2)="wsPostFHIR^SYNFHIR"
 ;;^%W(17.6001,"B","POST","addpatient/*","wsPostFHIR^SYNFHIR",IEN)=""
 ;;IEN=IEN+1
 ;;^%W(17.6001,IEN,0)="GET"
 ;;^%W(17.6001,IEN,1)="showfhir/*"
 ;;^%W(17.6001,IEN,2)="wsShow^SYNFHIR"
 ;;^%W(17.6001,"B","GET","showfhir/*","wsShow^SYNFHIR",IEN)=""
 ;;IEN=IEN+1
 ;;^%W(17.6001,IEN,0)="GET"
 ;;^%W(17.6001,IEN,1)="vpr/*"
 ;;^%W(17.6001,IEN,2)="wsVPR^SYNVPR"
 ;;^%W(17.6001,"B","GET","vpr/*","wsVPR^SYNVPR",IEN)=""
 ;;IEN=IEN+1
 ;;^%W(17.6001,IEN,0)="GET"
 ;;^%W(17.6001,IEN,1)="global/{root}"
 ;;^%W(17.6001,IEN,2)="wsGLOBAL^SYNVPR"
 ;;^%W(17.6001,"B","GET","global/{root}","wsGLOBAL^SYNVPR",IEN)=""
 ;;IEN=IEN+1
 ;;^%W(17.6001,IEN,0)="POST"
 ;;^%W(17.6001,IEN,1)="addvitals/*"
 ;;^%W(17.6001,IEN,2)="wsIntakeVitals^SYNFVIT"
 ;;^%W(17.6001,"B","POST","addvitals/*","wsIntakeVitals^SYNFVIT",IEN)=""
 ;;IEN=IEN+1
 ;;^%W(17.6001,IEN,0)="POST"
 ;;^%W(17.6001,IEN,1)="addencounter"
 ;;^%W(17.6001,IEN,2)="wsIntakeEncounters^SYNFENC"
 ;;^%W(17.6001,"B","POST","addencounter","wsIntakeEncounters^SYNFENC",IEN)=""
 ;;IEN=IEN+1
 ;;^%W(17.6001,IEN,0)="POST"
 ;;^%W(17.6001,IEN,1)="addcondition"
 ;;^%W(17.6001,IEN,2)="wsIntakeConditions^SYNFCON"
 ;;^%W(17.6001,"B","POST","addcondition","wsIntakeConditions^SYNFCON",IEN)=""
 ;;^%W(17.6001,0)="WEB SERVICE URL HANDLER^17.6001S^"_IEN_"^"_IEN
 ;;
