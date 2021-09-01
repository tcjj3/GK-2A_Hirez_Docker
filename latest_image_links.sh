#!/bin/bash






ImagesPath="/usr/local/bin/xrit-rx/src/received/LRIT"


LatestImagesDir="/usr/local/bin/xrit-rx/src/LatestImages"
LatestImagesLinksDir="${ImagesPath}"






[ ! -f "/tmp/showlatestimages" ] && exit 0






[ ! -d "${ImagesPath}" ] && mkdir -p "${ImagesPath}"

[ ! -d "${LatestImagesDir}" ] && mkdir -p "${LatestImagesDir}"
[ ! -d "${LatestImagesLinksDir}" ] && mkdir -p "${LatestImagesLinksDir}"








FullDisk_Date=`ls ${ImagesPath}/ | sed -n '/^[0-9][0-9]*$/p' | sort -ru | head -n 1`
[ ! -z "${FullDisk_Date}" ] && FullDisk_Filename=`ls ${ImagesPath}/${FullDisk_Date}/FD/ | awk -F "_IR" '{print $2}' | sort -ru | head -n 1`
[ ! -z "${FullDisk_Filename}" ] && FullDisk_FullFilename=`ls ${ImagesPath}/${FullDisk_Date}/FD/ | grep "${FullDisk_Filename}$" | head -n 1`
[ ! -z "${FullDisk_FullFilename}" ] && FullDisk_VritualFilePath="/${FullDisk_Date}/FD/${FullDisk_FullFilename}"
[ ! -z "${FullDisk_FullFilename}" ] && FullDisk_FilePath="${ImagesPath}/${FullDisk_Date}/FD/${FullDisk_FullFilename}"






FullDisk_Coloured_Date=`ls ${ImagesPath}/COLOURED/ | sed -n '/^[0-9][0-9]*$/p' | sort -ru | head -n 1`
[ ! -z "${FullDisk_Coloured_Date}" ] && FullDisk_Coloured_Filename=`ls ${ImagesPath}/COLOURED/${FullDisk_Coloured_Date}/ | awk -F "_IR" '{print $2}' | sort -ru | head -n 1`
[ ! -z "${FullDisk_Coloured_Filename}" ] && FullDisk_Coloured_FullFilename=`ls ${ImagesPath}/COLOURED/${FullDisk_Coloured_Date}/ | grep "${FullDisk_Coloured_Filename}$" | head -n 1`
[ ! -z "${FullDisk_Coloured_FullFilename}" ] && FullDisk_Coloured_VritualFilePath="/COLOURED/${FullDisk_Coloured_Date}/${FullDisk_Coloured_FullFilename}"
[ ! -z "${FullDisk_Coloured_FullFilename}" ] && FullDisk_Coloured_FilePath="${ImagesPath}/COLOURED/${FullDisk_Coloured_Date}/${FullDisk_Coloured_FullFilename}"






MergedVritualFilePath=`ls ${ImagesPath}/COLOURED/ | sort -ru | while read LINE; do Filename=$(ls ${ImagesPath}/COLOURED/$LINE/Merged/ | sort -ru | head -n 1); if [ ! -z "${Filename}" ]; then echo "/COLOURED/${LINE}/Merged/${Filename}"; break; fi; done | head -n 1`
[ ! -z "${MergedVritualFilePath}" ] && MergedFilePath="${ImagesPath}${MergedVritualFilePath}"






Images_Date=`ls ${ImagesPath}/ | sed -n '/^[0-9][0-9]*$/p' | sort -ru | head -n 1`
[ ! -z "${Images_Date}" ] && LatestDirectory=`ls -t ${ImagesPath}/${Images_Date}/ | head -n 1`
[ ! -z "${LatestDirectory}" ] && LatestFilename=`ls -t ${ImagesPath}/${Images_Date}/${LatestDirectory}/ | head -n 1`

