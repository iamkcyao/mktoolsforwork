#today=$(date +"%y%m%d%H")
today=$(date +"%Y-%m-%d")
GameName="TSC 天神曲"
FolderPath="/data0/tscdata/10000"

echo "-----NAS ${GameName}----" >> ./NasDataCheck/nas-result-${today}.log

GetDataFolder=$(ssh datachecker@192.168.120.252 "ls ${FolderPath}/ |tr -d '/'")
FolderName=(${GetDataFolder//,/ })
FolderCount=${#FolderName[@]}  ##取得陣列長度
for ((i=0; i<$FolderCount ;i++))
do
    GetFileCount=$(ssh datachecker@192.168.120.252 "find ${FolderPath}/${FolderName[i]} -type f -mtime -1 |wc -l")
    echo "${FolderName["$i"]} 今日新增 ${GetFileCount} 個檔案" >> ./NasDataCheck/nas-result-${today}.log
done

