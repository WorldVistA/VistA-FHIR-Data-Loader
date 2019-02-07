SYNDHPMAPO ; terminology mapping
 ;;0.2;VISTA SYN DATA LOADER;;Feb 07, 2019
 ;
 ; under construction
ALLRGY() ;
 S D=" (disorder)"
 S N=""
 F  S N=$O(^ZZFJFALL(N)) Q:N=""  D
 .
