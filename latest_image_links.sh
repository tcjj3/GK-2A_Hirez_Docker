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
else
rm -f ${LatestImagesLinksDir}/LatestFullDisk.jpg
rm -f ${LatestImagesLinksDir}/LatestFullDisk.txt
fi

LinkPath=`ls -l "${LatestImagesDir}/LatestFullDisk.jpg" | grep "^l" | awk '{print $NF}'`
if [ "${LinkPath}" != "${FullDisk_FilePath}" ]; then
[ -L "${LatestImagesDir}/LatestFullDisk.jpg" ] && rm -f "${LatestImagesDir}/LatestFullDisk.jpg" > /dev/null 2>&1
ln -s "${FullDisk_FilePath}" "${LatestImagesDir}/LatestFullDisk.jpg" > /dev/null 2>&1
fi
VritualFilePath=`cat "${LatestImagesDir}/LatestFullDisk.txt" | head -n 1`
if [ "${VritualFilePath}" != "${FullDisk_VritualFilePath}" ]; then
echo "${FullDisk_VritualFilePath}" > "${LatestImagesDir}/LatestFullDisk.txt"
fi
else
if [ -L "${LatestImagesDir}/LatestFullDisk.jpg" ]; then
rm -f "${LatestImagesDir}/LatestFullDisk.jpg" > /dev/null 2>&1
fi
if [ -f "${LatestImagesDir}/LatestFullDisk.txt" ]; then
rm -f "${LatestImagesDir}/LatestFullDisk.txt" > /dev/null 2>&1
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
else
rm -f ${LatestImagesLinksDir}/LatestFullDisk-fc.jpg
rm -f ${LatestImagesLinksDir}/LatestFullDisk-fc.txt
fi

LinkPath=`ls -l "${LatestImagesDir}/LatestFullDisk-fc.jpg" | grep "^l" | awk '{print $NF}'`
if [ "${LinkPath}" != "${FullDisk_Coloured_FilePath}" ]; then
[ -L "${LatestImagesDir}/LatestFullDisk-fc.jpg" ] && rm -f "${LatestImagesDir}/LatestFullDisk-fc.jpg" > /dev/null 2>&1
ln -s "${FullDisk_Coloured_FilePath}" "${LatestImagesDir}/LatestFullDisk-fc.jpg" > /dev/null 2>&1
fi
VritualFilePath=`cat "${LatestImagesDir}/LatestFullDisk-fc.txt" | head -n 1`
if [ "${VritualFilePath}" != "${FullDisk_Coloured_VritualFilePath}" ]; then
echo "${FullDisk_Coloured_VritualFilePath}" > "${LatestImagesDir}/LatestFullDisk-fc.txt"
fi
else
if [ -L "${LatestImagesDir}/LatestFullDisk-fc.jpg" ]; then
rm -f "${LatestImagesDir}/LatestFullDisk-fc.jpg" > /dev/null 2>&1
fi
if [ -f "${LatestImagesDir}/LatestFullDisk-fc.txt" ]; then
rm -f "${LatestImagesDir}/LatestFullDisk-fc.txt" > /dev/null 2>&1
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
else
rm -f ${LatestImagesLinksDir}/LatestMerged.gif
rm -f ${LatestImagesLinksDir}/LatestMerged.txt
fi

LinkPath=`ls -l "${LatestImagesDir}/LatestMerged.gif" | grep "^l" | awk '{print $NF}'`
if [ "${LinkPath}" != "${MergedFilePath}" ]; then
[ -L "${LatestImagesDir}/LatestMerged.gif" ] && rm -f "${LatestImagesDir}/LatestMerged.gif" > /dev/null 2>&1
ln -s "${MergedFilePath}" "${LatestImagesDir}/LatestMerged.gif" > /dev/null 2>&1
fi
VritualFilePath=`cat "${LatestImagesDir}/LatestMerged.txt" | head -n 1`
if [ "${VritualFilePath}" != "${MergedVritualFilePath}" ]; then
echo "${MergedVritualFilePath}" > "${LatestImagesDir}/LatestMerged.txt"
fi
else
if [ -L "${LatestImagesDir}/LatestMerged.gif" ]; then
rm -f "${LatestImagesDir}/LatestMerged.gif" > /dev/null 2>&1
fi
if [ -f "${LatestImagesDir}/LatestMerged.txt" ]; then
rm -f "${LatestImagesDir}/LatestMerged.txt" > /dev/null 2>&1
fi
fi











