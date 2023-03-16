#today=$(date +"%y%m%d%H")
today=$(date +"%Y-%m-%d")

#today=$(date -d '-1 day' +"%Y-%m-%d")
yesterday=$(date -d '-1 day' +"%Y-%m-%d")

#today="2020-08-16"
GameName="WJGL 無盡的使命:美版"
FolderPath="/data0/wjgldata/"

echo "-----NAS ${GameName}----" >> ./NasDataCheck/nas-result-${today}.log

GetDataFolder=$(ssh datachecker@192.168.120.252 "ls ${FolderPath}/ |tr -d '/'")
FolderName=(${GetDataFolder//,/ })
FolderCount=${#FolderName[@]}  ##取得陣列長度
for ((i=0; i<$FolderCount ;i++))
do
    GetFileCount=$(ssh datachecker@192.168.120.252 "ls ${FolderPath}${FolderName["$i"]} |grep ${yesterday} |wc -l")
if [ ${GetFileCount} -eq 0 ]  
then
    echo "本日 ${FolderName["$i"]} 服，沒有新增備份，可能已經關閉或故障，請與原廠或ＰＭ確認。" >> ./NasDataCheck/nas-result-${today}.log
        
else
    echo "${FolderName["$i"]} 今日新增 ${GetFileCount} 個檔案" >> ./NasDataCheck/nas-result-${today}.log
fi
done

