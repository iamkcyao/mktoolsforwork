source ~/.bash_profile
#!/bin/bash
today=$(date +"%Y-%m-%d")
today2=$(date +"%Y%m%d")
today3=$(date -d '-1 day' +"%Y-%m-%d")
find "./Check-GCS-Backup-Status/" -name "*.log" -mtime +6 -exec rm -rf {} \;

#sh -x ./Check-GCS-Backup-Status/wjkr-backup/wjkrchecker.sh
#sh -x ./Check-GCS-Backup-Status/gcp-ghjp-bucket/ghjpchecker.sh
#sh -x ./Check-GCS-Backup-Status/gcp-hs-bucket/hschecker.sh
sh -x ./Check-GCS-Backup-Status/gcp-hskr-bucket/hskrchecker.sh
sh -x ./Check-GCS-Backup-Status/tg-backup/tgchecker.sh
#sh -x ./Check-GCS-Backup-Status/wjgl-backup/wjglchecker.sh
#sh -x ./Check-GCS-Backup-Status/swtbackup/swtchecker.sh
#sh -x ./Check-GCS-Backup-Status/stsbackup/stschecker.sh
#sh -x ./Check-GCS-Backup-Status/ts-9splaybackup/tschecker.sh

#echo "-----GCP WJKR-----" >> ./Check-GCS-Backup-Status/GCS-result-${today}.log
#cat ./Check-GCS-Backup-Status/wjkr-backup/wjkr-backup-compare-${today}.log >> ./Check-GCS-Backup-Status/GCS-result-${today}.log

#echo "-----GCP WJGL-----" >> ./Check-GCS-Backup-Status/GCS-result-${today}.log
#cat ./Check-GCS-Backup-Status/wjgl-backup/wjgl-backup-compare-${today3}.log >> ./Check-GCS-Backup-Status/GCS-result-${today}.log

#echo "-----GCP HS-----" >> ./Check-GCS-Backup-Status/GCS-result-${today}.log
#cat ./Check-GCS-Backup-Status/gcp-hs-bucket/gcp-hs-bucket-compare-${today}.log >> ./Check-GCS-Backup-Status/GCS-result-${today}.log

echo "-----GCP HSKR-----" >> ./Check-GCS-Backup-Status/GCS-result-${today}.log
cat ./Check-GCS-Backup-Status/gcp-hskr-bucket/gcp-hskr-bucket-compare-${today}.log >> ./Check-GCS-Backup-Status/GCS-result-${today}.log

echo "-----GCP TG-----" >> ./Check-GCS-Backup-Status/GCS-result-${today}.log
cat ./Check-GCS-Backup-Status/tg-backup/tg-backup-${today}.log >> ./Check-GCS-Backup-Status/GCS-result-${today}.log
#echo "-----GCP GHJP-----" >> ./Check-GCS-Backup-Status/GCS-result-${today}.log
#cat ./Check-GCS-Backup-Status/gcp-ghjp-bucket/gcp-ghjp-bucket-compare-${today}.log >> ./Check-GCS-Backup-Status/GCS-result-${today}.log

#echo "-----GCP SWT-----" >> ./Check-GCS-Backup-Status/GCS-result-${today}.log
#cat ./Check-GCS-Backup-Status/swtbackup/swtbackup-${today2}.log >> ./Check-GCS-Backup-Status/GCS-result-${today}.log

#echo "-----GCP STS-----" >> ./Check-GCS-Backup-Status/GCS-result-${today}.log
#cat ./Check-GCS-Backup-Status/stsbackup/stsbackup-${today2}.log >> ./Check-GCS-Backup-Status/GCS-result-${today}.log

echo "-----GCP TS-----" >> ./Check-GCS-Backup-Status/GCS-result-${today}.log
echo "為不影響遊戲服務，暫時將DB備份關閉" >> ./Check-GCS-Backup-Status/GCS-result-${today}.log
#cat ./Check-GCS-Backup-Status/ts-9splaybackup/ts-9splaybackup-${today2}.log >> ./Check-GCS-Backup-Status/GCS-result-${today}.log