if [ ! -z "${LatestFilename}" ]; then
FullFileVritualPath="/${Images_Date}/${LatestDirectory}/${LatestFilename}"
FullFilePath="${ImagesPath}/${FullFileVritualPath}"

LatestFilename_fc="${LatestFilename}"
FullFilePath_fc=""
tmp=`echo "${LatestDirectory}" | grep "FD"`
if [ ! -z "${tmp}" ]; then
LatestFilename_fc=`echo "${LatestFilename}" | sed "s#.jpg#-fc.jpg#gi"`
FullFileVritualPath_fc="/COLOURED/${Images_Date}/${LatestFilename_fc}"
FullFilePath_fc="${ImagesPath}/${FullFileVritualPath_fc}"
if [ -f "${FullFilePath_fc}" ]; then
LatestFilename="${LatestFilename_fc}"
FullFileVritualPath="${FullFileVritualPath_fc}"
FullFilePath="${FullFilePath_fc}"
fi
fi
fi










#  Latest FullDisk

if [ ! -z "${FullDisk_FullFilename}" ]; then
if [ -f "/tmp/createlatestimageslinks" ]; then
if [ ! -f "${LatestImagesLinksDir}/LatestFullDisk.jpg" ]; then
#touch ${LatestImagesLinksDir}/LatestFullDisk.jpg > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestFullDisk.jpg
fi
if [ ! -f "${LatestImagesLinksDir}/LatestFullDisk.txt" ]; then
#touch ${LatestImagesLinksDir}/LatestFullDisk.txt > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestFullDisk.txt
fi
if [ ! -f "${LatestImagesLinksDir}/LatestFullDisk.json" ]; then
#touch ${LatestImagesLinksDir}/LatestFullDisk.json > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestFullDisk.json
fi
if [ ! -f "${LatestImagesLinksDir}/LatestFullDisk.js" ]; then
#touch ${LatestImagesLinksDir}/LatestFullDisk.js > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestFullDisk.js
fi
if [ ! -f "${LatestImagesLinksDir}/LatestFullDisk.htm" ]; then
#touch ${LatestImagesLinksDir}/LatestFullDisk.htm > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestFullDisk.htm
fi
else
if [ -f "${LatestImagesLinksDir}/LatestFullDisk.jpg" ]; then
rm -f "${LatestImagesLinksDir}/LatestFullDisk.jpg" > /dev/null 2>&1
fi
if [ -f "${LatestImagesLinksDir}/LatestFullDisk.txt" ]; then
rm -f "${LatestImagesLinksDir}/LatestFullDisk.txt" > /dev/null 2>&1
fi
if [ -f "${LatestImagesLinksDir}/LatestFullDisk.json" ]; then
rm -f "${LatestImagesLinksDir}/LatestFullDisk.json" > /dev/null 2>&1
fi
if [ -f "${LatestImagesLinksDir}/LatestFullDisk.js" ]; then
rm -f "${LatestImagesLinksDir}/LatestFullDisk.js" > /dev/null 2>&1
fi
if [ -f "${LatestImagesLinksDir}/LatestFullDisk.htm" ]; then
rm -f "${LatestImagesLinksDir}/LatestFullDisk.htm" > /dev/null 2>&1
fi
fi

LinkPath=`ls -l "${LatestImagesDir}/LatestFullDisk.jpg" | grep "^l" | awk '{print $NF}'`
if [ "${LinkPath}" != "${FullDisk_FilePath}" ]; then
[ -L "${LatestImagesDir}/LatestFullDisk.jpg" ] && rm -f "${LatestImagesDir}/LatestFullDisk.jpg" > /dev/null 2>&1
ln -s "${FullDisk_FilePath}" "${LatestImagesDir}/LatestFullDisk.jpg" > /dev/null 2>&1
fi
VritualFilePath=`cat "${LatestImagesDir}/LatestFullDisk.txt" | head -n 1`
if [ "${VritualFilePath}" != "${FullDisk_VritualFilePath}" ]; then
echo "${FullDisk_VritualFilePath}" > "${LatestImagesDir}/LatestFullDisk.txt"

