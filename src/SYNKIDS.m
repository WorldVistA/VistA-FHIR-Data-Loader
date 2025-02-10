SYNKIDS ; OSE/SMH - Synthea Installer ;2019-11-18  5:45 PM
 ;;0.6;VISTA SYN DATA LOADER;;Feb 10, 2025
 ;
 ; Copyright (c) 2018-2019 Sam Habiel
 ; Copyright (c) 2025 DocMe360 LLC
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
ENV ; [KIDS] Env check
 ; Don't install if user doesn't hold XUMGR -- needed for creating Syn providers
 I '$D(^XUSEC("XUMGR",DUZ)) W "Must hold key XUMGR",!! S XPDQUIT=1
 QUIT
 ;
TRAN ; [KIDS] - Transport from source system (BAD! SHOULD BE A FILEMAN FILE)
 M @XPDGREF@("SYN")=^SYN
 N I F I=200000000-1:0  S I=$O(^ICPT(I)) Q:'I  M @XPDGREF@("OS5",81,I)=^ICPT(I)
 N LEXF F LEXF=757,757.001,757.01,757.02,757.1,757.21 DO
 . N I F I=3000000000-1:0 S I=$O(^LEX(LEXF,I)) Q:'I  M @XPDGREF@("OS5",LEXF,I)=^LEX(LEXF,I)
 n mapRoot s mapRoot=$$setroot^SYNWD("loinc-lab-map")
 M @XPDGREF@("loinc-lab-map")=@mapRoot
 QUIT
 ;
PRE ; [KIDS] - Pre Install
 QUIT
 ;
POST ; [KIDS] - Post Install
 DO POSTSYN
 DO POSTMAP
 DO EN^SYNGBLLD
 D ^SYNINIT
 QUIT
 ;
POSTSYN ; [Private] Restore SYN global
 ; Resore data from saved global
 ; Next line makes this safe to run in dev mode
 D MES^XPDUTL("Merging ^SYN global in. This takes time...")
 I $D(XPDGREF)#2,$D(@XPDGREF@("SYN")) D
 . K ^SYN("2002.030","sct2icd"),^("sct2icdnine"),^("sct2os5") ; **NAKED**
 . M ^SYN=@XPDGREF@("SYN")
 ;
 ; Install OS5 codes (CPT codes replacement since CPT is copyrighted)
 I $D(XPDGREF)#2,$D(@XPDGREF@("OS5")) D
 . N SYNF F SYNF=81,757,757.001,757.01,757.02,757.1,757.21 DO  ; for each file
 .. N SYNCR S SYNCR=$$ROOT^DILFD(SYNF,,1) ; closed reference
 .. N SYNOR S SYNOR=$$ROOT^DILFD(SYNF)    ; open reference
 .. N SYNI F SYNI=0:0 S SYNI=$O(@XPDGREF@("OS5",SYNF,SYNI)) Q:'SYNI  D  ; for each entry
 ... ;
 ... ; Delete old data
 ... N DA,DIK S DA=SYNI,DIK=SYNOR D ^DIK
 ... ;
 ... ; Add new data
 ... M @SYNCR@(SYNI)=@XPDGREF@("OS5",SYNF,SYNI)
 ... N DA,DIK S DA=SYNI,DIK=SYNOR D IX1^DIK
 QUIT
 ;
POSTMAP ; [Private] Add loinc-lab-map to the graph store
 new root set root=$$setroot^SYNWD("loinc-lab-map")
 kill @root
 merge @root=@XPDGREF@("loinc-lab-map")
 new rindx set rindx=$name(@root@("graph","map"))
 set @root@("index","root")=rindx
 do index^SYNGRAPH(rindx)
 quit
 ;
