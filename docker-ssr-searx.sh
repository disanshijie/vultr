#!/bin/bash
#vultr安装脚本 vultr centos7x64 测试通过

url_github=https://raw.githubusercontent.com/disanshijie
dirname=/root/sun

main(){
    mkdir -p $dirname
    cd $dirname
    chmod 777 -R $dirname
    #安装searx
    curl -fsSL $url_github/vultr/master/docker/docker-searx.sh | sh
    #安装ssr
    curl -fsSL $url_github/vultr/master/docker/docker-ssr.sh | sh

}

#运行命令
main
