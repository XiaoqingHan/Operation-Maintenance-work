import sys
import os

#usage: python3 $0 neural.list result_dir

sn_dict = {}
for sn in open(sys.argv[1], 'r'):
    if len(sn) == 0:
        continue
    sn = sn.strip().split("_")[0]
    if sn not in sn_dict.keys():
        sn_dict[sn] = 1

rm_list = open("rm_result.list", 'w')
conserve_list = open("conserve_result.list", 'w')

for line in open(sys.argv[2]):
    result_dir = line.strip()
    result_dir_list = line.strip().split("/")[-1].split("_")
    sn = result_dir_list[0]
    if sn not in sn_dict.keys():
        rm_list.write(line)
        continue
    else:
        conserve_line = "{}\n".format(result_dir)
        conserve_list.write(conserve_line)

rm_list.close()
conserve_list.close()


#####
f = open("rm_result.list",'r')
tar_list = open("tar.list",'w')
rm_list = open("rm.list",'w')

lines = f.readlines()
for line in lines:
    line = line.strip('\n')
    backup_id = os.path.basename(line)
    a = str(backup_id)+".tar.gz"
    b = "tar -czf "+a+" "+line+"\n"
    tar_list.write(b)
    c = "rm -rf "+line+"\n"
    rm_list.write(c)

tar_list.close()
rm_list.close()


#####
dir = "/jdfssz1/ST_BIGDATA/Stereomics/USER/hanxiaoqing/tape/tape_220304/files"
for root,dirs,files in os.walk(dir):
    for file in files:
        print(os.path.join(root,file))