json_contents="{\"image\": \"${FullDisk_VritualFilePath}\"}"
echo "Callback_LatestFullDisk(${json_contents})" > "${LatestImagesDir}/LatestFullDisk.js"
[ -f "/tmp/latestfulldiskcallback" ] && LATESTFULLDISK_CALLBACK=`cat /tmp/latestfulldiskcallback | head -n 1`
if [ ! -z "${LATESTFULLDISK_CALLBACK}" ]; then
json_contents="${LATESTFULLDISK_CALLBACK}(${json_contents})"
fi
echo "${json_contents}" > "${LatestImagesDir}/LatestFullDisk.json"
fi

if [ ! -L "${LatestImagesDir}/LatestFullDisk.htm" ]; then
ln -s "/opt/LatestFullDisk.htm" "${LatestImagesDir}/LatestFullDisk.htm" > /dev/null 2>&1
fi
else
if [ -L "${LatestImagesDir}/LatestFullDisk.jpg" ]; then
rm -f "${LatestImagesDir}/LatestFullDisk.jpg" > /dev/null 2>&1
fi
if [ -f "${LatestImagesDir}/LatestFullDisk.txt" ]; then
rm -f "${LatestImagesDir}/LatestFullDisk.txt" > /dev/null 2>&1
fi
if [ -f "${LatestImagesDir}/LatestFullDisk.json" ]; then
rm -f "${LatestImagesDir}/LatestFullDisk.json" > /dev/null 2>&1
fi
if [ -f "${LatestImagesDir}/LatestFullDisk.js" ]; then
rm -f "${LatestImagesDir}/LatestFullDisk.js" > /dev/null 2>&1
fi
fi








#  Latest FullDisk Coloured

if [ ! -z "${FullDisk_Coloured_FullFilename}" ]; then
if [ -f "/tmp/createlatestimageslinks" ]; then
if [ ! -f "${LatestImagesLinksDir}/LatestFullDisk-fc.jpg" ]; then
#touch ${LatestImagesLinksDir}/LatestFullDisk-fc.jpg > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestFullDisk-fc.jpg
fi
if [ ! -f "${LatestImagesLinksDir}/LatestFullDisk-fc.txt" ]; then
#touch ${LatestImagesLinksDir}/LatestFullDisk-fc.txt > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestFullDisk-fc.txt
fi
if [ ! -f "${LatestImagesLinksDir}/LatestFullDisk-fc.json" ]; then
#touch ${LatestImagesLinksDir}/LatestFullDisk-fc.json > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestFullDisk-fc.json
fi
if [ ! -f "${LatestImagesLinksDir}/LatestFullDisk-fc.js" ]; then
#touch ${LatestImagesLinksDir}/LatestFullDisk-fc.js > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestFullDisk-fc.js
fi
if [ ! -f "${LatestImagesLinksDir}/LatestFullDisk-fc.htm" ]; then
#touch ${LatestImagesLinksDir}/LatestFullDisk-fc.htm > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestFullDisk-fc.htm
fi
else
if [ -f "${LatestImagesLinksDir}/LatestFullDisk-fc.jpg" ]; then
rm -f "${LatestImagesLinksDir}/LatestFullDisk-fc.jpg" > /dev/null 2>&1
fi
if [ -f "${LatestImagesLinksDir}/LatestFullDisk-fc.txt" ]; then
rm -f "${LatestImagesLinksDir}/LatestFullDisk-fc.txt" > /dev/null 2>&1
fi
if [ -f "${LatestImagesLinksDir}/LatestFullDisk-fc.json" ]; then
rm -f "${LatestImagesLinksDir}/LatestFullDisk-fc.json" > /dev/null 2>&1
fi
if [ -f "${LatestImagesLinksDir}/LatestFullDisk-fc.js" ]; then
rm -f "${LatestImagesLinksDir}/LatestFullDisk-fc.js" > /dev/null 2>&1
fi
if [ -f "${LatestImagesLinksDir}/LatestFullDisk-fc.htm" ]; then
rm -f "${LatestImagesLinksDir}/LatestFullDisk-fc.htm" > /dev/null 2>&1
fi
fi

