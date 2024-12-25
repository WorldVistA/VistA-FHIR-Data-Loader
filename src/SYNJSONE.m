SYNJSONE ;SLC/KCM -- Encode JSON;Feb 07, 2019@11:01 ; 6/28/19 1:42pm
 ;
ENCODE(VVROOT,VVJSON,VVERR) ; VVROOT (M structure) --> VVJSON (array of strings)
 ;
DIRECT ; TAG for use by encode^SYNJSONE
 ;
 ; Examples:  D encode^SYNJSONE("^GLO(99,2)","^TMP($J)")
 ;            D encode^SYNJSONE("LOCALVAR","MYJSON","LOCALERR")
 ;
 ; VVROOT: closed array reference for M representation of object
 ; VVJSON: destination variable for the string array formatted as JSON
 ;  VVERR: contains error messages, defaults to ^TMP("SYNJSONERR",$J)
 ;
 S VVERR=$G(VVERR,"^TMP(""SYNJSONERR"",$J)")
 I '$L($G(VVROOT)) ; set error info
 I '$L($G(VVJSON)) ; set error info
 N VVLINE,VVMAX,VVERRORS
 ;
 ; V4W/DLW - Changed VVMAX from 4000 (just under the 4096 string size limit)
 ; to 100. With large data arrays, the JSON encoder could exhaust system
 ; memory, which required a switch to globals to fix. However, 4000 as a
 ; limit slowed the encoder down quite a bit, when using globals.
 ; With the change to VVMAX, the following Unit Tests required changes:
 ; PURENUM^SYNJSODT,
 ; ESTRING^SYNJSODT, BASIC^SYNJSOET, VALS^SYNJSOET, LONG^SYNJSOET,
 ; PRE^SYNJSOET, WP^SYNJSOET, EXAMPLE^SYNJSOET
 S VVLINE=1,VVMAX=100,VVERRORS=0 ; limit document lines to 100 characters
 S @VVJSON@(VVLINE)=""
 D SEROBJ(VVROOT)
 Q
 ;
SEROBJ(VVROOT) ; Serialize into a JSON object
 N VVFIRST,VVSUB,VVNXT
 S @VVJSON@(VVLINE)=@VVJSON@(VVLINE)_"{"
 S VVFIRST=1
 S VVSUB="" F  S VVSUB=$O(@VVROOT@(VVSUB)) Q:VVSUB=""  D
 . S:'VVFIRST @VVJSON@(VVLINE)=@VVJSON@(VVLINE)_"," S VVFIRST=0
 . ; get the name part
 . D SERNAME(VVSUB)
 . ; if this is a value, serialize it
 . I $$ISVALUE(VVROOT,VVSUB) D SERVAL(VVROOT,VVSUB) Q
 . ; otherwise navigate to the next child object or array
 . I $D(@VVROOT@(VVSUB))=10 S VVNXT=$O(@VVROOT@(VVSUB,"")) D  Q
 . . ; Need to check if numeric representation matches string representation to decide if it is an array
 . . I +VVNXT=VVNXT D SERARY($NA(@VVROOT@(VVSUB))) I 1
 . . E  D SEROBJ($NA(@VVROOT@(VVSUB)))
 . D ERRX("SOB",VVSUB)  ; should quit loop before here
 S @VVJSON@(VVLINE)=@VVJSON@(VVLINE)_"}"
 Q
SERARY(VVROOT) ; Serialize into a JSON array
 N VVFIRST,VVI,VVNXT
 S @VVJSON@(VVLINE)=@VVJSON@(VVLINE)_"["
 S VVFIRST=1
 S VVI=0 F  S VVI=$O(@VVROOT@(VVI)) Q:'VVI  D
 . S:'VVFIRST @VVJSON@(VVLINE)=@VVJSON@(VVLINE)_"," S VVFIRST=0
 . I $$ISVALUE(VVROOT,VVI) D SERVAL(VVROOT,VVI) Q  ; write value
 . I $D(@VVROOT@(VVI))=10 S VVNXT=$O(@VVROOT@(VVI,"")) D  Q
 . . ; Need to check if numeric representation matches string representation to decide if it is an array
 . . I +VVNXT=VVNXT D SERARY($NA(@VVROOT@(VVI))) I 1
 . . E  D SEROBJ($NA(@VVROOT@(VVI)))
 . D ERRX("SAR",VVI)  ; should quit loop before here
 S @VVJSON@(VVLINE)=@VVJSON@(VVLINE)_"]"
 Q
