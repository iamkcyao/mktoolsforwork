#today=$(date +"%y%m%d%H")
today=$(date -d "2 days ago" +"%Y%m%d")
today2=$(date -d "2 days ago" +"%Y_%m_%d")
today3=$(date +"%Y-%m-%d")
#today="20220122"

GameName="STSGL 聖天使美版"
FolderPath="/data0/stsgldata/nl"

echo "-----NAS ${GameName}----" >> ./NasDataCheck/nas-result-${today3}.log
echo "因時差關係，檢查前日上傳的檔案" >> ./NasDataCheck/nas-result-${today3}.log

GetDataFolder=$(ssh datachecker@192.168.120.252 "ls ${FolderPath} |tr -d '/'")
FolderName=(${GetDataFolder//,/ })
FolderCount=${#FolderName[@]}  ##取得陣列長度
for ((i=0; i<$FolderCount ;i++))
do
	if [ "${FolderName["$i"]}" = "stsgl-accountdb" ]
	then
	    GetFileCount=$(ssh datachecker@192.168.120.252 "ls ${FolderPath}/${FolderName["$i"]}/* |grep ${today2} |wc -l")
	    echo "${FolderName["$i"]} 今日新增 ${GetFileCount} 個檔案" >> ./NasDataCheck/nas-result-${today3}.log
#	    echo "${FolderName["$i"]} 今日新增 ${GetFileCount} 個檔案"
	else
	    GetFileCount2=$(ssh datachecker@192.168.120.252 "ls ${FolderPath}/${FolderName["$i"]}/* |grep ${today} |wc -l")
	    ##echo "${FolderName["$i"]} 今日新增 ${GetFileCount} 個檔案" >> ./NasDataCheck/nas-result-${today}.log
	    ##echo "${FolderName["$i"]} 今日新增 ${GetFileCount} 個檔案" >> ./NasDataCheck/sts-${today}.log
            echo "${FolderName["$i"]} 今日新增 ${GetFileCount2} 個檔案" >> ./NasDataCheck/nas-result-${today3}.log
            #echo "${FolderName["$i"]} 今日新增 ${GetFileCount2} 個檔案"
	fi
done

