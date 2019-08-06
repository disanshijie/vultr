#!/bin/bash
#vultr安装ssr一键脚本 vultr centos7x64 测试通过

install_docker()
{
	echo "检查Docker......"
	docker -v
    if [ $? -eq  0 ]; then
        echo "检查到Docker已安装!"
    else
    	echo "安装docker环境..."
        curl -sSL https://get.daocloud.io/docker | sh
        #开机自启
        systemctl enable docker.service
        #或者
        #curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
        echo "安装docker环境...安装完成!"
    fi
    
    # 创建公用网络==bridge模式
    #docker network create share_network
}
#//TODO检查
#curl -fsSL https://raw.githubusercontent.com/docker/docker-install/master/verify-docker-install -o verify-docker-install.sh
#chmod 777 verify-docker-install.sh && bash verify-docker-install.sh

install_docker
#启动
sudo systemctl start docker