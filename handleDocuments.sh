#!/bin/bash
set -e
#--------------------------------------------------------------
# handleDocuments - HOWitWorks
#--------------------------------------------------------------
#echo "step_1 renameFiles to unique fileNames from:"$folder_scan
#echo "step_2 ocr files from:"$folder_ocr
#echo "step_3 move files to targetFolders"

#--------------------------------------------------------------
# parameters - some folders
# idea:: outsource this path to an environmentFile (2gether with ansible?)
#--------------------------------------------------------------
folder_this=`dirname $0`
folder_root="/media/data/docs/000_STAGE/"
semaphore=$folder_root"handleDocuments.LOCK"
folder_scan=$folder_root"00_scan"
folder_ocr=$folder_root"10_ocr"
folder_ready=$folder_root"20_ready"
#folder_target="/media/cloud/public/docs/010_scans/"
folder_target="/media/data/docs/010_scans/"
folder_cloud="/media/cloud/public/docs/010_scans/"

#--------------------------------------------------------------

#--------------------------------------------------------------
# semaphore
#--------------------------------------------------------------
if [ -f "$semaphore" ]; then
#    echo "handleDocumentsProcess already running - EXIT"
    exit 1
fi
touch $semaphore
#--------------------------------------------------------------

# idea::maybe a fastpath here to get the file early available in the cloud
# give every file a uniqe name (md5sum and stuff like this)
$folder_this/uniqFileName.sh $folder_scan $folder_ocr
# ocr the files to make them searchable
$folder_this/ocrDocument.sh $folder_ocr $folder_ready
# move the files to the targetFolder
for fileEntry in $folder_ready/*.pdf
do
  if [ -f "$fileEntry" ]; then
    echo "move $fileEntry"
    cp -f $fileEntry $folder_cloud
    mv -f $fileEntry $folder_target
  fi
done

#sync to the cloud
echo "sync $folder_target to $folder_cloud"
# idea: later or hourly rsync --delete -a -e ssh $folder_target $folder_cloud
# idea: put the results as pushNotifications to the smartphone
# release the semaphore
rm -f $semaphore
#--------------------------------------------------------------
