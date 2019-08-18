#!/bin/bash
set -e

folder=$1
target=$2

echo "--------------------------"
echo "--------------------------"
echo "...ocrDocuments in folder"$folder

echo "...processing $folder"
cd $folder

function ocrFile()
{
#echo start
filename=$1
filenameBase=`basename $filename`
ocrmypdf -l deu --tesseract-timeout 5000 $filename $target/$filenameBase
rm -f $filename
}

export -f ocrFile


for fileEntry in $folder/*.pdf
do
  if [ -f "$fileEntry" ]; then
    echo "ocr $fileEntry"
    ocrFile $fileEntry
  fi
done


#renameFile /media/data/lala1/SCN_0051.pdf
