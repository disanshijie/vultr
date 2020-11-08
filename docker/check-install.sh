#!/bin/bash
#vultr安装ssr一键脚本 vultr centos7x64 测试通过


install_docker_yamaxun_ec2()
{
	echo "检查Docker......"
	docker -v
    if [ $? -eq  0 ]; then
        echo "检查到Docker已安装!"
    else
    	echo "安装docker环境..."
        
        sudo yum update -y
        sudo yum uninstall -y docker
        sudo yum install -y docker
        sudo service docker start
        # 将docker权限赋给 ec2-user
        sudo usermod -a -G docker ec2-user
        # 如果执行还不能成功的，再执行这个
        sudo chmod 666 /var/run/docker.sock

        #开机自启
        systemctl enable docker.service
        #或者
        #curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
        echo "安装docker环境...安装完成!"
    fi
    
    # 创建公用网络==bridge模式
    #docker network create share_network
}

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

#如果是亚马逊服务器
#install_docker_yamaxun_ec2

#启动
sudo systemctl start docker