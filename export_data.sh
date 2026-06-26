#!bin/bash

# $8 input parameters
cat /USER/st_bigdata/outdumpinfo/2022-05 | awk -F ' ' '{print $1,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13}' > out.csv
#awk '{if($4=="spatialRNAvisualization_v3" && $10=="2022-05-09"){print $0} else if($4=="spatialRNAvisualization_v2" && $10=="2022-05-09"){print $0} else if($4=="spatialRNAvisualization_cell" && $10=="2022-05-09"){print $0} else if ($4=="spatialRNAvisualization_develop" && $10=="2022-05-09"){print $0}}' out.csv > out_today.csv
awk -v date=$(date -d "-1 day" +%Y-%m-%d) '{if($3=="spatialRNAvisualization_v3" && $6==date){print $0} else if($3=="spatialRNAvisualization_v2" && $6==date){print $0} else if($3=="spatialRNAvisualization_cell" && $6==date){print $0} else if ($3=="spatialRNAvisualization_develop" && $6==date){print $0}}' out.csv > out_today.csv
ui
> cid.csv
> frac_bin200.csv

for f in `awk -F ' ' '{print $10}' out_today.csv`
do
    for ff in `find $f -name "00.fq"`; do
        mapped=$(cat ${ff}/*.stat | grep "mapped_reads" | cut -f 3 | tr -cd '[0-9.\n]' | awk '{sum += $1}; END{print sum/NR}')
        umi_filter=$(cat ${ff}/*.stat | grep "umi_filter_reads" | cut -f 3 | tr -cd '[0-9.\n]' | awk '{sum += $1}; END{print sum/NR}')
        CID=$(echo "$mapped - $umi_filter" | bc)
        if [[ $(echo "$CID <= 10.0"|bc) -eq 1 ]];then
            echo $CID"|疑似SN号错误" >> cid.csv
        elif [[ $(echo "$CID > 10.0"|bc) -eq 1 ]] && [[ $(echo "$CID <= 30.0"|bc) -eq 1 ]];then
            echo $CID"|疑似混样或样本污染" >> cid.csv
        else
            echo $CID >> cid.csv
        fi
    done
    for ff in `find $f -name "TissueCut.log"`; do
        fraction=$(grep "Fraction_MID_in_spots_under_tissue" $ff | cut -f 2 | tr -cd '[0-9.\n]')
        bin200=$(grep "Mean_Umi_per_spot" $ff | head -n 5 | tail -n 1 | awk -F ":" '{print $2}')
        if [[ $(echo "$fraction < 50.0"|bc) -eq 1 ]] && [[ $(echo "$bin200 < 5000"|bc) -eq 1 ]];then
            echo $fraction$bin200"|扩散系数高于50%且bin200MeanMID低于5k" >> frac_bin200.csv
        elif [[ $(echo "$fraction < 50.0"|bc) -eq 1 ]] && [[ $(echo "$bin200 >= 5000"|bc) -eq 1 ]];then
            echo $fraction$bin200"|扩散系数高于50%" >> frac_bin200.csv
        elif [[ $(echo "$fraction >= 50.0"|bc) -eq 1 ]] && [[ $(echo "$bin200 < 5000"|bc) -eq 1 ]];then
            echo $fraction$bin200"|bin200MeanMID低于5k" >> frac_bin200.csv
        else
            echo $fraction$bin200 >> frac_bin200.csv
    fi
    done
done

paste out_today.csv cid.csv frac_bin200.csv > out_info.csv
awk -F " " 'BEGIN {OFS=FS; print "sampleid correctSampleid autoName owner analysisStat createDate createTime finishDate finishTime analysisDir CIDrate(%) FractionMIDinSpotsUnderTissue(%) bin200MeanMID"} {print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13}' out_info.csv > out_final.csv

iconv out_final.csv -f UTF-8 -t GBK -o out_final.csv

sed 's/ /;/g' out_final.csv > daily.csv
