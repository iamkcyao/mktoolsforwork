#today=$(date +"%y%m%d%H")
today=$(date -d "2 days ago" +"%Y%m%d")
today2=$(date -d "2 days ago" +"%Y_%m_%d")
#today=$(date +"%Y%m%d")
#today2=$(date +"%Y_%m_%d")
today3=$(date +"%Y-%m-%d")
#today="20220122"

GameName="STS 聖天使台版"
FolderPath="/data0/stsdata/nl/"

echo "-----NAS ${GameName}----" >> ./NasDataCheck/nas-result-${today3}.log
echo "檔案太大 檢查前日檔案" >> ./NasDataCheck/nas-result-${today3}.log

GetDataFolder=$(ssh datachecker@192.168.120.252 "ls ${FolderPath} |tr -d '/'")
FolderName=(${GetDataFolder//,/ })
FolderCount=${#FolderName[@]}  ##取得陣列長度
for ((i=0; i<$FolderCount ;i++))
do
	if [ "${FolderName["$i"]}" = "sts-accountndb-m" ]
	then
	    GetFileCount=$(ssh datachecker@192.168.120.252 "ls ${FolderPath}/${FolderName["$i"]}/* |grep ${today2} |wc -l")
	    echo "${FolderName["$i"]} 今日新增 ${GetFileCount} 個檔案" >> ./NasDataCheck/nas-result-${today3}.log
	else
	    GetFileCount2=$(ssh datachecker@192.168.120.252 "ls ${FolderPath}/${FolderName["$i"]}/* |grep ${today} |wc -l")
	    #echo "${FolderName["$i"]} 今日新增 ${GetFileCount} 個檔案" >> ./NasDataCheck/nas-result-${today}.log
	    #echo "${FolderName["$i"]} 今日新增 ${GetFileCount} 個檔案" >> ./NasDataCheck/sts-${today}.log
            echo "${FolderName["$i"]} 今日新增 ${GetFileCount2} 個檔案" >> ./NasDataCheck/nas-result-${today3}.log
	fi
done

