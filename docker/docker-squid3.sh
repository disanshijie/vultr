#!/bin/bash
#docker-squid3

url_github=https://raw.githubusercontent.com/disanshijie
dirname=/etc/squid3

#启动squid3镜像
docker_squid3(){

    mkdir -p $dirname
    cd $dirname

    curl -fsSL -O ${url_github}/vultr/master/conf/squid.conf
    #赋予文件夹权限（一般不需要）
    chmod 777 -R $dirname/squid.conf

    docker run -d --name squid3 --restart=always \
    -p 3128:3128 \
    -v /etc/squid3/squid.conf:/etc/squid3/squid.conf \
    sameersbn/squid:3.3.8-14

}

docker_squid3



