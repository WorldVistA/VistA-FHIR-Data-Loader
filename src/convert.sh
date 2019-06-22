mv ./_wd.m SYNWD.m
mv ./_wdcsv.m SYNCSV.m
mv ./_wdgraph.m SYNGRAF.m
perl -pi -e 's/^%wd\(17.040801/^XTMP\("SYNGRAPH"/g' *.m
perl -pi -e 's/%wd/SYNGRAF/g' *.m
