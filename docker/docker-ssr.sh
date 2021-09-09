#!/bin/bash
#vultr安装ssr一键脚本 vultr centos7x64 测试通过

url_github=https://raw.githubusercontent.com/disanshijie

#启动镜像
docker_ssr_letssudormrf(){
    #下载镜像
    docker pull letssudormrf/ssr-bbr-docker
    #删除容器
    docker stop ssr-bbr-docker
    docker rm -f ssr-bbr-docker
    #运行镜像
    docker run --privileged -d \
	-p 8000:8008/tcp -p 8000:8008/udp \
    --restart=always \
	--name ssr-bbr-docker letssudormrf/ssr-bbr-docker \
	-p 8008 -k doub.io -m rc4-md5 -O auth_aes128_md5 -o plain
}

main(){
    #检查安装
    curl -fsSL ${url_github}/vultr/master/docker/check-install.sh | sh
    #rm -rf check-install.sh
    #启动ssr
    docker_ssr_letssudormrf  
}

#运行命令
main
