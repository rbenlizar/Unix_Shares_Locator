#!/bin/dash

 

#test for OS

OSversion=$(lsb_release -i)

declare -a OS

for i in $OSversion;do

    OS+=($i)

done

OSname=${OS[2]}

echo 'This Unix System was recognized as: '$OSname

        sysName=$(uname -n)

        date=$(date)

        home=$(echo $SSH_CLIENT | awk '{ print $1}')

        echo $home

 

        echo -e 'This file was created by' $home on $date '\n' > ~/Documents/$sysName'_shares'.txt

        echo -e '\n Samba Shares Found \n' >> ~/Documents/$sysName'_shares'.txt

        echo -e 'Folder| Owner| Group| Perrmissions| Group Members| \n' >> ~/Documents/$sysName'_shares'.txt

       

case "$OSname" in

    F*)

# checking to see if samba is installed

    samba=$(smbd --version)

    if grep -qE ".*[0-9].*" <<<$samba; then

        declare -a shareCollect

        declare -a shareFolder

        declare -a shareName

        declare -a groupItems

        declare -a groupOutPut

        declare -a nfsCollect

        declare -a getMembers

        declare -A shareFindings

        declare -A NFSFindings

# listing ALL* shares known to the machine

        smbshares=$(smbtree)

 

        for i in $smbshares; do

            shareCollect+=($i)

        done

 

        sLen=${#shareCollect[@]}

# separating the sharename from the directory format given from smbtree command

        for ((i=0; i<$sLen; i++));do

            if grep -E '.*\LOCALHOST\.*' <<< ${shareCollect[$i]}; then

                shareFolder+=(${shareCollect[$i]})

            fi

 

        done

 

        sfLen=${#shareFolder[@]}

        for ((i=0;i<sfLen;i++));do

            IFS='\' read -ra ADDR <<< "${shareFolder[$i]}"

            for x in "${ADDR[@]}"; do

                    shareName+=($x)

            done

        done

 

        for i in ${shareName[@]}; do

            if grep -v '^L' <<<$i ;then

                if grep -v '^I' <<<$i; then

                    sambaShare=$i

                   

                

#start the process of gathering the attributes of the share folder

                    groupInfo=$(getfacl /$sambaShare)   

                    for g in $groupInfo;do

                        groupItems+=($g)

                    done

                    gLen=${#groupItems[@]}

                    for ((i=0;i<$gLen;i++));do

                        if grep '.*owner:.*'<<<${groupItems[$i]};then

                            owner=${groupItems[$i+1]}

                           

                        fi

                    done

                    shareFindings[$i,3]=$sambaShare

                    shareFindings[$i,1]=$owner

                    for t in $groupInfo;do

                              if grep -E 'group:[a-z].*:r' <<<$t; then

                            groupOutPut+=($t)

   

                              fi

                        done

                        gOPLen=${#groupOutPut[@]}

                   

                        for ((i=0;i<$gOPLen;i++)); do

 

#separating output by':' and storing into local array for further processing

                          IFS=':' read -ra GRP <<< "${groupOutPut[i]}"

                        getMembers=$(getent group ${GRP[1]})

                        if [[ $gOPLen == 0 ]]; then

                            groupName="N/A"

                        else

                            groupName=${GRP[1]}

                        fi

                        groupPermissions=${GRP[2]}

                        IFS=':' read -ra Mem <<< "$getMembers"

                        groupMembers=${Mem[3]}

                        done

                    shareFindings[$i,0]=$groupName

                        shareFindings[$i,3]=$groupPermissions

                        shareFindings[$i,2]=$groupMembers

                    for ((i=0;i<${#shareFindings[@]}/5;i++));do

                            echo ${shareFindings[@]} >> ~/Documents/$sysName'_shares'.txt

                    done

                    unset shareCollect

                    unset shareFolder

                    unset shareName

                    unset groupItems

                    unset groupOutPut

                    unset nfsCollect

                    unset getMembers

                    unset shareFindings

                   

                fi

            fi

        done

       

 

        

 

    else

          echo Samba is not installed!!!

    fi

 

echo -e '\n \n NFS Shares Found \n' >> ~/Documents/$sysName'_shares'.txt

echo -e 'Folder| Owner| Group| Perrmissions| Group Members| \n' >> ~/Documents/$sysName'_shares'.txt

#start of searching for NFS Shares and loging them

        nfsShare=$(showmount -e 127.0.0.1)

        for i in $nfsShare; do

            if grep '^/.*' <<<$i;then

                nfsCollect+=($i)

            fi

        done

        for ((i=0;i<${#nfsCollect[@]};i++)); do

            nfsShareName=${nfsCollect[$i]}

                    groupInfo=$(getfacl /$nfsShareName)   

                    for g in $groupInfo;do

                        groupItems+=($g)

                    done

                    gLen=${#groupItems[@]}

                    for ((r=0;r<$gLen;r++));do

                        if grep '.*owner:.*'<<<${groupItems[$r]};then

                            owner=${groupItems[$r+1]}

                           

                        fi

                    done

                    NFSFindings[$i,4]=$nfsShareName   

                    NFSFindings[$i,1]=$owner

            for t in $groupInfo;do

                      if grep -E 'group:[a-z].*:r' <<<$t; then

                    groupOutPut+=($t)

   

                      fi

                done

                gOPLen=${#groupOutPut[@]}

            for ((i=0;i<$gOPLen;i++)); do

#separating output by':' and storing into local array for further processing

 

                          IFS=':' read -ra GRP <<< "${groupOutPut[i]}"

                    getMembers=$(getent group ${GRP[1]})

                    groupName=${GRP[1]}   

                    groupPermissions=${GRP[2]}

                    IFS=':' read -ra Mem <<< "$getMembers"

                    groupMembers=${Mem[3]}

                    done

                    NFSFindings[$i,2]=$groupName

                        NFSFindings[$i,3]=$groupPermissions

                        NFSFindings[$i,0]=$groupMembers

                    for ((i=0;i<${#NFSFindings[@]}/5;i++));do

                            echo ${NFSFindings[@]} >> ~/Documents/$sysName'_shares'.txt

                    done

                    unset groupItems

                    unset groupOutPut

                    unset nfsCollect

                    unset getMembers

                    unset NFSFindings

        done;;

##############################################################################################################################################################################

#Line Break

##############################################################################################################################################################################

    R*)

    # checking to see if samba is installed

    samba=$(smbd --version)

    if grep -qE ".*[0-9].*" <<<$samba; then

        declare -a shareCollect

        declare -a shareFolder

        declare -a shareName

        declare -a groupItems

        declare -a groupOutPut

        declare -a nfsCollect

        declare -a getMembers

        declare -A shareFindings

        declare -A NFSFindings

# listing ALL* shares known to the machine

        smbshares=$(smbtree)

 

        for i in $smbshares; do

            shareCollect+=($i)

        done

 

        sLen=${#shareCollect[@]}

# separating the sharename from the directory format given from smbtree command

        for ((i=0; i<$sLen; i++));do

            if grep -E '.*\LOCALHOST\.*' <<< ${shareCollect[$i]}; then

                shareFolder+=(${shareCollect[$i]})

            fi

 

        done

 

        sfLen=${#shareFolder[@]}

        for ((i=0;i<sfLen;i++));do

            IFS='\' read -ra ADDR <<< "${shareFolder[$i]}"

            for x in "${ADDR[@]}"; do

                    shareName+=($x)

            done

        done

 

        for i in ${shareName[@]}; do

            if grep -v '^L' <<<$i ;then

                if grep -v '^I' <<<$i; then

                    sambaShare=$i

                   

                

#start the process of gathering the attributes of the share folder

                    groupInfo=$(getfacl /$sambaShare)   

                    for g in $groupInfo;do

                        groupItems+=($g)

                    done

                    gLen=${#groupItems[@]}

                    for ((i=0;i<$gLen;i++));do

                        if grep '.*owner:.*'<<<${groupItems[$i]};then

                            owner=${groupItems[$i+1]}

                           

                        fi

                    done

                    shareFindings[$i,3]=$sambaShare

                    shareFindings[$i,1]=$owner

                    for t in $groupInfo;do

                              if grep -E 'group:[a-z].*:r' <<<$t; then

                            groupOutPut+=($t)

   

                              fi

                        done

                        gOPLen=${#groupOutPut[@]}

                   

                        for ((i=0;i<$gOPLen;i++)); do

 

#separating output by':' and storing into local array for further processing

                          IFS=':' read -ra GRP <<< "${groupOutPut[i]}"

                        getMembers=$(getent group ${GRP[1]})

                        if [[ $gOPLen == 0 ]]; then

                            groupName="N/A"

                        else

                            groupName=${GRP[1]}

                        fi

                        groupPermissions=${GRP[2]}

                        IFS=':' read -ra Mem <<< "$getMembers"

                        groupMembers=${Mem[3]}

                        done

                    shareFindings[$i,0]=$groupName

                        shareFindings[$i,3]=$groupPermissions

                        shareFindings[$i,2]=$groupMembers

                    for ((i=0;i<${#shareFindings[@]}/5;i++));do

                            echo ${shareFindings[@]} >> ~/Documents/$sysName'_shares'.txt

                    done

                    unset shareCollect

                    unset shareFolder

                    unset shareName

                    unset groupItems

                    unset groupOutPut

                    unset nfsCollect

                    unset getMembers

                    unset shareFindings

                   

                fi

            fi

        done

       

 

        

 

    else

          echo Samba is not installed!!!

    fi

 

echo -e '\n \n NFS Shares Found \n' >> ~/Documents/$sysName'_shares'.txt

echo -e 'Folder| Owner| Group| Perrmissions| Group Members| \n' >> ~/Documents/$sysName'_shares'.txt

#start of searching for NFS Shares and loging them

        nfsShare=$(showmount -e 127.0.0.1)

        for i in $nfsShare; do

            if grep '^/.*' <<<$i;then

                nfsCollect+=($i)

            fi

        done

        for ((i=0;i<${#nfsCollect[@]};i++)); do

            nfsShareName=${nfsCollect[$i]}

                    groupInfo=$(getfacl /$nfsShareName)   

                    for g in $groupInfo;do

                        groupItems+=($g)

                    done

                    gLen=${#groupItems[@]}

                    for ((r=0;r<$gLen;r++));do

                        if grep '.*owner:.*'<<<${groupItems[$r]};then

                            owner=${groupItems[$r+1]}

                           

                        fi

                    done

                    NFSFindings[$i,4]=$nfsShareName   

                    NFSFindings[$i,1]=$owner

            for t in $groupInfo;do

                      if grep -E 'group:[a-z].*:r' <<<$t; then

                    groupOutPut+=($t)

   

                      fi

                done

                gOPLen=${#groupOutPut[@]}

            for ((i=0;i<$gOPLen;i++)); do

#separating output by':' and storing into local array for further processing

 

                          IFS=':' read -ra GRP <<< "${groupOutPut[i]}"

                    getMembers=$(getent group ${GRP[1]})

                    groupName=${GRP[1]}   

                    groupPermissions=${GRP[2]}

                    IFS=':' read -ra Mem <<< "$getMembers"

                    groupMembers=${Mem[3]}

                    done

                    NFSFindings[$i,2]=$groupName

                        NFSFindings[$i,3]=$groupPermissions

                        NFSFindings[$i,0]=$groupMembers

                    for ((i=0;i<${#NFSFindings[@]}/5;i++));do

                            echo ${NFSFindings[@]} >> ~/Documents/$sysName'_shares'.txt

                    done

                    unset groupItems

                    unset groupOutPut

                    unset nfsCollect

                    unset getMembers

                    unset NFSFindings

        done;;

##############################################################################################################################################################################

#Line Break

##############################################################################################################################################################################

    U*)

# checking to see if samba is installed

        samba=$(smbd --version)

        if grep -qE ".*[0-9].*" <<<$samba; then

 

# declairing all arrays for shares

        declare -a shareOutPut

        declare -A shareName

        declare -a groupOutPut

 

 

# Quering the samba shares to get folders that are shared

        shares=$(ls -l /var/lib/samba/usershares)

        for i in $shares;do

# Storing all relevant information about folders shared on target computer

            if grep -v '^-.*'<<<$i | grep -v '[0-9]';then

                  shareOutPut+=($i)

              fi

        done

 

 

# declaring variables for iterating through output of samba shares

        sf=4

        o=1

        sLen=${#shareOutPut[@]}

 

 

# Starting process finding ACL settings and the groups associated to each shared folder

        for ((i=0;i<$sLen;i++));do

                owner=${shareOutPut[@]:$o:1}

                shareFolder=${shareOutPut[@]:$sf:1}

            shareName[$i,4]=$shareFolder

                shareName[$i,1]=$owner

                aclInfo=$(getfacl /var/lib/samba/usershares/$shareFolder)

                for t in $aclInfo;do

                      if grep -E 'group:[a-z].*:r' <<<$t; then

                    groupOutPut+=($t)

   

                      fi

                done

                gOPLen=${#groupOutPut[@]}

                for ((i=0;i<$gOPLen;i++)); do

#     separating output by':' and storing into local array for further processing

                  IFS=':' read -ra ADDR <<< "${groupOutPut[i]}"

            getMembers=$(getent group ${ADDR[1]})

            groupName=${ADDR[1]}

            groupPermissions=${ADDR[2]}

            IFS=':' read -ra Mem <<< "$getMembers"

            groupMembers=${Mem[3]}

                done

# Storing all used variables into a table for reporting

   

    

                shareName[$i,0]=$groupName

                shareName[$i,3]=$groupPermissions

                shareName[$i,2]=$groupMembers

   

                if [ ${shareOutPut[$i]}=="" ]; then

                      break

                else

                      let o=o+4

                      let sf=sf+4

                fi

        done

 

# collecting computer name for the naming of the file

        sysName=$(uname -n)

        date=$(date)

 

        echo -e 'This file was created by' $home on $date '\n' > ~/Documents/$sysName'_shares'.txt

        echo -e 'Folder| Owner| Group| Perrmissions| Group Members| \n' > ~/Documents/$sysName'_shares'.txt

        for ((i=0;i<${#shareName[@]}/5;i++));do

                echo ${shareName[@]} >> ~/Documents/$sysName'_shares'.txt

        done

 

    else

         echo Samba is not installed!!!

    fi

#start of searching for NFS Shares and loging them

        nfsShare=$(showmount -e 127.0.0.1)

        for i in $nfsShare; do

            if grep '^/.*' <<<$i;then

                nfsCollect+=($i)

            fi

        done

        for ((i=0;i<${#nfsCollect[@]};i++)); do

            nfsShareName=${nfsCollect[$i]}

                    groupInfo=$(getfacl /$nfsShareName)   

                    for g in $groupInfo;do

                        groupItems+=($g)

                    done

                    gLen=${#groupItems[@]}

                    for ((r=0;r<$gLen;r++));do

                        if grep '.*owner:.*'<<<${groupItems[$r]};then

                            owner=${groupItems[$r+1]}

                        fi

                    done

                    for t in $groupInfo;do

                              if grep -E 'group:[a-z].*:r' <<<$t; then

                            groupOutPut+=($t)

   

                              fi

                        done

                        gOPLen=${#groupOutPut[@]}

                        for ((i=0;i<$gOPLen;i++)); do

#separating output by':' and storing into local array for further processing

                          IFS=':' read -ra GRP <<< "${groupOutPut[i]}"

                    getMembers=$(getent group ${GRP[1]})

                    groupName=${GRP[1]}

                    groupPermissions=${GRP[2]}

                    IFS=':' read -ra Mem <<< "$getMembers"

                    groupMembers=${Mem[3]}

                        done

        done;;

##############################################################################################################################################################################

#Line Break

##############################################################################################################################################################################

    M*)

        echo Mac OS is not currently supported by this script;;

##############################################################################################################################################################################

#Line Break

##############################################################################################################################################################################

    *)

        echo Unable to determine Operating System;;

esac


