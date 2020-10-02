#!/usr/bin/ksh


echo "Making sample Book categories..."
utils/mkcat.pl  > sample_data/cats.sql

echo "Making sample Books..."
utils/mkbooks.pl > sample_data/books.sql

echo "Making Read Only Snapshots and Refesh Group..."
utils/make_ss.ksh
