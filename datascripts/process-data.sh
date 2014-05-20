#
# instructions:
# 
# use from cilib/rdata
#     (not from cilib/rdata/scripts)
#

echo "copying all txt files from ~/cilib/data..."
cp ~/cilib/data/*txt .
echo "creating tmp dir..."
mkdir tmp
echo "making txt files writable, moving to tmp..."
chmod a+w *.txt
mv *.txt tmp
echo "copying scripts to tmp"
cp datascripts/*.sh tmp
cd tmp
echo "running scripts on data:"
echo "   removing hashed-out lines..."
./remove-hashes.sh
echo "   removing iteration numbers from data..."
./remove-iteration-numbers.sh
echo "   splitting fitness and diversity into new files..."
./split-fitness-and-diversity.sh
echo "removing old files"...
rm *.txt
cd ..
echo "moving data to finaldata/..."
mv tmp/*.rdata rdata/.
echo "renaming data to [alg][pop][prob][dim][div|fit]..."
rename -f 's/\.rdata//' rdata/*.rdata
rename -f 's/\.txt//' rdata/*
echo "removing tmp..."
rm -rf tmp
echo "done."

