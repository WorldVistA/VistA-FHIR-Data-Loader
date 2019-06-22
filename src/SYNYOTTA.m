SYNYOTTA	;gpl - agile web server ; 2/27/17 4:33pm
 ;;1.0;norelease;;feb 27, 2017;build 2
 ;
 ;
 q
 ;
setroot(graph) ; root of working storage
 q $$setroot^SYNWD(graph)
 ;
 i '$d(graph) s graph="seeGraph"
 n %y s %y=$o(^XTMP("SYNGRAPH","B",graph,""))
 i %y="" s %y=$$addgraph(graph) ; if graph is not present, add it
 q $na(^XTMP("SYNGRAPH",%y)) ; root for graph
 ;
addgraph(graph) ; makes a place in the graph file for a new graph
 q $$addgraph^SYNWD(graph)
 ;
 n fda s fda(17.040801,"?+1,",.01)=graph
 n %yerr
 d UPDATE^DIE("","fda","","%yerr")
 n %y s %y=$o(^XTMP("SYNGRAPH","B",graph,""))
 q %y
 ;
homedir() ; extrinsic which return the document home
 n kbaihd s kbaihd=$g(^%WHOME)
 i kbaihd="" d  b  ;
 . w !,"error, home directory not set"
 i $e(kbaihd,$l(kbaihd))="/" s kbaihd=$e(kbaihd,1,$l(kbaihd)-1) 
 q kbaihd
 ;
build ; retrieve directory structure and build into xtmp
 ;
 n kbairoot
 s kbairoot=$$setroot()
 ;k @kbairoot
 ;i '$d(@kbairoot@(0)) d  q  ; work area doesn't exist
 ;. w !,"error, work area not found ",kbairoot
 ;. q
 ;. n X,Y
 ;. s X="T+999" ; a long time from now
 ;. d ^%DT ; covert to fm date format
 ;. s @kbairoot@(0)=Y_"^"_$$NOW^XLFDT_"^kbaiwsai graph"
 ;
 zsy "ls -DRL --file-type ~/www > ~/www/dirconfig.txt"
 n zdir s zdir=^%WHOME
 n kbails,kbails1,ok
 s kbails=$na(@kbairoot@("ls"))
 s kbails1=$na(@kbails@(1))
 s ok=$$FTG^%ZISH(zdir,"dirconfig.txt",kbails1,4)
 d bldgraph
 q
 ;
