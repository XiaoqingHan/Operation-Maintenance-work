### find cromwell，$1 is SN or task number

#!/bin/bash

grep $1 /ldfssz1/ST_BIGDATA/USER/st_bigdata/workspace/web_app/dist/logs/server.stdout.2023* | grep current | tail -5 > log

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
                echo `/ldfssz1/ST_BIGDATA/USER/st_bigdata/workspace/CromwellLog/192.168.60.7/cromwell-executions/$flow/${id%?}`
        fi
elif [[ "$ip" == 'auto' ]] && [[ "$flow" != 'spatialRNAvisualization_v2' ]];then
        if [ "$flow" == 'Backup_Data_rsync' ];then
                echo "the task at the stage of backup"
        elif [ "$flow" == 'Backup_Data_rsync_Local' ];then
                echo "the task at the stage of backup_to_local"
        else
                echo `/ldfssz1/ST_BIGDATA/USER/st_bigdata/workspace/CromwellLog/10.225.5.11/cromwell-executions/$flow/${id%?}`
        fi
elif [[ "$ip" == 'autob' ]] && [[ "$flow" != 'spatialRNAvisualization_v2' ]];then
        if [ "$flow" == 'Backup_Data_rsync' ];then
                echo "the task at the stage of backup"
        elif [ "$flow" == 'Backup_Data_rsync_Local' ];then
                echo "the task at the stage of backup_to_local"
        else
                echo `/ldfssz1/ST_BIGDATA/USER/st_bigdata/workspace/CromwellLog/10.225.5.11_b/cromwell-executions/$flow/${id%?}`
        fi
elif [[ "$ip" == 'rocks7' ]] && [[ "$flow" == 'spatialRNAvisualization_v2' ]];then
        echo `/ldfssz1/ST_BIGDATA/USER/st_bigdata/workspace/CromwellLog/192.168.60.7/cromwell-executions/spatialRNAvisualization/${id%?}`
elif [[ "$ip" == 'auto' ]] && [[ "$flow" == 'spatialRNAvisualization_v2' ]];then
        echo `/ldfssz1/ST_BIGDATA/USER/st_bigdata/workspace/CromwellLog/10.225.5.11/cromwell-executions/spatialRNAvisualization/${id%?}`
elif [[ "$ip" == 'autob' ]] && [[ "$flow" == 'spatialRNAvisualization_v2' ]];then
        echo `/ldfssz1/ST_BIGDATA/USER/st_bigdata/workspace/CromwellLog/10.225.5.11_b/cromwell-executions/spatialRNAvisualization/${id%?}`
fi
