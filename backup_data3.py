import os

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
