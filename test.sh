#!/bin/bash
#vultr安装脚本 vultr centos7x64 测试通过

url_github=https://raw.githubusercontent.com/disanshijie
dirname=/root/sun

main(){
    mkdir -p $dirname
    cd $dirname
    chmod 777 -R $dirname
    #安装nginx
    #curl -fsSL $url_github/vultr/master/docker/docker-nginx.sh | sh
    #安装ssr    
    curl -fsSL $url_github/vultr/master/docker/docker-ssr.sh | sh
    #安装baidupcs
    curl -fsSL $url_github/vultr/master/docker/docker-baidupcs.sh | sh    
    #安装aria2
    curl -fsSL $url_github/vultr/master/docker/docker-aria2.sh | sh
    
}

#运行命令
main
