now_date=`date "+%Y_%m_%d"`
now_time=`date +%s`

# zf3
ls -w 1 /zfssz3/ST_BIGDATA/autoanalysis_backup_2/P20Z10200N0157/*/*_backup/logs/stdout > stdout_all.list
# jd2
ls -w 1 /jdfssz2/ST_BIGDATA/Stereomics/autoanalysis_backup/P20Z10200N0157/null/*_backup/logs/stdout > stdout_all.list
echo ${now_date}_removed.list

# get remove list:
for stdout in `cat stdout_all.list`
do
        final_change_time=`stat -c "%Z" $stdout`
        time_interval=$[$now_time-$final_change_time]
        if [ $time_interval -ge 7776000 ];then # 5184000 seconds, 60 days
                project_directory=`dirname \`dirname $stdout\``
                echo $project_directory >> ${now_date}_removed.list
        fi
done
