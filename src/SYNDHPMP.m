SYNDHPMP ; AFHIL/FJF terminology mapping
 ;;0.2;VISTA SYN DATA LOADER;;Feb 07, 2019;Build 13
 ;;Original routine authored by Andrew Thompson & Ferdinand Frankson of DXC Technology 2017-2018
 ;
MAP(MAP,CODE,DIR) ; Return a mapped code for a given code
 ; Input:
 ;   MAP - mapping to be used
 ;       currently only maps implemented are "sct2icd" (5/18/2018)
 ;                                           "sct2cpt" (5/15/2018)
 ;                                           "sct2icdnine" (8/28/2018)
 ;   CODE - map source code
 ;   DIR - direction of mapping
 ;       D for direct (default)
 ;       I for inverse
 ;
 ; Output:
 ;   1^map target code
 ;   or -1^exception
 ;
 N RTN
 S RTN=-1
 I $D(^BSTS) D  ;Q RTN ; is the BSTS terminology server installed?
 .I MAP="sct2icd" D  Q
 ..S RTN=$$SCT2ICD10^C0TSUTL(CODE)
 ..Q:RTN=-1
 ..I RTN="" S RTN=-1 Q  ;
 ..S RTN="1^"_RTN
 .;
 .I MAP="sct2icdnine" D  Q  ;
 ..S RTN=$$SCT2ICD9^C0TSUTL(CODE)
 ..Q:RTN=-1
 ..I RTN="" S RTN=-1 Q  ;
 ..S RTN="1^"_RTN
 ;
 ; If no BSTS terminology use ^SYN("2002.030")
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
