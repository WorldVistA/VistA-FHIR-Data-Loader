%yottahtm	;gpl - agile web server ; 2/27/17 4:33pm
 ;;1.0;norelease;;feb 27, 2017;build 2
 ;
 ; Copyright (c) 2017-2018 George P. Lilly
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
 
