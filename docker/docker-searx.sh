#!/bin/bash
#docker_searx

url_github=https://raw.githubusercontent.com/disanshijie
homePath=~
dirname=$homePath/sls/searx

#启动镜像
docker_searx(){
    mkdir -p $dirname
    #赋予文件夹权限（一般不需要）
    cd $dirname
    chmod +x -R $dirname
    #拉取
    docker pull searx/searx
    #删除容器
    #docker stop searx
    #docker rm -f searx
    #运行
    docker run --rm -d --name searx --restart=always -v $dirname:/etc/searx -p 80:8080 searx/searx

}

#检查安装
curl -fsSL $url_github/vultr/master/docker/check-install.sh | sh

#运行命令
docker_searx
