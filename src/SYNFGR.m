SYNFGR  ;ven/gpl - fhir loader utilities ; 2/23/18 5:51am
        ;;1.0;fhirloader;;oct 19, 2017;Build 2
        ;
        ; Authored by George P. Lilly 2017-2018
        ;
        q
               ;
resources(ary,lvl)      ; finds all the fhir resources and counts them up
        ; returns ary, passed by name
        ;
        n root s root=$$setroot^%wd("fhir-intake")
        n ien,rien
        s (ien,rien)=0
        f  s ien=$o(@root@(ien)) q:+ien=0  d  ;
        . s rien=0
        . f  s rien=$o(@root@(ien,"json","entry",rien)) q:+rien=0  d  ;
        . . n rtype,rtext,rcode
        . . s rtype=$g(@root@(ien,"json","entry",rien,"resource","resourceType"))
        . . q:rtype=""
        . . s @ary@(rtype)=$g(@ary@(rtype))+1
        . . q:$g(lvl)<2
        . . i rtype="Goal" d  ;
        . . . s rtext=$g(@root@(ien,"json","entry",rien,"resource","description","text"))
        . . . q:rtext=""
        . . . s @ary@(rtype,rtext)=$g(@ary@(rtype,rtext))+1
        . . i rtype="Observation" d  ;
        . . . s rtext=$g(@root@(ien,"json","entry",rien,"resource","category",1,"coding",1,"code"))
        . . . q:rtext=""
        . . . ;i rtext="procedure" b
        . . . s @ary@(rtype,rtext)=$g(@ary@(rtype,rtext))+1
        . . i rtype="Procedure" d  ;
        . . . s rtext=$g(@root@(ien,"json","entry",rien,"resource","code","text"))
        . . . q:rtext=""
        . . . s rcode=$g(@root@(ien,"json","entry",rien,"resource","code","coding",1,"code"))
        . . . q:rcode=""
        . . . s @ary@(rtype,rtext,rcode)=$g(@ary@(rtype,rtext,rcode))+1
        . . i rtype="DiagnosticReport" d  ;
        . . . s rtext=$g(@root@(ien,"json","entry",rien,"resource","code","coding",1,"display"))
        . . . q:rtext=""
        . . . s @ary@(rtype,rtext)=$g(@ary@(rtype,rtext))+1
        q
        ;
