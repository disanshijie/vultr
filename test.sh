#!/bin/bash
#vultr安装脚本 vultr centos7x64 测试通过

url_github=https://raw.githubusercontent.com/disanshijie
dirname=/root/sun

main(){
    mkdir -p $dirname
    cd $dirname
    chmod 777 -R $dirname
    #安装nginx
    curl -fsSL https://raw.githubusercontent.com/disanshijie/vultr/master/docker/docker-nginx.sh | sh
    #安装ssr    
    curl -fsSL https://raw.githubusercontent.com/disanshijie/vultr/master/docker/docker-ssr.sh | sh
    #安装baidupcs
    curl -fsSL https://raw.githubusercontent.com/disanshijie/vultr/master/docker/docker-baidupcs.sh | sh    
    #安装aria2
    curl -fsSL https://raw.githubusercontent.com/disanshijie/vultr/master/docker/docker-aria2.sh | sh

    #安装chfs
    curl -fsSL https://gitee.com/sunjinchao/cloudfile_A01/raw/master/chfs/chfs-install.sh | sh
}

#运行命令
main
