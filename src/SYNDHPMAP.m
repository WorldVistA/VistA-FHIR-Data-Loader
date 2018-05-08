SYNDHPMAP	; AFHIL/FJF terminology mapping
	;;1.0;DHP;;Jan 17, 2017;Build 2
	;;Original routine authored by Andrew Thompson & Ferdinand Frankson of DXC Technology 2017-2018
	;
ALLRGY()	;
	K ^SYN("2002.010")
	S D=" (disorder)"
	S N=""
	F  S N=$O(^ZZFJFALL(N)) Q:N=""  D
	.S TRM=^ZZFJFALL(N)
	.S TRM=$P(TRM,D)
	.K LEX
	.S LEX=$$TXT4CS^LEXTRAN(TRM,"SCT")
	.;W ! ZW LEX
	.I +LEX<1 D
	..I $E(TRM,$L(TRM))'="s" S TRM=TRM_"s"
	..S LEX=$$TXT4CS^LEXTRAN(TRM,"SCT")
	.I +LEX<1 S ^SYN("2002.010","UNK",TRM)="" Q
	.S SCTCD=$O(LEX(""))
	.S ^SYN("2002.010","SCTC",SCTCD,TRM)=""
	.S ^SYN("2002.010","SCTT",TRM,SCTCD)=""
	Q
REACTIONS	;
	D AMAP
	D AMSAVE
	Q
AMAP	;
	S N=0
	K REACMAP,REACNF,REACANOM
	F  S N=$O(^GMRD(120.83,N)) Q:+N=0  D
	.S REAC=$P(^GMRD(120.83,N,0),U)
	.K ZZL
	.S REAX=$$TXT4CS^LEXTRAN(REAC,"SCT","ZZL") ;W !,REAC,! ZW ZZL R *R
	.I REAX="1^1" S REACMAP(N,$O(ZZL(0)),REAC)="" Q
	.I REAX?1N1"^"1.2N D MULT Q
	.I REAX="0^0" S REACNF(REAC)=""
	Q
MULT()	;
	S M=0
	F  S M=$O(ZZL(M)) Q:+M=0  D
	.I $D(REACMAP(N)) Q
	.K LEX S X=$$CODE^LEXTRAN(M,"SCT") W ! ZW LEX
	.I +X=1!(+X=-4) S REACMAP(N,+LEX(0),REAC)="" ; W ! ZW REACMAP(N) R *R Q
	.S REACANOM(REAC)=""
	Q
AMSAVE	;
	K ^SYN("2002.010","REACTIONS")
	M ^SYN("2002.010","REACTIONS","ICT")=REACMAP
	S N="^SYN(""2002.010"",""REACTIONS"",""ICT"")"
	F  S N=$Q(@N) Q:$QS(N,1)'="REACTIONS"  Q:$QS(N,2)'="ICT"  D
	.S ^SYN("2002.010",$QS(N,1),"TCI",$QS(N,5),$QS(N,4),$QS(N,3))=""
	Q
AMMSCO	; missing content
	;
	S N=0,FN=120.83,S1="REACTIONS",S2="ICT"
	F  S N=$O(^GMRD(FN,N)) Q:+N=0  D
	.I $D(^SYN("2002.010",S1,S2,N)) Q
	.S T=^GMRD(FN,N,0)
	.W !,T
	.R !,"SCT ",SCT
	.S ^SYN("2002.010",S1,S2,N,SCT,T)=""
	.S ^SYN("2002.010",S1,"TCI",T,SCT,N)=""
	Q
	;
	;
