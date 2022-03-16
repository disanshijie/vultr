#!/bin/sh
appid="please input secret"
regionId="ap-southeast-1"
domain="http://sunjc.top:7110/script"

domainName="disanshijie.top"
domainConfig="aliyunConfigUser2"
addressStr="pic,go"

#更新实例
update_dns_user2(){
echo "更新DNS"

get_ip
PUBLIC_IP=$(get_ip)

#https://cloud.tencent.com/developer/ask/57585 ,https://www.codeleading.com/article/32862155244/
OLD_IFS=$IFS #保存原始值
IFS="," #改变IFS的值
addressList=($addressStr)
IFS=$OLD_IFS #还原IFS的原始值

for address in ${addressList[@]}; do
  echo "更新域名地址：$address.$domainName"
  local url="${domain}/v1/dns/update?name=${address}&ip=${PUBLIC_IP}&config=${domainConfig}&domain=$domainName"
  echo $url
  curl -m 20 -s -X GET -H "appid:${appid}" -H 'cache-control: no-cache' $url
done

}


#获取本机公网ip https://blog.51cto.com/meiling/2607090
#resolve=`curl -sL https://hijk.art/hostip.php?d=${DOMAIN}`
#res=`echo -n ${resolve} | grep ${IP}`
get_ip(){
PUBLIC_IP=`curl -m 20 -s ifconfig.me`
#PUBLIC_IP=`wget http://ipecho.net/plain -O - -q ; echo`
echo $PUBLIC_IP
}


while [ -n "$1" ]  
do  
  case "$1" in   
    -a)  
        echo "-a 选项的参数值是：$2"
        appid=$2
        shift
        ;;  
    -d)  
        echo "-d 选项的参数值是：$2"
        domainName=$2
        shift  
        ;;  
    -n)  
        echo "-n 选项的参数值是：$2"  
        addressStr=$2  
        shift  
        ;;  
    -u)  
        echo "发现 -u 选项"
        domainConfig=$2
        shift
        ;;  
    -h)  
        echo "-a appid"  
        echo "-d domainName 域名"  
        echo "-n addressStr 二级域名"  
        echo "-u domainConfig 用户" 
        shift
        ;;  
  esac  
  shift  
done

update_dns_user2

