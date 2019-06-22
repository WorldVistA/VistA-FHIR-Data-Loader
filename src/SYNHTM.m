%yottahtm	;gpl - agile web server ; 2/27/17 4:33pm
 ;;1.0;norelease;;feb 27, 2017;build 2
 ;
 ;
 q
 ;
toppage(rtn,filter) ; build the starting page of hashtag counts
 ;
 n kbaii,gtop,gbot,table,groot,zcnt
 d htmltb2^%yottaweb(.gtop,.gbot,"#see query engine")
 s rtn=$na(^tmp("kbaiwsai",$j))
 k @rtn
 m @rtn=gtop
 s groot=$na(@$$setroot^%yottagr@("graph"))
 s table("title")="tags by count"
 s table("header",1)="tag"
 s table("header",2)="tag count"
 s kbaii="" s zcnt=0
 n k2
 f  s kbaii=$o(@groot@("tagbycount",kbaii),-1) q:kbaii=""  d  ;
 . s k2=""
 . f  s k2=$o(@groot@("tagbycount",kbaii,k2)) q:k2=""  d  ;
 . . n ztag
 . . s ztag=k2
 . . s zcnt=zcnt+1
 . . i zcnt>2000 q  ; max rows
 . . s table(zcnt,1)="<a href=""see/tag:"_ztag_""">"_"#"_ztag_"</a>"
 . . s table(zcnt,2)=kbaii
 d genhtml^%yottautl(rtn,"table")
 k @rtn@(0)
 s HTTPRSP("mime")="text/html"
 s @rtn@($o(@rtn@(""),-1)+1)=gbot
 q
 ;
 
