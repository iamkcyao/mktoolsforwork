#today=$(date +"%y%m%d%H")
today=$(date +"%Y%m%d")
today2=$(date +"%Y-%m-%d")
#today="2020-08-16"
GameName="WARTW 超英雄特工"
FolderPath="/data0/wartwdata/"

echo "-----NAS ${GameName}----" >> ./NasDataCheck/nas-result-${today2}.log

GetDataFolder=$(ssh datachecker@192.168.120.252 "ls ${FolderPath}/ |tr -d '/'")
FolderName=(${GetDataFolder//,/ })
FolderCount=${#FolderName[@]}  ##取得陣列長度
for ((i=0; i<$FolderCount ;i++))
do
    GetFileCount=$(ssh datachecker@192.168.120.252 "ls ${FolderPath}/${FolderName["$i"]}/ |grep ${today} |wc -l")
    echo "${FolderName["$i"]} 今日新增 ${GetFileCount} 個檔案" >> ./NasDataCheck/nas-result-${today2}.log
done
