#!/bin/bash
#docker_aria2

url_github=https://raw.githubusercontent.com/disanshijie
homePath=~
dirname=$homePath/sls

mkdir -p $dirname
#赋予文件夹权限（一般不需要）
chmod 777 -R $dirname

#aria2+webui
#来源：https://github.com/XUJINKAI/aria2-with-webui
# aria2 + webUI
# 轻便 镜像小，但webui很简便
docker_aria2_with_webui(){
    #拉取
    docker pull xujinkai/aria2-with-webui:latest
    #删除容器
    #运行
    sudo docker run -d \
        --name aria2-with-webui \
        -p 6800:6800 \
        -p 6801:80 \
        -p 6802:8080 \
        -v $dirname:/data \
        -e SECRET=123456 \
        xujinkai/aria2-with-webui
}

#来源：https://github.com/wahyd4/aria2-ariang-docker
# aria2 + webUI
# 功能全，镜像有点大100MB
# $1端口 $2令牌 $3$4
docker_aria2_ariang_docker(){
    #拉取
    docker pull wahyd4/aria2-ui:latest
    #运行
    docker run -d --name ariang \
        -p $1:80 \
        -e RPC_SECRET=$2 \
        -v $dirname:/data \
    wahyd4/aria2-ui
}

#Linux文件管理 可以支持树结构
#https://github.com/CoRfr/docker-h5ai
#镜像很大400MB，用处不是很大 根目录不能有index.html
docker_h5ai(){
    #拉取
    docker pull corfr/h5ai:latest
    #运行
    sudo docker run -d \
    -p $1:80 \
    -v $dirname:/var/www \
    corfr/h5ai
}

main(){
    #检查docker安装
    curl -fsSL $url_github/vultr/master/docker/check-install.sh | sh
    #
    #docker_aria2_with_webui
    docker_aria2_ariang_docker 6900 123456
    docker_h5ai 6803

    #安装docker-compose
    #sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    #sudo chmod +x /usr/local/bin/docker-compose
    #sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
}
#运行命令
main