LinkPath=`ls -l "${LatestImagesDir}/LatestFullDisk-fc.jpg" | grep "^l" | awk '{print $NF}'`
if [ "${LinkPath}" != "${FullDisk_Coloured_FilePath}" ]; then
[ -L "${LatestImagesDir}/LatestFullDisk-fc.jpg" ] && rm -f "${LatestImagesDir}/LatestFullDisk-fc.jpg" > /dev/null 2>&1
ln -s "${FullDisk_Coloured_FilePath}" "${LatestImagesDir}/LatestFullDisk-fc.jpg" > /dev/null 2>&1
fi
VritualFilePath=`cat "${LatestImagesDir}/LatestFullDisk-fc.txt" | head -n 1`
if [ "${VritualFilePath}" != "${FullDisk_Coloured_VritualFilePath}" ]; then
echo "${FullDisk_Coloured_VritualFilePath}" > "${LatestImagesDir}/LatestFullDisk-fc.txt"

json_contents="{\"image\": \"${FullDisk_Coloured_VritualFilePath}\"}"
echo "Callback_LatestFullDisk_fc(${json_contents})" > "${LatestImagesDir}/LatestFullDisk-fc.js"
[ -f "/tmp/latestfulldiskfccallback" ] && LATESTFULLDISKFC_CALLBACK=`cat /tmp/latestfulldiskfccallback | head -n 1`
if [ ! -z "${LATESTFULLDISKFC_CALLBACK}" ]; then
json_contents="${LATESTFULLDISKFC_CALLBACK}(${json_contents})"
fi
echo "${json_contents}" > "${LatestImagesDir}/LatestFullDisk-fc.json"
fi

if [ ! -L "${LatestImagesDir}/LatestFullDisk-fc.htm" ]; then
ln -s "/opt/LatestFullDisk-fc.htm" "${LatestImagesDir}/LatestFullDisk-fc.htm" > /dev/null 2>&1
fi
else
if [ -L "${LatestImagesDir}/LatestFullDisk-fc.jpg" ]; then
rm -f "${LatestImagesDir}/LatestFullDisk-fc.jpg" > /dev/null 2>&1
fi
if [ -f "${LatestImagesDir}/LatestFullDisk-fc.txt" ]; then
rm -f "${LatestImagesDir}/LatestFullDisk-fc.txt" > /dev/null 2>&1
fi
if [ -f "${LatestImagesDir}/LatestFullDisk-fc.json" ]; then
rm -f "${LatestImagesDir}/LatestFullDisk-fc.json" > /dev/null 2>&1
fi
if [ -f "${LatestImagesDir}/LatestFullDisk-fc.js" ]; then
rm -f "${LatestImagesDir}/LatestFullDisk-fc.js" > /dev/null 2>&1
fi
fi








#  Latest Merged

