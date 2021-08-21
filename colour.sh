#!/bin/bash





# System environment
export DOTNET_ROOT=/usr/local/bin/dotnet
export PATH=$PATH:/usr/local/bin/dotnet







# Time Lock
vcid_check=`curl -s http://127.0.0.1:1692/api/current/vcid | grep "\"vcid\": 63"`
while [ -z "$vcid_check" ]; do
sleep 1
vcid_check=`curl -s http://127.0.0.1:1692/api/current/vcid | grep "\"vcid\": 63"`
done







# Vars
DATE="$1"
[ -z "$DATE" ] && DATE="$(date +%Y%m%d)"







# Colour
mkdir -p /tmp/sanchez_logs > /dev/null 2>&1
ln -s /tmp/sanchez_logs /usr/local/bin/sanchez/logs > /dev/null 2>&1


#/usr/local/bin/sanchez/Sanchez -t "#0070ba" \
#  -s "/usr/local/bin/xrit-rx/src/received/LRIT/${DATE}/FD/*.jpg" \
#  -m "/usr/local/bin/sanchez/Resources/Mask.jpg" \
#  -u "/usr/local/bin/sanchez/Resources/GK-2A/Underlay.jpg" \
#  -o "/usr/local/bin/xrit-rx/src/received/LRIT/COLOURED/${DATE}" > /dev/null 2>&1


#/usr/local/bin/sanchez/Sanchez -t "#0070ba" \
#  -s "/usr/local/bin/xrit-rx/src/received/LRIT/${DATE}/FD/*.jpg" \
#  -m "/usr/local/bin/sanchez/Resources/GK-2A/PristineMask.jpg" \
#  -u "/usr/local/bin/sanchez/Resources/GK-2A/Underlay-Hirez.jpg" \
#  -o "/usr/local/bin/xrit-rx/src/received/LRIT/COLOURED/${DATE}" > /dev/null 2>&1




Underlay_File="/usr/local/bin/sanchez/Resources/GK-2A/Underlay.jpg"
[ -f /tmp/underlay_hirez ] && Underlay_File="/usr/local/bin/sanchez/Resources/GK-2A/Underlay-Hirez.jpg"

Mask_File="/usr/local/bin/sanchez/Resources/Mask.jpg"
[ -f /tmp/pristinemask ] && Mask_File="/usr/local/bin/sanchez/Resources/GK-2A/PristineMask.jpg"

/usr/local/bin/sanchez/Sanchez -t "#0070ba" \
  -s "/usr/local/bin/xrit-rx/src/received/LRIT/${DATE}/FD/*.jpg" \
  -m "$Mask_File" \
  -u "$Underlay_File" \
  -o "/usr/local/bin/xrit-rx/src/received/LRIT/COLOURED/${DATE}" > /dev/null 2>&1







# Clear
#rm -rf /usr/local/bin/sanchez/logs > /dev/null 2>&1
rm -rf /tmp/sanchez_logs/* > /dev/null 2>&1









