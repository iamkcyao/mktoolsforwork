#today=$(date +"%y%m%d%H")
today=$(date +"%Y-%m-%d")
GameName="MS 魔法學園"
FolderPath="/data0/msdata"

echo "-----NAS ${GameName}----" >> ./NasDataCheck/nas-result-${today}.log

GetDataFolder=$(ssh datachecker@192.168.120.252 "ls ${FolderPath}/ |tr -d '/'")
FolderName=(${GetDataFolder//,/ })
FolderCount=${#FolderName[@]}  ##取得陣列長度
for ((i=0; i<$FolderCount ;i++))
do
    GetFileCount=$(ssh datachecker@192.168.120.252 "ls ${FolderPath}/${FolderName["$i"]}/ |grep ${today} |wc -l")
    echo "${FolderName["$i"]} 今日新增 ${GetFileCount} 個檔案" >> ./NasDataCheck/nas-result-${today}.log
done

