#cp ./_wd.m SYNWD.m
cp ./_wdcsv.m SYNCSV.m
cp ./_wdgraph.m SYNGRAF.m
perl -pi -e 's/\^%wd\(17.040801/\^XTMP\("SYNGRAPH"/g' SYN*.m
perl -pi -e 's/%wdgraph/SYNGRAF/g' SYN*.m
perl -pi -e 's/%wdcsv/SYNCSV/g' SYN*.m
perl -pi -e 's/%wd/SYNWD/g' SYN*.m
perl -pi -e 's/decode\^%webjson/decode\^SYNJSOND/g' SYN*.m
perl -pi -e 's/DECODE\^%webjson/decode\^SYNJSOND/g' SYN*.m
perl -pi -e 's/encode\^%webjson/encode\^SYNJSONE/g' SYN*.m
perl -pi -e 's/ENCODE\^%webjson/encode\^SYNJSONE/g' SYN*.m
perl -pi -e 's/%webutils/SYNWEBUT/g' SYN*.m
perl -pi -e 's/%webjsonTestData1/SYNJSOT1/g' SYN*.m
perl -pi -e 's/%webjsonTestData2/SYNJSOT2/g' SYN*.m
perl -pi -e 's/%webjsonEncodeTest/SYNJSOET/g' SYN*.m
perl -pi -e 's/%webjsonDecodeTest/SYNJSODT/g' SYN*.m
perl -pi -e 's/%webjsonEncode/SYNJSONE/g' SYN*.m
perl -pi -e 's/%webjsonDecode/SYNJSOND/g' SYN*.m
perl -pi -e 's/\^%webjson/SYNJSON/g' SYN*.m

