#!/bin/bash
#docker_nginx

url_github=https://raw.githubusercontent.com/disanshijie
homePath=~
dirname=$homePath/sls/nginx

#启动镜像
docker_nginx(){
    mkdir -p $dirname
    #赋予文件夹权限（一般不需要）
    cd $dirname
    curl -fsSL -O ${url_github}/vultr/master/web/index.html 
    chmod +x -R $dirname
    #拉取
    docker pull nginx
    #删除容器
    #docker stop nginx
    #docker rm -f nginx
    #运行 改成8010 80给searx用
    docker run -d -p 8010:80 -p 443:443 -v $dirname:/usr/share/nginx/html --name nginx --restart=always nginx

}

#检查安装
curl -fsSL https://raw.githubusercontent.com/disanshijie/vultr/master/docker/check-install.sh | sh

#运行命令
docker_nginx
