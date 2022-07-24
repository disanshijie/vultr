#!/bin/bash
# 失败 不好用 不知道为什么 --sunbo
#docker_安装caddy代理github
#url_github=https://raw.githubusercontent.com/disanshijie
#homePath=~
#dirname=$homePath/v2ray

GOOGLE_DOMAIN=${1:-"sunc.disanshijie.top"}

GitHub_raw_DOMAIN=${2:-"sund.disanshijie.top"}

#上传证书到服务器上
httpsCertsUpload(){

#apt-get install wget
#yum install wget
mkdir -p ~/caddy/certs
cd ~/caddy/certs

#go.disanshijie.top的证书
wget http://singapore.oss.sunjc.top/vpn/cert/${GOOGLE_DOMAIN}.key
wget http://singapore.oss.sunjc.top/vpn/cert/${GOOGLE_DOMAIN}.crt

}

#安装caddy（需要提前申请好证书）
docker_caddy(){
    rm -rf ~/caddy
    mkdir -p ~/caddy/{certs,logs,www}
    rm -rf ~/caddy/Caddyfile
    touch ~/caddy/Caddyfile
    chmod 777 ~/caddy/*

echo "
:80 {
    @options {
        method OPTIONS
    }
    header {
        Access-Control-Allow-Origin "{http.request.header.Origin}"
        Access-Control-Allow-Credentials true
        Access-Control-Allow-Methods *
        Access-Control-Allow-Headers DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization
    }

    reverse_proxy https://github.com {

    header_up Host {upstream_hostport}
    header_up X-Forwarded-Host {host}
    header_up origin https://github.com
    header_down location (https://github.com/)(.*) https://{host}/$2
    }
    respond @options 204
}

:8000 {
    reverse_proxy / https://baidu.com
}

:7110 {
    reverse_proxy / https://objects.githubusercontent.com
}

:7111 {
    reverse_proxy / https://raw.githubusercontent.com
}

" > ~/caddy/Caddyfile


    #sed -i "s/REPLACE_DOMAIN/${domain}/g" ~/caddy/Caddyfile
    #sed -i "s/REPLACE_PATH/${V2RAY_PATH}/g" ~/caddy/Caddyfile
	
	#docker pull abiosoft/caddy
	#删除容器
    docker rm -f caddy

docker run -d \
    --restart=always --name caddy \
    -e "CADDYPATH=/etc/caddycerts" \
    -e "TZ=Asia/Shanghai" \
    -e "ACME_AGREE=true" \
    -e "email 87855649@qq.com" \
    -v ~/caddy:/etc/caddy \
    -v ~/caddy/www:/usr/share/caddy \
    -v ~/caddy/logs:/opt \
    -p 80:80 -p 443:443 -p 2015:2015 \
    -p 7110:7110 -p 7111:7111 -p 8000:8000 \
    caddy
}


function main(){

#httpsCertsUpload
docker_caddy

}


#运行命令
main
