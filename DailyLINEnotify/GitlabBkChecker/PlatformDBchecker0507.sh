source ~/.bash_profile
#!/bin/bash
dblist="/root/larry/PlatformDBchecker/db.list"
shell_folder="/root/larry/PlatformDBchecker"
nowdate=$(date +"%Y-%m-%d") #今天上傳的檔案
nowdate2=$(date +"%Y_%m_%d") #今天備份的檔案
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
	TodayNasFileExist=$(ssh datachecker@192.168.120.252 "ls -l ${folderpath} | grep ${nowdate2}" |wc -l )
	TodayNasFileSize=$(ssh datachecker@192.168.120.252 "ls -l ${folderpath} | grep ${nowdate2}" |awk {'print $5'}) ##取得NAS檔案大小
	TodayNasFileSize2=$(ssh datachecker@192.168.120.252 "ls -lh ${folderpath}  | grep ${nowdate2}" |awk {'print $5'}) ##取得NAS檔案大小 易讀

    s3path=$(cat ${dblist} | sed -n "${i},1p" | awk {'print $3'})
    S3FileSize=$(aws s3 ls ${s3path} --profile niceplay-db-rsync | grep ${nowdate} | grep ${nowdate2} |awk {'print $3'}) ##取得S3檔案大小
    S3FileSize2=$(aws s3 ls ${s3path} --recursive --human-readable --summarize --profile niceplay-db-rsync | grep ${nowdate} | grep ${nowdate2} |awk {'print $3,$4'}) ##取得S3檔案大小(易讀)
    S3FileCount=$(aws s3 ls ${s3path} --profile niceplay-db-rsync | grep ${nowdate} | grep ${nowdate2} |wc -l) ##計算S3檔案數量

if [ ${S3FileCount} -gt 0 ]
then
	if [ ${S3FileSize} -eq ${TodayNasFileSize} ]
	then
        UploadOK=$(($UploadOK+1))
		echo " ${foldername}, 檔案大小 ${S3FileSize2} " >> ${shell_folder}/uploadok.log
    elif [ ${S3FileSize} -lt ${TodayNasFileSize} ]
	then
		result=`echo "scale=2; ${S3FileSize}/${TodayNasFileSize}*100" | bc`	
		echo " ${foldername} 備份檔正在上傳中 , 已完成 ${result}% "  >> ${shell_folder}/uploading.log
		NotUploadOK=$(($NotUploadOK+1))	
	fi
elif [ ${S3FileCount} -eq 0 ]
then
	NotUploadOK=$(($NotUploadOK+1))
	
	if [ ${TodayNasFileExist} -eq 0 ]
	then
		NasNotFound=$(($NasNotFound+1))
		echo " ${foldername} 尚未上傳至 NAS , 請確認排程 " >> ${shell_folder}/nasnotfound.log
	else
		echo " ${foldername} 尚未上傳至 S3 , 請稍後 " >> ${shell_folder}/notuploadok.log
	fi
fi
done

echo "${nowdate} 平台DB備份狀態" >> ${shell_folder}/nowstatus.log
echo "-----------------------------------------------" >> ${shell_folder}/nowstatus.log
nowupload=`ll ${shell_folder}/ |grep uploading|wc -l`
if [ ${nowupload} -eq 1 ]
then
echo "上傳中" >> ${shell_folder}/nowstatus.log
cat ${shell_folder}/uploading.log >> ${shell_folder}/nowstatus.log
echo "-----------------------------------------------" >> ${shell_folder}/nowstatus.log
else
    continue
fi

notuploadok=`ll ${shell_folder}/ |grep notuploadok|wc -l`
if [ ${UploadOK} -lt ${ListNum} ]
then
    echo "待上傳" >> ${shell_folder}/nowstatus.log
    cat ${shell_folder}/notuploadok.log >> ${shell_folder}/nowstatus.log
else
        continue
fi

if [ ${NasNotFound} -gt 0 ]
then
    echo "待上傳至NAS" >> ${shell_folder}/nowstatus.log
    cat ${shell_folder}/nasnotfound.log >> ${shell_folder}/nowstatus.log
    echo "-----------------------------------------------" >> ${shell_folder}/nowstatus.log
else
        continue
fi
#echo "已完成" >> ${shell_folder}/nowstatus.log
if [ ${UploadOK} -eq ${ListNum} ]
then
    echo " 上傳 s3 完成" >> ${shell_folder}/nowstatus.log
else
    continue
fi
    #cat ${shell_folder}/uploadok.log >> ${shell_folder}/nowstatus.log
    echo "-----------------------------------------------" >> ${shell_folder}/nowstatus.log
    echo "全部檔案數 ${ListNum} 個 , 已完成 ${UploadOK} 個 , 待完成 ${NotUploadOK} 個 " >> ${shell_folder}/nowstatus.log