SERNAME(VVSUB) ; Serialize the object name into JSON string
 I $E(VVSUB)="""" S VVSUB=$E(VVSUB,2,$L(VVSUB)) ; quote indicates numeric label
 I ($L(VVSUB)+$L(@VVJSON@(VVLINE)))>VVMAX S VVLINE=VVLINE+1,@VVJSON@(VVLINE)=""
 S @VVJSON@(VVLINE)=@VVJSON@(VVLINE)_""""_$$ESC(VVSUB)_""""_":"
 Q
SERVAL(VVROOT,VVSUB) ; Serialize X into appropriate JSON representation
 N VVX,VVI,VVDONE
 ; if the node is already in JSON format, just add it
 I $D(@VVROOT@(VVSUB,":")) D  QUIT  ; <-- jump out here if preformatted
 . S VVX=$G(@VVROOT@(VVSUB,":")) D:$L(VVX) CONCAT
 . S VVI=0 F  S VVI=$O(@VVROOT@(VVSUB,":",VVI)) Q:'VVI  S VVX=@VVROOT@(VVSUB,":",VVI) D CONCAT
 ;
 S VVX=$G(@VVROOT@(VVSUB)),VVDONE=0
 ; handle the numeric, boolean, and null types
 I $D(@VVROOT@(VVSUB,"\n")) S:$L(@VVROOT@(VVSUB,"\n")) VVX=@VVROOT@(VVSUB,"\n") D CONCAT QUIT  ; when +X'=X
 I '$D(@VVROOT@(VVSUB,"\s")),$L(VVX) D  QUIT:VVDONE
 . I VVX']]$C(1) S VVX=$$JNUM(VVX) D CONCAT S VVDONE=1 QUIT
 . I VVX="true"!(VVX="false")!(VVX="null") D CONCAT S VVDONE=1 QUIT
 ; otherwise treat it as a string type
 S VVX=""""_$$ESC(VVX) ; open quote
 D CONCAT
 I $D(@VVROOT@(VVSUB,"\")) D  ; handle continuation nodes
 . S VVI=0 F  S VVI=$O(@VVROOT@(VVSUB,"\",VVI)) Q:'VVI   D
 . . S VVX=$$ESC(@VVROOT@(VVSUB,"\",VVI))
 . . D CONCAT
 S VVX="""" D CONCAT    ; close quote
 Q
CONCAT ; come here to concatenate to JSON string
 I ($L(VVX)+$L(@VVJSON@(VVLINE)))>VVMAX S VVLINE=VVLINE+1,@VVJSON@(VVLINE)=""
 S @VVJSON@(VVLINE)=@VVJSON@(VVLINE)_VVX
 Q
ISVALUE(VVROOT,VVSUB) ; Return true if this is a value node
 I $D(@VVROOT@(VVSUB))#2 Q 1
 N VVX S VVX=$O(@VVROOT@(VVSUB,""))
 Q:VVX="\" 1  ; word processing continuation node
 Q:VVX=":" 1  ; pre-formatted JSON node
 Q 0
 ;
NUMERIC(X) ; Return true if the numeric
 I $L(X)>18 Q 0        ; string (too long for numeric)
 I X=0 Q 1             ; numeric (value is zero)
 I +X=0 Q 0            ; string
 I $E(X,1)="." Q 0     ; not a JSON number (although numeric in M)
 I $E(X,1,2)="-." Q 0  ; not a JSON number
 I +X=X Q 1            ; numeric
 I X?1"0."1.n Q 1      ; positive fraction
 I X?1"-0."1.N Q 1     ; negative fraction
 S X=$TR(X,"e","E")
 I X?.1"-"1.N.1".".N1"E".1"+"1.N Q 1  ; {-}99{.99}E{+}99
 I X?.1"-"1.N.1".".N1"E-"1.N Q 1      ; {-}99{.99}E-99
 Q 0
 ;
ESC(X) ; Escape string for JSON
 N Y,I,PAIR,FROM,TO
 S Y=X
 F PAIR="\\","""""","//",$C(8,98),$C(12,102),$C(10,110),$C(13,114),$C(9,116) D
 . S FROM=$E(PAIR),TO=$E(PAIR,2)
 . S X=Y,Y=$P(X,FROM) F I=2:1:$L(X,FROM) S Y=Y_"\"_TO_$P(X,FROM,I)
 I Y?.E1.C.E S X=Y,Y="" F I=1:1:$L(X) S FROM=$A(X,I) D
 . ; skip NUL character, otherwise encode ctrl-char
 . I FROM<32 Q:FROM=0  S Y=Y_$$UCODE(FROM) Q
 . I FROM>126,(FROM<160) S Y=Y_$$UCODE(FROM) Q
 . S Y=Y_$E(X,I)
 Q Y
 ;
JNUM(N) ; Return JSON representation of a number
 I N'<1 Q N
 I N'>-1 Q N
 I N>0 Q "0"_N
 I N<0 Q "-0"_$P(N,"-",2,9)
 Q N
 ;
UCODE(C) ; Return \u00nn representation of decimal character value
 N H S H="0000"_$$CNV^SYNWEBUT(C,16)
 Q "\u"_$E(H,$L(H)-3,$L(H))
 ;
ERRX(ID,VAL) ; Set the appropriate error message
 D ERRXSYNJSON(ID,$G(VAL))
 Q
 ;
 ; Portions of this code are public domain, but it was extensively modified
 ; Copyright 2016 Accenture Federal Services
 ; Copyright 2013-2019 Sam Habiel
 ; Copyright 2019 Christopher Edwards
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
