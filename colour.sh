#!/bin/bash





[ -f /tmp/nocolour ] && exit 0







# System environment
export DOTNET_ROOT=/usr/local/bin/dotnet
export PATH=$PATH:/usr/local/bin/dotnet







# Receive Lock
Dashboard_Server="127.0.0.1:1692"
tmp_Dashboard_Server=""
if [ -f /tmp/dashboardserver ]; then
tmp_Dashboard_Server=`cat /tmp/dashboardserver | head -n 1`
[ ! -z "$tmp_Dashboard_Server" ] && Dashboard_Server="$tmp_Dashboard_Server"
fi

if [ ! -f /tmp/noreceive ]; then
vcid_check=`curl -s http://${Dashboard_Server}/api/current/vcid | grep "\"vcid\": 63"`
while [ -z "$vcid_check" ]; do
sleep 1
vcid_check=`curl -s http://${Dashboard_Server}/api/current/vcid | grep "\"vcid\": 63"`
done
else
if [ ! -z "$tmp_Dashboard_Server" ]; then
vcid_check=`curl -s http://${tmp_Dashboard_Server}/api/current/vcid | grep "\"vcid\": 63"`
while [ -z "$vcid_check" ]; do
sleep 1
vcid_check=`curl -s http://${tmp_Dashboard_Server}/api/current/vcid | grep "\"vcid\": 63"`
done
fi
fi







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









