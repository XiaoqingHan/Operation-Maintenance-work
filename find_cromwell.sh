### find cromwell，$1 is SN or task number

#!/bin/bash

grep $1 /path/logs/server.stdout.2023* | grep current | tail -5 > log

ip=`tail -1 log | awk -F ',' '{print $5}'`
flow=`tail -1 log | awk -F ',' '{print $4}'`
id=`tail -1 log | awk -F ',' '{print $6}'`
#id="`awk -F ',' '{print $6}' log`"

if [ "$ip" == 'rocks7' ] && [ "$flow" != 'spatialRNAvisualization_v2' ];then
        if [ "$flow" == 'Backup_Data_rsync' ];then
                echo "the task at the stage of backup"
        elif [ "$flow" == 'Backup_Data_rsync_Local' ];then
                echo "the task at the stage of backup_to_local"
        else
                echo `/cromwell-executions/$flow/${id%?}`
        fi
elif [[ "$ip" == 'auto' ]] && [[ "$flow" != 'spatialRNAvisualization_v2' ]];then
        if [ "$flow" == 'Backup_Data_rsync' ];then
                echo "the task at the stage of backup"
        elif [ "$flow" == 'Backup_Data_rsync_Local' ];then
                echo "the task at the stage of backup_to_local"
        else
                echo `/cromwell-executions/$flow/${id%?}`
        fi
elif [[ "$ip" == 'autob' ]] && [[ "$flow" != 'spatialRNAvisualization_v2' ]];then
        if [ "$flow" == 'Backup_Data_rsync' ];then
                echo "the task at the stage of backup"
        elif [ "$flow" == 'Backup_Data_rsync_Local' ];then
                echo "the task at the stage of backup_to_local"
        else
                echo `/cromwell-executions/$flow/${id%?}`
        fi
elif [[ "$ip" == 'rocks7' ]] && [[ "$flow" == 'spatialRNAvisualization_v2' ]];then
        echo `/spatialRNAvisualization/${id%?}`
elif [[ "$ip" == 'auto' ]] && [[ "$flow" == 'spatialRNAvisualization_v2' ]];then
        echo `/spatialRNAvisualization/${id%?}`
elif [[ "$ip" == 'autob' ]] && [[ "$flow" == 'spatialRNAvisualization_v2' ]];then
        echo `/spatialRNAvisualization/${id%?}`
fi
