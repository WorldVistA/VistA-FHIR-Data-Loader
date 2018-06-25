SYNDHP69 ;AFHIL-DHP/fjf - Commin Utility Functions
 Q
DUZ() ; issues/set DUZ
 ;
 I '$D(DT) S DT=$$DT^XLFDT
 S SITE=$P($$SITE^VASITE,"^",3)
 S DUZ=$S(+$G(DUZ)=0:1,1:DUZ)
 S DUZ("AG")="V",DUZ(2)=SITE
 Q DUZ