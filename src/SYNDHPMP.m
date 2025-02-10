SYNDHPMP ; AFHIL/FJF - HealthConcourse - terminology mapping ;2019-11-18  5:41 PM
 ;;0.6;VISTA SYN DATA LOADER;;Feb 10, 2025
 ;;
 ;;Original routine authored by Andrew Thompson & Ferdinand Frankson of Perspecta 2017-2019
 ; Copyright (c) 2017-2019 DXC Technology (now Perspecta)
 ;
 ;Licensed under the Apache License, Version 2.0 (the "License");
 ;you may not use this file except in compliance with the License.
 ;You may obtain a copy of the License at
 ;
 ;    http://www.apache.org/licenses/LICENSE-2.0
 ;
 ;Unless required by applicable law or agreed to in writing, software
 ;distributed under the License is distributed on an "AS IS" BASIS,
 ;WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 ;See the License for the specific language governing permissions and
 ;limitations under the License.
 ;
 ;
MAP(MAP,CODE,DIR,IOE) ; Return a mapped code for a given code
 ;--------------------------------------------------------------------
 ;
 ; Input:
 ;   MAP - mapping to be used
 ;       currently the maps implemented are "sct2icd" (5/18/2018)
 ;                                          "sct2cpt" (9/07/2018)
 ;                                          "sct2icdnine" (8/28/2018)
 ;                                          "mh2loinc" (9/07/2018)
 ;                                          "mh2sct" (9/07/2018)
 ;                                          "sct2hf" (9/07/2018)
 ;                                          "flag2sct" (02/01/2019)
 ;                                          "sct2vit" (02/01/2019)
 ;                                          "ctpos2sct (02/01/2019)
 ;                                          "rxn2ndf" (02/01/2019)
 ;                                          "sct2os5" (02/02/2019)
 ;
 ;   CODE - map source code
 ;   DIR  - direction of mapping
 ;       D for direct (default)
 ;       I for inverse
 ;   IOE  - use internal or exernal mappings
 ;       I for internal SYN VistA(default)
 ;       H for external Health Concourse
 ; Output:
 ;   1^map target code
 ;   or -1^exception
 ;
 ; -------------------------------------------------------------------
 ;
MSTART ;
 ;
 N MAPA,MAPJ,MAPJ8,NODE,STA,RET,DOI,TAR,URL,C,P,SUB
 S U="^",C=":",P="|"
 S IOE=$S($G(IOE)="":"I",1:IOE)
 I "|I|H|"'[(P_IOE_P) Q -1_U_"invalid IOE parameter"
 S STA=1
 ; if we are here then the caller passed I or null in the IOE parameter
 ;
 N DOI,FN,TAR
 S FN="2002.030"
 S DIR=$G(DIR,"D")
 S DOI=$S(DIR="I":"inverse",1:"direct")
 I '$D(^SYN(FN,MAP)) Q "-1^code not mapped"
 I '$D(^SYN(FN,MAP,DOI,CODE)) Q "-1^code not mapped"
 S TAR=$O(^SYN(FN,MAP,DOI,CODE,""))
 I MAP="sct2icd" S TAR=$TR(TAR,"?","A")
 ;W !,"Internal"
 Q 1_U_TAR
 ;
 ;
TEST ; tests
 ;
T1(code) ; SNOMED CT to ICD
 ; example SNOMED CT codes 37739004,37657006
 n csys,intext,dirinv
 f csys="sct2icd","sct2icdnine" d
 .f intext="I","H" d
 ..f dirinv="D" d
 ...w !,csys," code ",code," ",$s(intext="I":"Internal",1:"External")
 ...w !,$$MAP(csys,code,dirinv,intext)
 Q
 ;
T2(code) ; mental health to SNOMED CT
 ; example mental health codes PHQ-2,PHQ9,2
 n csys,intext,dirinv
 f csys="mh2sct" d
 .f intext="I","H" d
 ..f dirinv="D" d
 ...w !,csys," code ",code," ",$s(intext="I":"Internal",1:"External")
 ...w !,$$MAP(csys,code,dirinv,intext)
 Q
