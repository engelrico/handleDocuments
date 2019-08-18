#!/bin/bash
set -e

folder=$1
target=$2

echo "--------------------------"
echo "--------------------------"
echo "...renameFile"
echo "...give all scans a uniqe name"
echo "...processing $folder"
cd $folder

function renameFile()
{
#echo start
filename=$1
#echo "##$filename##"
part1=`md5sum $filename | cut -d" " -f1`
if [ -z "$part1" ]; then
#    echo "VAR is not empty"
     exit 5
fi
#echo $part1
part2=`stat -c%y $filename | cut -c 1-10`
if [ -z "$part1" ]; then
#    echo "VAR is not empty"
     exit 5
fi
part2=${part2//-}
#echo $part2
finalFileName=$part2"_"$part1
mv -f $filename $target/$finalFileName.pdf
}
export -f renameFile


for fileEntry in $folder/SCN*
do
  if [ -f "$fileEntry" ]; then
    echo "Processing $fileEntry"
    renameFile $fileEntry
  fi

done


#renameFile /media/data/lala1/SCN_0051.pdf
