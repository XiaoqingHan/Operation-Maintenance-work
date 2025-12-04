# crontab -l  timed task

0 */1 * * * cd /jdfssz1/ST_BIGDATA/Stereomics/USER/hanxiaoqing/warning/v3/ && bash stereo.sh >> /jdfssz1/ST_BIGDATA/Stereomics/USER/hanxiaoqing/warning/v3/mycron/$(date +"\%Y-\%m-\%d").log;


##### stereo.sh, v3 system

#!/bin/bash
source /etc/profile
source ~/.bashrc

### queue in sge
wait_sge="$(qstat -q stereo.q -u "*" |  awk  '{print $5}' | grep 'qw' | wc -l)"
running="$(qstat -q stereo.q -u "*" |  awk  '{print $5}' | grep 'r' | wc -l)"
sge=$(($wait_sge+$running))
#sge="$(qstat -q stereo.q -u "*" |  awk  '{print $5}' | wc -l)"
#queue=$((sge-2))
#r_wait=`awk 'BEGIN{printf "%.2f%\n",('$wait_sge'/'$queue')*100}'`
#r_run=`awk 'BEGIN{printf "%.2f%\n",('$running'/'$queue')*100}'`
#echo "waiting ratio : "$r_wait
#if [[ $queue -lt 1 ]];then
#    echo "$queue=0"
#fi

### queue in system
year=$(date +%Y)
month=$(date +%m)
echo "The input data comes from: "$year"-"$month
wait_sys=$(awk -F ' ' '{print $10}' /ldfssz1/ST_BIGDATA/USER/st_bigdata/outdumpinfo/$year"-"$month | grep "waiting" | wc -l)
queue=$(($wait_sys+$sge))
wait_all=$((wait_sge+$wait_sys))
r_wait=`awk 'BEGIN{printf "%.2f%\n",('$wait_all'/'$queue')*100}'`
r_run=`awk 'BEGIN{printf "%.2f%\n",('$running'/'$queue')*100}'`

#echo "sge queue length: "$sge
echo "waiting num in sge: "$wait_sge
echo "waiting num in system : "$wait_sys
echo "total wait num : "$wait_all
echo "running num : "$running
echo "total queue length: "$queue
echo "wait ratio : "$r_wait
echo "running ratio : "$r_run

if [[ $wait_all -ge 300 ]];then
        echo "waiting num : $wait_all"  |  mail -s "too many waiting tasks in queue" hanxiaoqing@genomics.cn
fi

### disk
disk_level1=$(lfs quota -gh ST_BIGDATA /zfssz2/ST_AUTO/autoanalysis/)
#disk_level1=$(lfs quota -gh ST_BIGDATA /ldfssz4/tmpfs/ST_BIGDATA/auto_analysis/P20Z10200N0157/null/)
echo "disk level 1 : "$disk_level1
used=$(lfs quota -gh ST_BIGDATA /zfssz2/ST_AUTO/Stereomics/ | awk -F ' ' '{print $1}' | sed -n '4p')
used=${used%%T}
quota=$(lfs quota -gh ST_BIGDATA /zfssz2/ST_AUTO/Stereomics/ | awk -F ' ' '{print $2}' | sed -n '4p')
quota=${quota%%T}
rest1=$(echo "$quota - $used"|bc)
echo "the remaining quota of disk1 is : "$rest1"T"
warn1=`awk 'BEGIN{printf "%.2f%\n",('$used'/'$quota')*100}'`
#echo $warn1
warn2=${warn1%%%}
#echo $warn2
if [[ $(echo "$warn2 >= 90.0"|bc) -eq 1 ]];then
         echo "disk utilization $warn1;  remaining quota $rest1" | mail -s "Warning! disk level 1 status" hanxiaoqing@genomics.cn
fi

