source ~/.bash_profile
#!/bin/bash
dblist="/root/larry/GitlabBkChecker/db.list"
shell_folder="/root/larry/GitlabBkChecker"
nowdate=$(date +"%Y-%m-%d") #今天上傳的檔案
nowdate2=$(date +"%Y_%m_%d") #今天備份的檔案
nowdate3=$(date +"%m/%d/%Y") #今天備份的檔案
#nowdate2="2019_08_27"
yesterday=$(date -d yesterday +"%Y-%m-%d")
yesterday2=$(date -d yesterday +"%Y_%m_%d")
#yesterday2="2019_08_26"

date=$(date '+%Y-%m-%d %H:%M:%S')

rm -f ${shell_folder}/uploadok.log
rm -f ${shell_folder}/uploading.log
rm -f ${shell_folder}/nasnotfound.log
rm -f ${shell_folder}/notuploadok.log
rm -f ${shell_folder}/nowstatus.log

ListNum=$(cat ${dblist} |wc -l)


UploadOK=0    #已完成標記
NotUploadOK=0 #待完成標記
NasNotFound=0 #還沒上傳至NAS標記

for ((i=1; i<=${ListNum} ;i++))
do
	folderpath=$(cat ${dblist} | sed -n "${i},1p" | awk {'print $2'})
	foldername=$(cat ${dblist} | sed -n "${i},1p" | awk {'print $1'})
	#TodayNasFileExist=$(ssh datachecker@192.168.120.252 "ls -l ${folderpath} | grep ${nowdate2}" |wc -l )
	TodayNasFileName=$(ssh root@192.168.120.252 "find ${folderpath}/* -newermt "${nowdate3}"")
	#TodayNasFileSize=$(ssh datachecker@192.168.120.252 "ls -l ${folderpath} | grep ${nowdate2}" |awk {'print $5'}) ##取得NAS檔案大小
	#TodayNasFileSize2=$(ssh datachecker@192.168.120.252 "ls -lh ${folderpath}  | grep ${nowdate2}" |awk {'print $5'}) ##取得NAS檔案大小 易讀

    gcspath=$(cat ${dblist} | sed -n "${i},1p" | awk {'print $3'})
    gcs_file_Size=$(gsutil ls -l ${gcspath} | grep ${nowdate}  |awk {'print $1'}) ##取得S3檔案大小
    gcs_file_Size2=$(gsutil ls -l -h ${gcspath} | grep ${nowdate} |awk {'print $1,$2'}) ##取得S3檔案大小(易讀)
    get_gcs_filename=$(gsutil ls -l -h ${gcspath} | grep ${nowdate} |awk {'print $1,$2'})
#    gcs_file_Count=$(gsutil ls -l ${gcspath} | grep ${nowdate} |wc -l) ##計算S3檔案數量


if [ ${gcs_file_Count} -gt 0 ]
then
        UploadOK=$(($UploadOK+1))
		echo " ${foldername}, 檔案大小 ${gcs_file_Size2} " >> ${shell_folder}/uploadok.log
	fi
if [ ${gcs_file_Count} -eq 0 ]
then
	NotUploadOK=$(($NotUploadOK+1))
		echo " ${foldername} 尚未上傳至 GCP , 請稍後 " >> ${shell_folder}/notuploadok.log
fi
done

echo "${nowdate} GitLab備份狀態" >> ${shell_folder}/nowstatus.log
echo "-----------------------------------------------" >> ${shell_folder}/nowstatus.log
nowupload=`ll ${shell_folder}/ |grep uploading|wc -l`

notuploadok=`ll ${shell_folder}/ |grep notuploadok|wc -l`
if [ ${notuploadok} -eq 1 ]
then
    echo "待上傳" >> ${shell_folder}/nowstatus.log
    cat ${shell_folder}/notuploadok.log >> ${shell_folder}/nowstatus.log
else
        continue
fi

#echo "已完成" >> ${shell_folder}/nowstatus.log
if [ ${UploadOK} -eq ${ListNum} ]
then
    cat ${shell_folder}/uploadok.log >> ${shell_folder}/nowstatus.log
    echo " 上傳 GCS 完成" >> ${shell_folder}/nowstatus.log
else
    continue
fi
    #cat ${shell_folder}/uploadok.log >> ${shell_folder}/nowstatus.log
    echo "-----------------------------------------------" >> ${shell_folder}/nowstatus.log
    echo "全部檔案數 ${ListNum} 個 , 已完成 ${UploadOK} 個 , 待完成 ${NotUploadOK} 個 " >> ${shell_folder}/nowstatus.log
