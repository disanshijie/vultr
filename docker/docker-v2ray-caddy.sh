#!/bin/bash
#docker_安装v2ray+caddy
#url_github=https://raw.githubusercontent.com/disanshijie
#homePath=~
#dirname=$homePath/v2ray

#UUID=$(uuidgen)
#V2RAY_PATH=${UUID:0:8} #截取8个字符
UUID="260af679-adb3-8667-0503-7f1e89fa1e0d"
CADDY_DOMAIN="pic.disanshijie.top"
V2RAY_PATH="Qg6tk2Guex" #截取8个字符

GOOGLE_DOMAIN="go.disanshijie.top"

#上传证书到服务器上
httpsCertsUpload(){

#apt-get install wget
#yum install wget
mkdir -p ~/caddy/certs
cd ~/caddy/certs
#pic.disanshijie.top的证书
wget https://singapore.oss.sunjc.top/vpn/cert/pic.disanshijie.top.key
wget https://singapore.oss.sunjc.top/vpn/cert/pic.disanshijie.top.crt

#go.disanshijie.top的证书
wget https://singapore.oss.sunjc.top/vpn/cert/go.disanshijie.top.key
wget https://singapore.oss.sunjc.top/vpn/cert/go.disanshijie.top.crt

}

#启动镜像
docker_v2ray(){

	mkdir -p ~/v2ray/log
	touch ~/v2ray/config.json
	touch ~/v2ray/log/{access.log,error.log}
    chmod 777 ~/v2ray/*

	#设置v2ray配置文件
    encodeCfg="ewogICAgImxvZyI6IHsKICAgICAgICAibG9nbGV2ZWwiOiAid2FybmluZyIsCiAgICAgICAgImFjY2VzcyI6ICIvdmFyL2xvZy92MnJheS9hY2Nlc3MubG9nIiwKICAgICAgICAiZXJyb3IiOiAiL3Zhci9sb2cvdjJyYXkvZXJyb3IubG9nIgogICAgfSwKICAgICJpbmJvdW5kcyI6IFsKICAgICAgICB7CiAgICAgICAgICAgICJwb3J0IjogIjkwMDEiLAogICAgICAgICAgICAicHJvdG9jb2wiOiAidm1lc3MiLAogICAgICAgICAgICAic2V0dGluZ3MiOiB7CiAgICAgICAgICAgICAgICAiY2xpZW50cyI6IFsKICAgICAgICAgICAgICAgICAgICB7CiAgICAgICAgICAgICAgICAgICAgICAgICJpZCI6ICJSRVBMQUNFX1VVSUQiLAogICAgICAgICAgICAgICAgICAgICAgICAiYWx0ZXJJZCI6IDE2LAogICAgICAgICAgICAgICAgICAgICAgICAic2VjdXJpdHkiOiAiYXV0byIsCiAgICAgICAgICAgICAgICAgICAgICAgICJsZXZlbCI6IDAKICAgICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICBdCiAgICAgICAgICAgIH0sCiAgICAgICAgICAgICJzdHJlYW1TZXR0aW5ncyI6IHsKICAgICAgICAgICAgICAgICJuZXR3b3JrIjogIndzIiwKICAgICAgICAgICAgICAgICJ3c1NldHRpbmdzIjogewogICAgICAgICAgICAgICAgICAgICJwYXRoIjogIi9SRVBMQUNFX1BBVEgiCiAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgIH0KICAgICAgICB9CiAgICBdLAogICAgIm91dGJvdW5kcyI6IFsKICAgICAgICB7CiAgICAgICAgICAgICJwcm90b2NvbCI6ICJmcmVlZG9tIiwKICAgICAgICAgICAgInNldHRpbmdzIjoge30KICAgICAgICB9CiAgICBdCn0="
    echo ${encodeCfg} | base64 -d > ~/v2ray/config.json
    sed -i "s/REPLACE_UUID/${UUID}/g" ~/v2ray/config.json
    sed -i "s/REPLACE_PATH/${V2RAY_PATH}/g" ~/v2ray/config.json

    #拉取镜像
    #docker pull v2ray/official
	#删除容器
    docker rm -f v2ray

#启动容器
docker run -d --privileged \
  --name v2ray \
  --restart=always \
  -e "TZ=Asia/Shanghai" \
  -v ~/v2ray/config.json:/etc/v2ray/config.json \
  -v ~/v2ray/log:/var/log/v2ray \
  v2ray/official

  #caddy设置了 --link v2ray就不需要对外暴露端口了
  #-p 9001:9001/tcp \
  #-p 9001:9001/udp \

}

#安装caddy（需要提前申请好证书）
docker_caddy(){
    mkdir -p ~/caddy/{certs,logs,www}
    touch ~/caddy/Caddyfile
    chmod 777 ~/caddy/*

echo "
${CADDY_DOMAIN}:443 {
  gzip
  tls /etc/caddycerts/${CADDY_DOMAIN}.crt /etc/caddycerts/${CADDY_DOMAIN}.key
  timeouts 30s
  log /opt/logs/access.log
  proxy / https://www.hippopx.com/
  
  proxy /${V2RAY_PATH} v2ray:9001 {
    websocket
    header_upstream -Origin
  }
}

${CADDY_DOMAIN}:80 {
    redir https://${CADDY_DOMAIN}{uri}
}

${GOOGLE_DOMAIN}:443 {
  gzip
  tls /etc/caddycerts/${GOOGLE_DOMAIN}.crt /etc/caddycerts/${GOOGLE_DOMAIN}.key
  timeouts 30s
  log /opt/logs/access.log
  proxy / https://www.google.com/
  
}

${GOOGLE_DOMAIN}:80 {
    redir https://${GOOGLE_DOMAIN}{uri}
}

" > ~/caddy/Caddyfile


    #sed -i "s/REPLACE_DOMAIN/${domain}/g" ~/caddy/Caddyfile
    #sed -i "s/REPLACE_PATH/${V2RAY_PATH}/g" ~/caddy/Caddyfile
	
	#docker pull abiosoft/caddy
	#删除容器
    docker rm -f caddy

docker run -d \
    --restart=always --name caddy \
    --link v2ray \
    -e "CADDYPATH=/etc/caddycerts" \
    -e "TZ=Asia/Shanghai" \
    -e "ACME_AGREE=true" \
    -e "email 87855649@qq.com" \
    -v ~/caddy/Caddyfile:/etc/Caddyfile \
    -v ~/caddy/certs:/etc/caddycerts \
    -v ~/caddy/www:/srv \
    -v ~/caddy/logs:/opt/logs \
    -p 80:80 -p 443:443 -p 2015:2015 \
    abiosoft/caddy
}


#安装caddy（自动申请证书，需要提前做好域名解析）
docker_caddy_auto(){
    mkdir -p ~/caddy/{certs,logs,www}
    touch ~/caddy/Caddyfile
    chmod 777 ~/caddy/*

echo "
${CADDY_DOMAIN}:443 {
  gzip
  tls 878455649@qq.com
  timeouts 30s
  log /opt/logs/access.log
  proxy / https://www.hippopx.com/
  
  proxy /${V2RAY_PATH} v2ray:9001 {
    websocket
    header_upstream -Origin
  }
}

${CADDY_DOMAIN}:80 {
    redir https://${CADDY_DOMAIN}{uri}
}

${GOOGLE_DOMAIN}:443 {
  gzip
  tls 878455649@qq.com
  timeouts 30s
  log /opt/logs/access.log
  proxy / https://www.google.com/
  
}

${GOOGLE_DOMAIN}:80 {
    redir https://${GOOGLE_DOMAIN}{uri}
}

" > ~/caddy/Caddyfile


    #sed -i "s/REPLACE_DOMAIN/${domain}/g" ~/caddy/Caddyfile
    #sed -i "s/REPLACE_PATH/${V2RAY_PATH}/g" ~/caddy/Caddyfile
	
	#docker pull abiosoft/caddy
	#删除容器
    docker rm -f caddy

docker run -d \
    --restart=always --name caddy \
    --link v2ray \
    -e "CADDYPATH=/etc/caddycerts" \
    -e "TZ=Asia/Shanghai" \
    -e "ACME_AGREE=true" \
    -e "email 87855649@qq.com" \
    -v ~/caddy/Caddyfile:/etc/Caddyfile \
    -v ~/caddy/certs:/etc/caddycerts \
    -v ~/caddy/www:/srv \
    -v ~/caddy/logs:/opt/logs \
    -p 80:80 -p 443:443 -p 2015:2015 \
    abiosoft/caddy
}



function finish(){
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}"
    echo -e "\033[1;32m"
    echo "=================================================="
    echo " 地址     : ${CADDY_DOMAIN}"
    echo " UUID     : ${UUID}"
    echo " AlterId  : 16"
    echo " 加密方式 : auto"
    echo " 传输协议 : ws"
    echo " Path     : /${V2RAY_PATH}"
    echo " TLS      : true"
    echo "=================================================="
    echo -e "\033[0m"
}


function main(){

docker_v2ray
httpsCertsUpload
docker_caddy
#docker_caddy_auto
finish

}


#检查安装
curl -fsSL https://raw.githubusercontent.com/disanshijie/vultr/master/docker/check-install.sh | sh

#运行命令
main
