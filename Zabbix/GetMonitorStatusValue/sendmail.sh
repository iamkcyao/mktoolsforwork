date=$(date '+%Y%m%d-%H:%M')
serverlist="./serverlist"
ListNum=$(cat ${serverlist} |wc -l)

printf "%-25s %-15s %-10s %-10s %-15s %-10s\n" ServerName CPU MEM DataUSE ESTABLISHED TIMEWAIT >> /var/www/html/${date}.html

for ((i=1; i<=${ListNum} ;i++))
do
servername=$(cat ${serverlist} | sed -n "${i},1p" | awk {'print $1'})
serverip=$(cat ${serverlist} | sed -n "${i},1p" | awk {'print $2'})

cpu=$(zabbix_get -s ${serverip} -k system.cpu.util)
mem=$(zabbix_get -s ${serverip} -k vm.memory.size[pavailable])
full=100
mem2=`echo "$full - $mem" | bc -l `
hdduse=$(zabbix_get -s ${serverip} -k vfs.fs.size[/data,pused])
established=$(zabbix_get -s ${serverip} -k tcp.status[established])
timewait=$(zabbix_get -s ${serverip} -k tcp.status[timewait])


printf "%-25s %-15s %-10s %-10s %-15s %-10s\n" ${servername} ${cpu} ${mem2} ${hdduse} ${established} ${timewait} >> /var/www/html/${date}.html

done

message="/var/www/html/${date}.html"
mailx -r status@xxx.com -s "GCP-TS-STATUS ${date}" iamkcyao@gmail.com   < ${message}