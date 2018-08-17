SYNDHPMP ; AFHIL/FJF terminology mapping
 ;;0.1;VISTA SYNTHETIC DATA LOADER;;Aug 17, 2018
 ;;Original routine authored by Andrew Thompson & Ferdinand Frankson of DXC Technology 2017-2018
 ;
MAP(MAP,CODE,DIR) ; Return a mapped code for a given code
 ; Input:
 ; MAP - mapping to be used
 ;       currently only map implemented are "sct2icd" (5/18/2018)
 ;                                          "sct2cpt" (5/15/2018)
 ;                                          "rxn2ndf" (5/15/2018)
 ; CODE - map source code
 ; DIR - direction of mapping
 ; D for direct (default)
 ; I for inverse
 ; 
 ; Output:
 ; 1^map target code
 ; or -1^exception
 ;
 N DOI,FN,TAR
 S FN="2002.030"
 S DIR=$G(DIR,"D")
 S DOI=$S(DIR="I":"inverse",1:"direct")
 I '$D(^SYN(FN,MAP)) Q "-1^map not recognised"
 I '$D(^SYN(FN,MAP,DOI,CODE)) Q "-1^code not mapped"
 S TAR=$O(^SYN(FN,MAP,DOI,CODE,""))
 I MAP="sct2icd" S TAR=$TR(TAR,"?","A")
 Q "1^"_TAR
