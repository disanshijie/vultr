#!/bin/bash
#docker_nginx

url_github=https://raw.githubusercontent.com/disanshijie
dirname=/root/sls

#启动镜像
docker_nginx(){
    mkdir -p $dirname
    #赋予文件夹权限（一般不需要）
    cd $dirname
    curl -fsSL ${url_github}/vultr/master/web/index.html 
    chmod 777 -R $dirname
    #拉取
    docker pull nginx
    #删除容器
    #docker stop nginx
    #docker rm -f nginx
    #运行
    docker run -d --name nginx -p 80:80 -p 443:443 -v $dirname:/usr/share/nginx/html nginx

}

#检查安装
curl -fsSL https://raw.githubusercontent.com/disanshijie/vultr/master/docker/check-install.sh | sh

#运行命令
docker_nginx