disk_level2=$(df -h /jdfssz2/ST_BIGDATA)
echo "disk level 2 : "$disk_level2
warn3=$(df -h /jdfssz2/ST_BIGDATA | awk -F ' ' '{print $5}' | sed -n '2p')
#echo $warn3
warn4=${warn3%%%}
#echo $warn4
rest2=$(df -h /jdfssz2/ST_BIGDATA | awk -F ' ' '{print $4}' | sed -n '2p')
echo "the remaining quota of disk2 is : "$rest2
if [[ $warn4 -ge 98 ]];then
        echo "disk utilization $warn3;  remaining quota $rest2" | mail -s "Warning！disk level 2 status" hanxiaoqing@genomics.cn
fi

echo "-------"



##### stomics.sh, v4 system

#!/bin/bash

### queue in sge
wait_sge="$(qstat -q stomics.q -u "*" |  awk  '{print $5}' | grep 'qw' | wc -l)"
running="$(qstat -q stomics.q -u "*" |  awk  '{print $5}' | grep 'r' | wc -l)"
sge=$(($wait_sge+$running))
#sge="$(qstat -q stereo.q -u "*" |  awk  '{print $5}' | wc -l)"
#queue=$((sge-2))
#r_wait=`awk 'BEGIN{printf "%.2f%\n",('$wait_sge'/'$queue')*100}'`
#r_run=`awk 'BEGIN{printf "%.2f%\n",('$running'/'$queue')*100}'`
#echo "waiting ratio : "$r_wait
#if [[ $queue -lt 1 ]];then
#    echo "$queue=0"
#fi

### queue in system
java -jar /ldfssz1/ST_BI/USER/bigdata_autoanalysis/script/StatApi.jar "start=2021-12-20&end=2021-12-22" szprd stat.tsv
awk -F " " '{print $1,$2,$3,$18,19}' stat.tsv > task.tsv
#wait_sys=$(awk -F ' ' '{print $10}' /ldfssz1/ST_BIGDATA/USER/st_bigdata/outdumpinfo/2021-12 | grep "waiting" | wc -l)
#queue=$(($wait_sys+$sge))
#wait_all=$((wait_sge+$wait_sys))
#r_wait=`awk 'BEGIN{printf "%.2f%\n",('$wait_all'/'$queue')*100}'`
#r_run=`awk 'BEGIN{printf "%.2f%\n",('$running'/'$queue')*100}'`

#echo "sge queue length: "$sge
#echo "waiting num in sge: "$wait_sge
#echo "waiting num in system : "$wait_sys
#echo "total wait num : "$wait_all
#echo "running num : "$running
#echo "total queue length: "$queue
#echo "wait ratio : "$r_wait
#echo "running ratio : "$r_run

#if [[ $wait_all -ge 5 ]];then
#       echo "waiting num : $wait_all" |  mail -s "too many waiting tasks in queue" hanxiaoqing@genomics.cn
#fi

### disk
disk_level1=$(lfs quota -gh ST_BIGDATA /zfssz2/ST_AUTO/Stereomics/)
echo "disk level 1 : "$disk_level1
used=$(lfs quota -gh ST_BIGDATA /zfssz2/ST_AUTO/Stereomics/ | awk -F ' ' '{print $1}' | sed -n '4p')
used=${used%%T}
quota=$(lfs quota -gh ST_BIGDATA /zfssz2/ST_AUTO/Stereomics/ | awk -F ' ' '{print $2}' | sed -n '4p')
quota=${quota%%T}
warn1=`awk 'BEGIN{printf "%.2f%\n",('$used'/'$quota')*100}'`
#echo $warn1
warn2=${warn1%%%}
#echo $warn2
if [[ $(echo "$warn2 >= 90.0"|bc) -eq 1 ]];then
         echo "disk utilization $warn1" | mail -s "Warning! disk level 1 status" hanxiaoqing@genomics.cn
fi

disk_level2=$(df -h /jdfssz2/ST_BIGDATA)
echo "disk level 2 : "$disk_level2
warn3=$(df -h /jdfssz2/ST_BIGDATA | awk -F ' ' '{print $5}' | sed -n '2p')
#echo $warn3
warn4=${warn3%%%}
#echo $warn4
if [[ $warn4 -ge 90 ]];then
        echo "disk utilization $warn3" | mail -s "Warning！disk level 2 status" hanxiaoqing@genomics.cn
fi
