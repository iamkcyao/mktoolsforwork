source ~/.bash_profile
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

find "./NasDataCheck/" -name "*.log" -mtime +6 -exec rm -rf {} \;

sh ./NasDataCheck/pltdata.sh
sh ./NasDataCheck/wjgldata.sh
sh ./NasDataCheck/lhkrdata.sh
sh ./NasDataCheck/plldata.sh
sh ./NasDataCheck/ssdata.sh
