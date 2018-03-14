#!/bin/bash

# determine the path to this script.
THIS_SCRIPT_PATH="${BASH_SOURCE[0]}"
if [ -h "${THIS_SCRIPT_PATH}" ]; then
    while [ -h "${THIS_SCRIPT_PATH}" ]; do
        THIS_SCRIPT_PATH=`readlink "${THIS_SCRIPT_PATH}"`
    done
fi
pushd . > /dev/null
cd `dirname ${THIS_SCRIPT_PATH}` > /dev/null
export myPath=`pwd`;
popd  > /dev/null


pListName="com.finishline.wifi.toggle.plist"
pList="${myPath}/${pListName}"
pListDest=~/Library/LaunchAgents/"$pListName"
toggleScript="${myPath}/wifi-toggle.sh"
errorTxt="ERROR! Something went wrong. Talk to Smola! (csmola@finishline.com or ext. 4654)"


# replace path to toggle script in plist and place in LaunchAgents folder
sed "s:<string>~</string>:<string>$toggleScript</string>:" "$pList" > "$pListDest" && {

    echo "Successfully placed LaunchAgent! About to enable. You MAY be prompted for your network password."

    launchctl load "$pListDest" || sudo launchctl load "$pListDest" && {
        echo "Launch Agent loaded! Your wifi will now toggle off/on when wired/not wired, respectively!"
    } || {
        echo "${errorTxt} [loading]"
    }
} || {
    echo "${errorTxt} [placing]"
}
