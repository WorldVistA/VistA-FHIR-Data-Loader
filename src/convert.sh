#cp ./_wd.m SYNWD.m
cp ./_wdcsv.m SYNCSV.m
cp ./_wdgraph.m SYNGRAF.m
perl -pi -e 's/\^%wd\(17.040801/\^XTMP\("SYNGRAPH"/g' SYN*.m
perl -pi -e 's/%wdgraph/SYNGRAF/g' SYN*.m
perl -pi -e 's/%wdcsv/SYNCSV/g' SYN*.m
perl -pi -e 's/%wd/SYNWD/g' SYN*.m
