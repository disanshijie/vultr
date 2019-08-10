#!/bin/bash
#docker_baidupcs

url_github=https://raw.githubusercontent.com/disanshijie
homePath=~
dirname=$homePath/sls/baiduyun

mkdir -p $dirname
#赋予文件夹权限（一般不需要）
chmod 777 -R $dirname

#
#来源：https://hub.docker.com/r/oldiy/baidupcs
# dockerfile被删 镜像23MB
docker_baidupcs_oldiy(){
    #拉取
    docker pull oldiy/baidupcs:latest
    #运行
    docker run -d --name baidupcs \
        -p 5299:5299 \
        -v /root/sls/baiduyun:/root/Downloads \
        oldiy/baidupcs
}

main(){
    #检查docker安装
    curl -fsSL $url_github/vultr/master/docker/check-install.sh | sh
    #
    docker_baidupcs_oldiy
}
#运行命令
main