if [ ! -z "${MergedVritualFilePath}" ]; then
if [ -f "/tmp/createlatestimageslinks" ]; then
if [ ! -f "${LatestImagesLinksDir}/LatestMerged.gif" ]; then
#touch ${LatestImagesLinksDir}/LatestMerged.gif > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestMerged.gif
fi
if [ ! -f "${LatestImagesLinksDir}/LatestMerged.txt" ]; then
#touch ${LatestImagesLinksDir}/LatestMerged.txt > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestMerged.txt
fi
if [ ! -f "${LatestImagesLinksDir}/LatestMerged.json" ]; then
#touch ${LatestImagesLinksDir}/LatestMerged.json > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestMerged.json
fi
if [ ! -f "${LatestImagesLinksDir}/LatestMerged.js" ]; then
#touch ${LatestImagesLinksDir}/LatestMerged.js > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestMerged.js
fi
if [ ! -f "${LatestImagesLinksDir}/LatestMerged.htm" ]; then
#touch ${LatestImagesLinksDir}/LatestMerged.htm > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestMerged.htm
fi
else
if [ -f "${LatestImagesLinksDir}/LatestMerged.gif" ]; then
rm -f "${LatestImagesLinksDir}/LatestMerged.gif" > /dev/null 2>&1
fi
if [ -f "${LatestImagesLinksDir}/LatestMerged.txt" ]; then
rm -f "${LatestImagesLinksDir}/LatestMerged.txt" > /dev/null 2>&1
fi
if [ -f "${LatestImagesLinksDir}/LatestMerged.json" ]; then
rm -f "${LatestImagesLinksDir}/LatestMerged.json" > /dev/null 2>&1
fi
if [ -f "${LatestImagesLinksDir}/LatestMerged.js" ]; then
rm -f "${LatestImagesLinksDir}/LatestMerged.js" > /dev/null 2>&1
fi
if [ -f "${LatestImagesLinksDir}/LatestMerged.htm" ]; then
rm -f "${LatestImagesLinksDir}/LatestMerged.htm" > /dev/null 2>&1
fi
fi

LinkPath=`ls -l "${LatestImagesDir}/LatestMerged.gif" | grep "^l" | awk '{print $NF}'`
if [ "${LinkPath}" != "${MergedFilePath}" ]; then
[ -L "${LatestImagesDir}/LatestMerged.gif" ] && rm -f "${LatestImagesDir}/LatestMerged.gif" > /dev/null 2>&1
ln -s "${MergedFilePath}" "${LatestImagesDir}/LatestMerged.gif" > /dev/null 2>&1
fi
VritualFilePath=`cat "${LatestImagesDir}/LatestMerged.txt" | head -n 1`
if [ "${VritualFilePath}" != "${MergedVritualFilePath}" ]; then
echo "${MergedVritualFilePath}" > "${LatestImagesDir}/LatestMerged.txt"

json_contents="{\"image\": \"${MergedVritualFilePath}\"}"
echo "Callback_LatestMerged(${json_contents})" > "${LatestImagesDir}/LatestMerged.js"
[ -f "/tmp/latestmergedcallback" ] && LATESTMERGED_CALLBACK=`cat /tmp/latestmergedcallback | head -n 1`
if [ ! -z "${LATESTMERGED_CALLBACK}" ]; then
json_contents="${LATESTMERGED_CALLBACK}(${json_contents})"
fi
echo "${json_contents}" > "${LatestImagesDir}/LatestMerged.json"
fi

if [ ! -L "${LatestImagesDir}/LatestMerged.htm" ]; then
ln -s "/opt/LatestMerged.htm" "${LatestImagesDir}/LatestMerged.htm" > /dev/null 2>&1
fi
else
if [ -L "${LatestImagesDir}/LatestMerged.gif" ]; then
rm -f "${LatestImagesDir}/LatestMerged.gif" > /dev/null 2>&1
fi
if [ -f "${LatestImagesDir}/LatestMerged.txt" ]; then
rm -f "${LatestImagesDir}/LatestMerged.txt" > /dev/null 2>&1
fi
if [ -f "${LatestImagesDir}/LatestMerged.json" ]; then
rm -f "${LatestImagesDir}/LatestMerged.json" > /dev/null 2>&1
fi
fi








#  Latest Image