EXPL	;
	S N=0,FN=120.82
	F  S N=$O(^GMRD(FN,N)) Q:+N=0  D
	.S TX=$P(^GMRD(FN,N,0),U)
	.K LEX
	.S LEX=$$TXT4CS^LEXTRAN(TX,"SCT")
	.I +LEX=-1,$E(TX,$L(TX))="S" S LEX=$$TXT4CS^LEXTRAN($RE($E($RE(TX),2,$L(TX))),"SCT")
	.I +LEX=-1,$E($RE(TX),1,2)="SE" S LEX=$$TXT4CS^LEXTRAN($RE($E($RE(TX),3,$L(TX))),"SCT")
	.W !,TX,! ZW LEX
	Q
ALLERGENS	;
	D ALMAP
	D ALSAVE
	Q
ALMAP	;
	S N=0,FN=120.82
	K ALLGNMAP,ALLGNNF,ALLGNANOM
	F  S N=$O(^GMRD(FN,N)) Q:+N=0  D
	.S ALLGN=$P(^GMRD(FN,N,0),U)
	.K ZZL
	.S REAX=$$TXT4CS^LEXTRAN(ALLGN,"SCT","ZZL")
	.I +REAX=-1,$E(ALLGN,$L(ALLGN))="S" S REAX=$$TXT4CS^LEXTRAN($RE($E($RE(ALLGN),2,$L(ALLGN))),"SCT","ZZL")
	.I +REAX=-1,$E($RE(ALLGN),1,2)="SE" S REAX=$$TXT4CS^LEXTRAN($RE($E($RE(ALLGN),3,$L(ALLGN))),"SCT","ZZL") ;W !,REAC,! ZW ZZL R *R
	.I REAX="1^1" S ALLGNMAP(N,$O(ZZL(0)),ALLGN)="" Q
	.I REAX?1N1"^"1.2N D MULTA Q
	.I REAX="0^0" S ALLGNNF(ALLGN)=""
	Q
MULTA()	;
	S M=0
	F  S M=$O(ZZL(M)) Q:+M=0  D
	.I $D(ALLGNMAP(N)) Q
	.K LEX S X=$$CODE^LEXTRAN(M,"SCT") W ! ZW LEX
	.I +X=1!(+X=-4) S ALLGNMAP(N,+LEX(0),ALLGN)="" ; W ! ZW REACMAP(N) R *R Q
	.S ALLGNANOM(ALLGN)=""
	Q