bldgraph ; build the graph in xtmp
 ;
 n kbairoot s kbairoot=$$setroot()
 n hmdir s hmdir=$$homedir()
 n groot s groot=$na(@kbairoot@("graph"))
 ;k @groot
 n gsrc s gsrc=$na(@kbairoot@("ls"))
 n zi,zj,zln,zien,zien2,uriary,distdir,localdir
 s distdir="root"  ;
 s zien=0
 s zien2=0 ; subfile ien
 s zi=0
 n %cnt s %cnt=0
 f  s zi=$o(@gsrc@(zi)) q:+zi=0  d  ;
 . n zln,zdir,zpar,ztag
 . s zln=@gsrc@(zi)
 . q:zln=""
 . i zln[":" d  q  ;
 . . s %cnt=%cnt+1
 . . ;i %cnt>100000 d counts(groot) s %cnt=1 ; this is for watching progress on big builds
 . . s zien=zien+1
 . . i $e(zln,$l(zln))=":" s zln=$e(zln,1,$l(zln)-1) ; strip off the :
 . . i $g(distdir)="" s distdir="root"  ;
 . . s @groot@(zien,"parent",distdir)=""
 . . s @groot@("pos","parent",distdir,zien)=""
 . . s @groot@("ops",distdir,"parent",zien)=""
 . . s localdir=zln
 . . s @groot@(zien,"localdir",localdir)=""
 . . s @groot@("pos","localdir",localdir,zien)=""
 . . s @groot@("ops",localdir,"localdir",zien)=""
 . . ; set graph type
 . . s @groot@(zien,"type","directory")=""
 . . s @groot@("pos","type","directory",zien)=""
 . . s @groot@("ops","directory","type",zien)=""
 . . s distdir=$p(localdir,$$homedir,2)
 . . i distdir'="" d  ;
 . . . s @groot@(zien,"distdir",distdir)=""
 . . . s @groot@("pos","distdir",distdir,zien)=""
 . . . s @groot@("ops",distdir,"distdir",zien)=""
 . . . s @groot@(zien,"id",distdir)=""
 . . . s @groot@("pos","id",distdir,zien)=""
 . . . s @groot@("ops",distdir,"id",zien)=""
 . . . k uriary d deuri(distdir,"uriary")
 . . s zien2=0
 . ; process file names as a subfile to the directory
 . s zien2=zien2+1
 . ; set parent pointer
 . i $g(distdir)="" s distdir="root"  ;
 . s @groot@(zien,zien2,"parent",distdir)=""
 . s @groot@("pos","parent",distdir,zien,zien2)=""
 . s @groot@("ops",distdir,"parent",zien,zien2)=""
 . ; set file name attribute
 . s @groot@(zien,zien2,"file",zln)=""
 . s @groot@("pos","file",zln,zien,zien2)=""
 . s @groot@("ops",zln,"file",zien,zien2)=""
 . ; tag the file name
 . s @groot@(zien,zien2,"tag",zln)=""
 . s @groot@("pos","tag",zln,zien,zien2)=""
 . s @groot@("ops",zln,"tag",zien,zien2)=""
 . ; added to tag qrda cqm names
 . i $e(zln,1,3)="CMS" d  ;
 . . n cqm
 . . s cqm=$p(zln,"_",1)
 . . d addtag(cqm,zien,zien2)
 . ;
 . ; set the file id
 . n zid s zid=distdir_"/"_zln
 . i distdir="root" s zid=zln
 . s @groot@(zien,zien2,"id",zid)=""
 . s @groot@("pos","id",zid,zien,zien2)=""
 . s @groot@("ops",zid,"id",zien,zien2)=""
 . n ztyp ; graph type
 . i $e(zln,$l(zln))="/" s ztyp="directory"
 . e  s ztyp="file"
 . s @groot@(zien,zien2,"type",ztyp)=""
 . s @groot@("pos","type",ztyp,zien,zien2)=""
 . s @groot@("ops",ztyp,"type",zien,zien2)=""
 . n zftyp
 . s zftyp=$re($p($re(zln),".",1))
 . i zftyp'="" d  ;
 . . s @groot@(zien,zien2,"filetype",zftyp)=""
 . . s @groot@("pos","filetype",zftyp,zien,zien2)=""
 . . s @groot@("ops",zftyp,"filetype",zien,zien2)=""
 . . s @groot@(zien,zien2,"tag",zftyp)=""
 . . s @groot@("pos","tag",zftyp,zien,zien2)=""
 . . s @groot@("ops",zftyp,"tag",zien,zien2)=""
 . . ; tag the name without the filetype
 . . n zfn2
 . . s zfn2=$re($p($re(zln),$re(zftyp)_".",2))
 . . i zfn2'="" d  ;
 . . . s @groot@(zien,zien2,"tag",zfn2)=""
 . . . s @groot@("pos","tag",zfn2,zien,zien2)=""
 . . . s @groot@("ops",zfn2,"tag",zien,zien2)=""
 . . . n contents
 . . . i zftyp["xml" d  ;
 . . . . d scan(.contents,zid,zien,zien2) ; not scanning right now
 . s @groot@(zien,zien2,"localdir",localdir)=""
 . s @groot@("pos","localdir",localdir,zien,zien2)=""
 . s @groot@("ops",localdir,"localdir",zien,zien2)=""
 . i $g(distdir)'="" d  ;
 . . s @groot@(zien,zien2,"distdir",distdir)=""
 . . s @groot@("pos","distdir",distdir,zien,zien2)=""
 . . s @groot@("ops",distdir,"distdir",zien,zien2)="" 
 . ; add the tags from the directory
 . n zj s zj=""
 . f  s zj=$o(uriary(zj)) q:zj=""  d  ;
 . . s @groot@(zien,zien2,"tag",uriary(zj))=""
 . . s @groot@("pos","tag",uriary(zj),zien,zien2)=""
 . . s @groot@("ops",uriary(zj),"tag",zien,zien2)=""
 . ;i zien=3344 b
 ; compute the counts
 d counts(groot) ; 
 q
 ;
counts(groot) ; 
 n ztag,zary,zcnt
 k @groot@("countbytag")
 k @groot@("tagbycount")
 s ztag=""
 f  s ztag=$o(@groot@("pos","tag",ztag)) q:ztag=""  d  ;
 . i ztag="" q  ;
 . k zary
 . d match("#tag:"_ztag,"zary")
 . ;w !,ztag," ",$d(zary)
 . s zcnt=$$count("zary")
 . i zcnt<1 q  ;
 . s @groot@("countbytag",ztag,zcnt)=""
 . s @groot@("tagbycount",zcnt,ztag)=""
 q
 ;
testscan ;
 s zien=4
 s zien2=1
 ;s zid=$o(^xtmp("kbaiweb","graph",4,1,"id",""))
 s zid=$o(@$$setroot@("graph",4,1,"id",""))
 d scan(.g,zid,zien,zien2)
 q
 ;
scan(rtn,zid,zien,zien2) ; scan the file contents for new tags
 ; and add them to the graph
 n zcmd,tmpfile,tmpdir,cmdfile
 s tmpfile="scan.txt"
 s cmdfile="scan.sh"
 s tmpdir=^%WHOME
 s zcmd=$na(^tmp("kbaicmd",$j))
 s zcmd1=$na(@zcmd@(1))
 s @zcmd@(1)="rm "_tmpdir_"/"_tmpfile
 n g2 s g2=""
 f i=1:1:$l(zid) s g2=g2_$s($e(zid,i)=" ":"\ ",1:$e(zid,i))
 ;s @zcmd@(2)="grep code "_tmpdir_"/"_zid_" > "_tmpdir_"/"_tmpfile
 s @zcmd@(2)="grep code "_tmpdir_g2_" > "_tmpdir_tmpfile
 ;s @zcmd@(3)="grep originaltext "_tmpdir_"/"_zid_" >> "_tmpdir_"/"_tmpfile
 s @zcmd@(3)="grep originaltext "_tmpdir_g2_" >> "_tmpdir_tmpfile
 n ok
 s ok=$$GTF^%ZISH(zcmd1,3,tmpdir,cmdfile)
 zsy "bash ../www/scan.sh"
 n where s where=$na(^tmp("kbaiscan",$j))
 k @where
 n where1 s where1=$na(@where@(1))
 s ok=$$FTG^%ZISH(tmpdir,tmpfile,where1,3)
 i ok d  ;
 . n zi s zi=0
 . f  s zi=$o(@where@(zi)) q:+zi=0  d  ;
 . . n zl s zl=@where@(zi)
 . . i zl["code" d  ;
 . . . n code
 . . . s code=$p($p(zl,"code=""",2),""" ")
 . . . i code[">" q  ;
 . . . i code["""" q  ;
 . . . ;b
 . . . n name
 . . . s name=$p($p(zl,"displayName=""",2),"""")
 . . . i name["[&quot;" s name=$p($p(name,"[&quot;",2),"&quot;]")
 . . . i name="" d  ;
 . . . . i zl["<originalText" d  ;
 . . . . . s name=$p($p(zl,"<originalText>",2),"</originalText>")
 . . . q:code=""
 . . . d addtag(code_" "_name,zien,zien2)
 . . . ;d addtag(code,zien,zien2)
 ;zwr ^tmp("kbaiscan",$j,*)
 q
 ;
addtag(tag,zien,zien2) ; add a tag to a graph
 ;w !,"adding ",tag," at ",zien," ",zien2 
 n gn s gn=$na(@$$setroot@("graph"))
 s @gn@(zien,zien2,"tag",tag)=""
 s @gn@("pos","tag",tag,zien,zien2)=""
 s @gn@("ops",tag,"tag",zien,zien2)=""
 ;zwr @$$setroot@("graph",:,:,tag,zien,zien2) 
 q
 ;
wssee(rtn,filter) ; web service for browsing files using the graph
 m ^gpl("filter")=filter
 n arg s arg=$g(filter("*"))
 i arg="" d toppage^%yottahtm(.rtn,.filter) q  ;
 ;i arg="@rewrite" d rewrite(.rtn) q  ;
 i arg]"%" s arg=$$URLDEC^VPRJRUT(arg)
 n ptrary ; pointer array for result
 n groot s groot=$na(@$$setroot@("graph"))
 ;i $$lookup(arg,"id",.ptrary)= d  q  ; id arg is found
 ;. i $$count(.ptrary)=1 d  ; just one match
 ;. . ;
 ;i $o(@$$setroot@("graph","pos","id","/"_arg,""))'="" d  q  ;
 ;i $o(@groot@("pos","id","/"_arg,""))'=""&(arg'="ehmp") d  q  ;
 i $o(@groot@("pos","id","/"_arg,""))'="" d  q  ;
 . ;n zdest s zdest="/"_arg
 . ;i $$stat(arg)'["regular file" s zdest=$$locate(arg)
 . ;i zdest'=arg s filter("*")=zdest
 . i $e(arg,$l(arg))="/" d dir(.rtn,arg) q  ; it's a directory
 . ;i $re($p($re(arg),"."))="xml" d style(.rtn,arg) q  ;
 . i $re($p($re(arg),"."))="xml" d  q  ;
 . . d style(.rtn,arg)
 . . d ADDCRLF^VPRJRUT(.rtn)
 . s filter("*")=arg
 . d FILESYS^%W0(.rtn,.filter)
 ; request is not an id in the graph, so try and find the file if any
 n zf,zuri
 s zuri=$$useuri($$isfile(arg),arg)
 i zuri=-1 s zuri=$$useuri($$altfile($$isfile(arg)),arg)
 i zuri'=-1 d  q  ;
 . i $re($p($re(zuri),"."))="xml" d  q  ;
 . . d style(.rtn,zuri)
 . . d ADDCRLF^VPRJRUT(.rtn)
 . s filter("*")=zuri
 . d FILESYS^%W0(.rtn,.filter) 
 ;s zf=$$isfile(arg)
 ;i zf'=-1 s zuri=$$useuri(zf) ;
 ;e  d  ;
 ;. s zf=$$altfile(zf)
 ;. i zf'=-1 s zuri=$$useuri(zf)
 ;i zuri'=1 d  q  ;
 ;. s filter("*")=zuri
 ;. d FILESYS^%W0(.rtn,.filter)
 n matches
 ;i arg["%20" s arg=$tr(arg,"%20"," ")
 d match("#"_arg,"matches")
 ;m ^gpl("matches")=matches
 ;i $d(matches) s rtn=$q(matches)
 i $$count("matches")>0 d  q  ; more than one match
 . d multout(.rtn,"matches")
 q
 ;
style(rtn,zuri) ;
 n gn s gn=$na(^tmp("kbaiout",$j))
 n gn1 s gn1=$na(@gn@(1))
 k @gn
 n ok
 s ok=$$FTG^%ZISH($$dirpart(zuri),$$isfile(zuri),gn1,3)
 i 'ok d  q  ;
 . ;b
 . s filter("*")=zuri
 . d FILESYS^%W0(.rtn,.filter) 
 s HTTPRSP("mime")="text/xml"
 ;n gt1
 ;s gt1="<?xml-stylesheet type=""text/xsl"" href=""/resources/css/cda.xslt""?>"
 ;i $g(@gn@(1))["?>" d  ;
 ;. n gt s gt=$p(@gn@(1),"?>",1)_"?>"_gt1_$p(@gn@(1),"?>",2)
 ;. s @gn@(1)=gt
 ;s @gn@(1)=@gn@(1)_"<?xml-stylesheet type=""text/xml"" href=""/resources/css/cda.xsl""?>"
 s @gn@(1.5)="<?xml-stylesheet type=""text/xml"" href=""/resources/css/cda.xsl""?>"
 s rtn=gn
 q
 ;
parent(zarg) ; extrinsic which returns the parent of the zarg
 ;
 n groot s groot=$na(@$$setroot@("graph"))
 n zien
 s zien=$o(@groot@("pos","id","/"_zarg,""))
 i zien="" q ""
 q $o(@groot@(zien,"parent",""))
 ;
isfile(zarg) ; extrinsic to return the file name from a uri
 ; -1 if it's not a file
 n rslt
 s rslt=$re($p($re(zarg),"/"))
 i rslt="" s rslt=-1
 q rslt
 ;
dirpart(zuri) ; extrinsic which returns the directory part of the file uri
 n rslt
 s rslt=$p(zuri,$$isfile(zuri),1)
 i rslt="" s rslt=-1
 q ^%WHOME_rslt
 ;
altfile(zfile) ; extrinsic which tries to take the version number out of
 ; the filename ie jasmine-1.3.1.js becomes jasmine.js
 n z1,z2,z3,z4,z5
 s z1=$re(zfile) ; sj.1.3.1-enimsaj
 s z2=$p(z1,".",4) ; 1-enimsaj
 ;w:$g(debug) !,"z2=",z2
 ;s z3=$p(z2,"-",2) ; enimsaj
 s z3=$e(z2,3,$l(z2))
 ;w:$g(debug) !,"z3=",z3,!
 s z4="."_$re($p(z1,".",1)) ; .js
 ;w:$g(debug) !,"z4=",z4,!
 s z5=$re(z3)_z4
 q z5
 ;
useuri(zfile,zarg) ; extrinsic which returns the uri to use for a filename
 ; -1 if none found
 n z1,z2,groot,zr
 s groot=$na(@$$setroot@("graph"))
 s z1=$o(@groot@("pos","file",zfile,""))
 i z1="" q -1
 s z2=$o(@groot@("pos","file",zfile,z1,""))
 s zr=$o(@groot@(z1,z2,"id",""))
 i zr="" s zr=-1
 ;i zr'=-1 d logrewr(zarg,zr)
 q zr
 ;
multout(rtn,zary,title) ; return and html page with multiple selections
 ; zary is passed by name and is usually a "match" array
 d  ;
 . s rtn=$na(^tmp("kbaiwsai",$j))
 . k @rtn
 . n gtop,gbot
 . d htmltb2^%yottaweb(.gtop,.gbot,"search results for #"_arg)
 . m @rtn=gtop
 . i $d(title) d addto^%yottautl(rtn,"<p>"_title_"</p>")
 . d addto^%yottautl(rtn,"<ul>")
 . n zcnt,zstop s (zcnt,zstop)=0
 . n zi s zi=zary
 . f  s zi=$q(@zi) q:((zi="")!(zstop))  d  ;
 . . s zcnt=zcnt+1
 . . i zcnt>1000 s zstop=1
 . . n zptr s zptr=$$fmtptr(zi)
 . . n zd,zf,zref
 . . s zd=$o(@zptr@("localdir",""))
 . . s zd=$p(zd,$$homedir,2)
 . . ;i $e(zd,$l(zd))="/" d  q  ; it's a directory
 . . s zf=$o(@zptr@("file",""))
 . . s zref="<a href=""/see"_zd_"/"_zf_""">"_zd_"/"_zf_"</a>"
 . . d addto^%yottautl(rtn,"<li>"_zref_"</li>")
 . d addto^%yottautl(rtn,"</ul>")
 . k @rtn@(0)
 . s HTTPRSP("mime")="text/html"
 . s @rtn@($o(@rtn@(""),-1)+1)=gbot
 ;i $e(arg,$l(arg))="/" d  q  ; it's a directory
 ;. s rtn="it's a directory"
 ;d FILESYS^%W0(.rtn,.filter)
 q
 ;
dir(rtn,zpar)
 n zi,dirary
 n groot s groot=$na(@$$setroot@("graph"))
 n adj s adj="/"_$e(zpar,1,$l(zpar)-1)
 m dirary=@groot@("pos","parent",adj)
 ;s dirary("up")=$g(@groot@("
 ;b
 i '$d(dirary) q  ;
 d multout(.rtn,"dirary")
 q
 ;
deuri(in,out) ; deconstruct a uri. in passed by value out passed by name
 n zzi
 f zzi=2:1:$l(in,"/") s @out@(zzi-1)=$p(in,"/",zzi)
 q
 ;
reuri(in) ; extrinsic which reconstructs a uri from an array
 q
 ;
repar(in) ; extrinsic which reconstructs a parent uri from an array
 q
 ;
show(zien,zien2) ;
 i $g(zien)="" s zien=1
 i $g(zien2)="" zwr @$$setroot@("graph",zien,*) q  ;
 zwr @$$setroot@("graph",zien,zien2,*)
 q
 ;
fmtptr(inref) ; extrinsic forms a closed global reference to the graph
 ; inref is passed by value and looks like g(2897,3)
 ; returns ^xtmp("kbaiweb","graph",3297,3) based on setroot
 n %1,%2 s %1=$na(@$$setroot@("graph"))
 s %1=$p(%1,")",1)
 s %2=$p(inref,"(",2)
 q %1_","_%2
 ;
gshow(inary) ; show the location and file names pointed to by inary
 ; inary is passed by name
 n %
 n z1 s z1=inary
 f  s z1=$q(@z1) q:z1=""  d  ;
 . n z2,z3
 . s %=$$fmtptr(z1)
 . s z2=$na(@%@("file"))
 . w !,z2,"   ",$o(@z2@(""))
 . s z3=$na(@%@("distdir"))
 . w !,"   ",$o(@z3@(""))
 q
 ;
match(input,outary) ; extrinsic which returns the count of matches, 0 if none
 ; input is a string eg.. #ehmp#applets.  outary is passed by name and returns
 ; the iens of the graph elements that match ie.. outary(1,2)="" and outary(3)
 n po ; predicate object array
 d hashpars(input,"po")
 i '$d(po) q 0 ;
 n groot s groot=$$setroot()
 n posroot s posroot=$na(@groot@("graph","pos"))
 i $o(po(""),-1)=1 d  q  ;$$count(outary) ; only one hash tag to search for
 . n pred,obj
 . s pred=$o(po(1,""))
 . s obj=$o(po(1,pred,""))
 . i ('$d(@posroot@(pred,obj))&($d(@posroot@(pred,obj_" ")))) s obj=obj_" "
 . i $o(@posroot@(pred,obj,""))="" q  ;
 . k @outary
 . m @outary=@posroot@(pred,obj)
 q
 ;
count(ary) ; count the number of entries in the array ary pased by name
 n zcnt s zcnt=0
 i '$d(@ary) q zcnt
 n % s %=ary
 f  s %=$q(@%) q:%=""  s zcnt=zcnt+1
 q zcnt
 ;
recount ; recount the tags
 n groot s groot=$$setroot
 s groot=$na(@groot@("graph"))
 d counts(groot)
 q
 ;
hashpars(input,pairs)
 n kbaii
 i input'["#" q  ;
 f kbaii=2:1:$l(input,"#") d  ;
 . n zp,zo,pred
 . s zp=$p(input,"#",kbaii)
 . s pred="tag"
 . s zo=zp
 . i zp[":" d  ;
 . . s pred=$p(zp,":",1)
 . . s zo=$e(zp,$f(zp,":"),$l(zp))
 . . i zo["%" s zo=$$URLDEC^VPRJRUT(.zo)
 . . ;w !,zo
 . . ;s zo=$p(zp,":",2)
 . i $g(pred)="" q  ;
 . i $g(zo)="" q  ;
 . s @pairs@(kbaii-1,pred,zo)=""
 q
 ;
stat(zf) ;
 n zstat,zcmd,zwhere
 s zcmd="""stat --format %f "_zf_" >./stat.txt"""
 zsy @zcmd
 s zwhere=$na(^tmp("kbaiweb","stat",1))
 n zok s zok=$$FTG^%ZISH("./","stat.txt",zwhere,3)
 q @zwhere
 ;
locate(zarg) ;
 q zarg
 ;
logrewr(from,to) ; log uri rewrite
 n dt,id,ln
 s dt=httplog("dt"),id=httplog("id")
 s ln=$g(^vprhttp("log",dt,$j,id,"rewrite","from"),0)+1
 s ^vprhttp("log",dt,$j,id,"rewrite","from",0)=ln
 s ^vprhttp("log",dt,$j,id,"rewrite",ln,"from")=$g(from)
 s ^vprhttp("log",dt,$j,id,"rewrite",ln,"to")=$g(to)
 q
rewrite(rtn) ; show all the rewrites in the log
 n zr,zrary
 n gtop,gbot
 d htmltb^%yottaweb(.gtop,.gbot,"search results for #"_arg)
 m @rtn=gtop
 d addto^%yottautl(rtn,"<h1>items not found</h1>") 
 s zr=$na(^vprhttp("log"))
 f  s zr=$q(@zr) q:zr=""  d  ;
 . i zr'["rewrite" q  ;
 . i zr'["from" q  ;
 . ;w !,zr
 . i $l(@zr)=1 q  ; the count
 . n title s title="not found - "_@zr
 . d match(@zr,"zrary")
 . d addto^%yottautl(rtn,"<p>"_@zr_"</p>")
 . ;d multout(.rtn,"zrary",title)
 k @rtn@(0)
 s HTTPRSP("mime")="text/html"
 s @rtn@($o(@rtn@(""),-1)+1)=gbot
 q
 ;
