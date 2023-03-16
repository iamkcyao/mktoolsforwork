#增加環境變數
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
folder="./Check-S3-Backup-Status"
today=$(date +"%Y-%m-%d")
find "./Check-S3-Backup-Status/Daily/" -name "*.log" -mtime +6 -exec rm -rf {} \;

sh ${folder}/ghkr-s3backup.sh
sh ${folder}/gh-s3backup.sh
sh ./GCSBackup-check.sh
sh ./NasDataCheck/NasCheck.sh

echo "Product ID：GHKR  Date：${today}" >> ${folder}/Daily/Daily-${today}.log
cat ${folder}/ghkr-s3backup/ghkr-s3backup-${today}.log >> ${folder}/Daily/Daily-${today}.log
echo "——————————————————————————————" >> ${folder}/Daily/Daily-${today}.log
cat ${folder}/ghkr-s3backup/ghkr-s3backup-compare-${today}.log >> ${folder}/Daily/Daily-${today}.log
echo "——————————————————————————————" >> ${folder}/Daily/Daily-${today}.log
echo "Product ID：GHT  Date：${today}" >> ${folder}/Daily/Daily-${today}.log
cat ${folder}/gh-s3backup/gh-s3backup-${today}.log >> ${folder}/Daily/Daily-${today}.log
echo "——————————————————————————————" >> ${folder}/Daily/Daily-${today}.log
cat ${folder}/gh-s3backup/gh-s3backup-compare-${today}.log >> ${folder}/Daily/Daily-${today}.log
echo "——————————————————————————————" >> ${folder}/Daily/Daily-${today}.log

###### GCP Backup ######

echo " " >> ${folder}/Daily/Daily-${today}.log
echo "###### GCP Backup ######" >> ${folder}/Daily/Daily-${today}.log
cat ./Check-GCS-Backup-Status/GCS-result-${today}.log >> ${folder}/Daily/Daily-${today}.log

###### NAS Backup ######

echo " " >> ${folder}/Daily/Daily-${today}.log
echo " " >> ${folder}/Daily/Daily-${today}.log
echo "###### NAS Backup ######" >> ${folder}/Daily/Daily-${today}.log
cat ./NasDataCheck/nas-result-${today}.log >> ${folder}/Daily/Daily-${today}.log

message="${folder}/Daily/Daily-${today}.log"

mailx -r AWS-S3-BackupDaily@9splay.com -s "9Splay Game Backup Daily ${today}" larry_yao@9splay.com   < ${message}