if [ ! -z "${LatestFilename}" ]; then
if [ -f "/tmp/createlatestimageslinks" ]; then
if [ ! -f "${LatestImagesLinksDir}/LatestImage.jpg" ]; then
#touch ${LatestImagesLinksDir}/LatestImage.jpg > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestImage.jpg
fi
if [ ! -f "${LatestImagesLinksDir}/LatestImage.txt" ]; then
#touch ${LatestImagesLinksDir}/LatestImage.txt > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestImage.txt
fi
if [ ! -f "${LatestImagesLinksDir}/LatestImage.json" ]; then
#touch ${LatestImagesLinksDir}/LatestImage.json > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestImage.json
fi
if [ ! -f "${LatestImagesLinksDir}/LatestImage.js" ]; then
#touch ${LatestImagesLinksDir}/LatestImage.js > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestImage.js
fi
if [ ! -f "${LatestImagesLinksDir}/LatestImage.htm" ]; then
#touch ${LatestImagesLinksDir}/LatestImage.htm > /dev/null 2>&1
echo "This is just a link file and would delete anytime, so please do not save anything in it." > ${LatestImagesLinksDir}/LatestImage.htm
fi
else
if [ -f "${LatestImagesLinksDir}/LatestImage.jpg" ]; then
rm -f "${LatestImagesLinksDir}/LatestImage.jpg" > /dev/null 2>&1
fi
if [ -f "${LatestImagesLinksDir}/LatestImage.txt" ]; then
rm -f "${LatestImagesLinksDir}/LatestImage.txt" > /dev/null 2>&1
fi
if [ -f "${LatestImagesLinksDir}/LatestImage.json" ]; then
rm -f "${LatestImagesLinksDir}/LatestImage.json" > /dev/null 2>&1
fi
if [ -f "${LatestImagesLinksDir}/LatestImage.js" ]; then
rm -f "${LatestImagesLinksDir}/LatestImage.js" > /dev/null 2>&1
fi
if [ -f "${LatestImagesLinksDir}/LatestImage.htm" ]; then
rm -f "${LatestImagesLinksDir}/LatestImage.htm" > /dev/null 2>&1
fi
fi

LinkPath=`ls -l "${LatestImagesDir}/LatestImage.jpg" | grep "^l" | awk '{print $NF}'`
if [ "${LinkPath}" != "${FullFilePath}" ]; then
[ -L "${LatestImagesDir}/LatestImage.jpg" ] && rm -f "${LatestImagesDir}/LatestImage.jpg" > /dev/null 2>&1
ln -s "${FullFilePath}" "${LatestImagesDir}/LatestImage.jpg" > /dev/null 2>&1
fi
VritualFilePath=`cat "${LatestImagesDir}/LatestImage.txt" | head -n 1`
if [ "${VritualFilePath}" != "${FullFileVritualPath}" ]; then
echo "${FullFileVritualPath}" > "${LatestImagesDir}/LatestImage.txt"

json_contents="{\"image\": \"${FullFileVritualPath}\"}"
echo "Callback_Latest_Image(${json_contents})" > "${LatestImagesDir}/LatestImage.js"
[ -f "/tmp/latestimagecallback" ] && LatestImage_CALLBACK=`cat /tmp/latestimagecallback | head -n 1`
if [ ! -z "${LatestImage_CALLBACK}" ]; then
json_contents="${LatestImage_CALLBACK}(${json_contents})"
fi
echo "${json_contents}" > "${LatestImagesDir}/LatestImage.json"
fi

if [ ! -L "${LatestImagesDir}/LatestImage.htm" ]; then
ln -s "/opt/LatestImage.new.htm" "${LatestImagesDir}/LatestImage.htm" > /dev/null 2>&1
fi
else
if [ -L "${LatestImagesDir}/LatestImage.jpg" ]; then
rm -f "${LatestImagesDir}/LatestImage.jpg" > /dev/null 2>&1
fi
if [ -f "${LatestImagesDir}/LatestImage.txt" ]; then
rm -f "${LatestImagesDir}/LatestImage.txt" > /dev/null 2>&1
fi
if [ -f "${LatestImagesDir}/LatestImage.json" ]; then
rm -f "${LatestImagesDir}/LatestImage.json" > /dev/null 2>&1
fi
if [ -f "${LatestImagesDir}/LatestImage.js" ]; then
rm -f "${LatestImagesDir}/LatestImage.js" > /dev/null 2>&1
fi
fi