ALSAVE	;
	S ASUB="ALLERGENS",INDX="ICT"
	K ^SYN("2002.010",ASUB)
	M ^SYN("2002.010",ASUB,"ICT")=ALLGNMAP
	S N="^SYN(""2002.010"","""_ASUB_""","""_INDX_""")"
	F  S N=$Q(@N) Q:$QS(N,1)'=ASUB  Q:$QS(N,2)'=INDX  D
	.S ^SYN("2002.010",$QS(N,1),"TCI",$QS(N,5),$QS(N,4),$QS(N,3))=""
	Q
ALLSCO	; missing content
	;
	S N=0,FN=120.82,S1="ALLERGENS",S2="ICT"
	F  S N=$O(^GMRD(FN,N)) Q:+N=0  D
	.I $D(^SYN("2002.010",S1,S2,N)) Q
	.S T=^GMRD(FN,N,0)
	.W !,T
	.R !,"SCT ",SCT
	.S ^SYN("2002.010",S1,S2,N,SCT,T)=""
	.S ^SYN("2002.010",S1,"TCI",T,SCT,N)=""
	Q
CLNMAPR3	; remove carets from index
	S N="^SYN(""2002.010"",""REACTIONS"",""TCI"")"
	F  S N=$Q(@N) Q:N=""  Q:$QS(N,2)'="TCI"  D
	.I $QS(N,3)'["^" Q
	.S S3=$P($QS(N,3),"^")
	.S ^SYN("2002.010",$QS(N,1),$QS(N,2),S3,$QS(N,4),$QS(N,5))=""
	.K ^SYN("2002.010",$QS(N,1),$QS(N,2),$QS(N,3))
	.W !,N,!,S3
	Q
CLNMAPA3	; remove carets from index
	S N="^SYN(""2002.010"",""ALLERGENS"",""TCI"")"
	F  S N=$Q(@N) Q:N=""  Q:$QS(N,2)'="TCI"  D
	.I $QS(N,3)'["^" Q
	.S S3=$P($QS(N,3),"^")
	.S ^SYN("2002.010",$QS(N,1),$QS(N,2),S3,$QS(N,4),$QS(N,5))=""
	.K ^SYN("2002.010",$QS(N,1),$QS(N,2),$QS(N,3))
	.W !,N,!,S3
	Q
CLNMAPA5	; remove carets from index
	S N="^SYN(""2002.010"",""ALLERGENS"",""ICT"")"
	F  S N=$Q(@N) Q:N=""  Q:$QS(N,2)'="ICT"  D
	.I $QS(N,5)'["^" Q
	.S S5=$P($QS(N,5),"^")
	.S ^SYN("2002.010",$QS(N,1),$QS(N,2),$QS(N,3),$QS(N,4),S5)=""
	.K ^SYN("2002.010",$QS(N,1),$QS(N,2),$QS(N,3),$QS(N,4),$QS(N,5))
	.W !,N,!,S5
	Q
CLNMAPR5	; remove carets from index
	S N="^SYN(""2002.010"",""REACTIONS"",""ICT"")"
	F  S N=$Q(@N) Q:N=""  Q:$QS(N,2)'="ICT"  D
	.I $QS(N,5)'["^" Q
	.S S5=$P($QS(N,5),"^")
	.S ^SYN("2002.010",$QS(N,1),$QS(N,2),$QS(N,3),$QS(N,4),S5)=""
	.K ^SYN("2002.010",$QS(N,1),$QS(N,2),$QS(N,3),$QS(N,4),$QS(N,5))
	.W !,N,!,S5
	Q
igrxnorm	; ingest RxNorm
	s fil="RXNCONSO.txt"
	s dir="/tmp/"
	d OPEN^%ZISH("rxnorm",dir,fil,"R")
	f  u IO r t q:t=""  d
	.s ^syndhprxn($i(^syndhprxn))=t
	d CLOSE^%ZISH("rxnorm")
	; remove ordure from beginning of line 1
	s t=^syndhprxn(1)
	s t="3"_$p(t,"3",2,$l(t,"3"))
	s ^syndhprxn(1)=t 
	q
idxrxnorm	; index RxNorm
	k ^SYN("2002.020")
	s n="",p="|"
	f  s n=$o(^syndhprxn(n)) q:n=""  d
	.s tx=^syndhprxn(n)
	.s rxcui=$p(tx,p)
	.s code=$p(tx,p,14)
	.s codeSystem=$p(tx,p,12)
	.s surfaceFormType=$p(tx,p,13)
	.s surfaceForm=$p(tx,p,15)
	.s ct=$i(^SYN("2002.020",rxcui,codeSystem,code,surfaceFormType))
	.s ^SYN("2002.020",rxcui,codeSystem,code,surfaceFormType,ct)=surfaceForm
	.i $l(surfaceForm)<200 S ^SYN("2002.020","sf",surfaceForm,surfaceFormType,codeSystem,code)=rxcui
	q
	;
cVANDFidx	; create VANDF index
	; ^SYN("2002.020","IVANDF",VUID,rxcui)=""
	k ^SYN("2002.020","IXVANDF")
	s n=0
	f  s n=$o(^SYN("2002.020",n)) q:+n=0  d
	.i '$d(^SYN("2002.020",n,"VANDF")) q
	.s vuid=""
	.s vuid=$o(^SYN("2002.020",n,"VANDF",vuid)) q:vuid=""  d
	..s ^SYN("2002.020","IXVANDF",vuid,n)=""
	q 
LYNX	;
	S N=0,F=120.8
	F  S N=$O(^GMR(F,N)) Q:+N=0  D
	.S INT=$$GET1^DIQ(F,N_",",1,"I")
	.S EXT=$$GET1^DIQ(F,N_",",1,"E")
	.I $P(INT,";",2)["GMRD" Q
	.I $P(INT,";",2)["PSDRUG" D LPSDRUG Q
	.I $P(INT,";",2)["PSNDF" D LPSNDF Q
	.W !,N,"  -  ",INT,"  -  ",EXT
	Q
LPSDRUG	;
	Q
	W !,N,"  -  ",INT,"  -  ",EXT
	S PSDIEN=+$P(INT,";")
	W !,$$GET1^DIQ(50,PSDIEN_",",64,"E")
	S GENNAM=$$GET1^DIQ(50,PSDIEN_",",64,"E")
	W !,$O(^PS(50.416,"B",GENNAM,""))
	I '$D(^PS(50.416,"B",GENNAM)) W !,"Not found" Q
	S FPFOS=$O(^PS(50.416,"B",GENNAM,""))
	S VUID=$$GET1^DIQ(50.416,FPFOS_",","VUID")
	W !,VUID
	Q
LPSNDF	;
	Q
	W !,N,"  -  ",INT,"  -  ",EXT
	S PSDIEN=+$P(INT,";")
	S VUID=$$GET1^DIQ(50.6,PSDIEN_",","VUID")
	W !,VUID
	Q
sct2icd	;
	s n=0,U="^"
	s map="sct2icd"
	k ^SYN("2002.030",map)
	f  s n=$o(^syndhpraw(map,n)) q:n=""  d
	.s tx=^syndhpraw(map,n)
	.s sct=$p(tx,U,6)
	.s surface=$p(tx,U,7)
	.s icd=$p(tx,U,12)
	.s ^SYN("2002.030",map,n)=sct_U_icd_U_surface
	q
sct2icdmix	; SNOMED CT to ICD map create indices
	;
	s n=0,U="^"
	s map="sct2icd"
	k ^SYN("2002.030",map,"direct"),^SYN("2002.030",map,"inverse")
	f  s n=$o(^SYN("2002.030",map,n)) q:+n=0  d
	.s tx=^SYN("2002.030",map,n)
	.s sct=$p(tx,U),icd=$p(tx,U,2)
	.q:sct=""
	.q:icd=""
	.s surface=$p(tx,U,3)
	.i surface'["(disorder)",surface["(finding)" q
	.s ^SYN("2002.030",map,"direct",sct,icd,n)=$p(tx,U,3)
	.s ^SYN("2002.030",map,"inverse",icd,sct,n)=$p(tx,U,3)
	q
sct2icddl	; SNOMED CT to ICD-10 map data load from source file
	; source is UMLS SNOMED CT to ICD10 map
	s tb=$c(9),U="^"
	s map="sct2icd"
	s file="snomed_icd10.txt"
	s dir="/tmp/"
	d OPEN^%ZISH("maps",dir,file,"R")
	i POP=1 w !,"lamentably, I can't see your file" q
	u IO f i=1:1 r tx q:tx=""  d
	.s ^syndhpraw(map,i)=$tr(tx,tb,U)
	d CLOSE^%ZISH("maps")
	q
MAP(MAP,CODE,DIR)	; Return a mapped code for a given code
	; Input:
	; MAP - mapping to be used
	; CODE - map source code
	; DIR - direction of mapping
	; D for direct (default)
	; I for inverse
	; 
	; Output:
	; 1^map target code
	; or -1^exception
	;
	n DOI
	s DIR=$G(DIR,"D")
	s DOI=$S(DIR="I":"inverse",1:"direct")
	i '$d(^SYN("2002.030",MAP)) q "-1^map not recognised"
	i '$d(^SYN("2002.030",MAP,DOI,CODE)) q "-1^code not mapped"
	q "1^"_$o(^SYN("2002.030",MAP,DOI,CODE,""))
	
