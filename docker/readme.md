

## 更新

最后编辑 2019-08-06

TODO Huginn

baidupcs-web
https://github.com/liuzhuoling2011/baidupcs-web

nginx ngork aria 

## 说明

### 科学上网v2ary+caddy

```
curl -fsSL https://raw.githubusercontent.com/disanshijie/vultr/master/docker/docker-v2ray-caddy.sh | sh


#!/bin/bash
curl -fsSL https://raw.githubusercontent.com/disanshijie/vultr/master/linux/updateDns.sh | sh -s -- -a 3SJSFRPWXUJJKJTFZgKXAN6G2XAWM5NJQRFSA -n sunb,suna
curl -fsSL https://raw.githubusercontent.com/disanshijie/vultr/master/docker/docker-v2ray-caddy.sh | sh -s sunb.disanshijie.top suna.disanshijie.top

```

注意：需要定期更新pic.disanshijie.top和go.disanshijie.top这两个域名的证书




### **代理**

#### **docker-nginx.sh**

宿主机映射位置：/root/sls

### **科学上网**

#### **docker-ssr.sh**

启动后默认配置

> ip：
>
> 端口：8000
>
> 密码：doub.io
>
> 加密：rc4-md5
>
> 协议：auth_aes128_md5
>
> 混淆：plain
>
> ssr版客户端  [window](https://github.com/shadowsocksrr/shadowsocksr-csharp/releases) [android](https://github.com/shadowsocksrr/shadowsocksr-android)

### **离线下载**

#### **docker-aria2**

略

#### **docker_aria2_with_webui**

默认参数：

> 服务器下载位置：~/sls
>
> 下载管理aria-UI：http://ip/6801
>
> 下载文件列表folder：http://ip/6802
>
> Aria2 RPC 端口号：6800
>
> Aria2 RPC 密码令牌：123456

更多参考：<https://github.com/XUJINKAI/aria2-with-webui>

#### **docker_aria2_ariang_docker**

**默认参数**：

> Aria2 UI: http://ip:6900/ui/
>
> FileManger:http://ip:6900
>
> 下载路径：~/sls
>
> 请使用 admin/admin 进行登录

**使用：**

Aria2 UI第一次需要修改 端口号 6900和 RPC 123456

**开启所有功能**

```
  docker run -d --name ariang \
  -p 80:80 \
  -p 443:443 \
  -e PUID=1000 \
  -e PGID=1000 \
  -e ENABLE_AUTH=true \
  -e RPC_SECRET=Hello \
  -e DOMAIN=https://example.com \
  -e ARIA2_SSL=false \
  -e ARIA2_USER=user \
  -e ARIA2_PWD=pwd \
  -v /yourdata:/data \
  -v /app/a.db:/app/filebrowser.db \
  -v /yoursslkeys/:/app/conf/key \
  -v <to your aria2.conf>:/app/conf/aria2.conf \
  wahyd4/aria2-ui
```

详细：https://github.com/wahyd4/aria2-ariang-docker/blob/master/README.CN.md

### **文件管理器**

#### **docker_h5ai**

服务器文件目录管理工具

**默认配置：**

> 访问：http://ip:6803
>
> 文件根目录 ~/sls

根目录不能有index.html

详细：https://github.com/CoRfr/docker-h5ai

### **百度云**

#### **docker_baidupcs.sh**

百度云web客户端 https://github.com/liuzhuoling2011/baidupcs-web

##### docker_baidupcs_oldiy

> 访问：http://ip:5299
>
> 下载路径：/sls/baiduyun

TODO 上传时有问题 权限etc

TODO <https://hub.docker.com/r/auska/docker-baidupcs>

效果

![](http://file.qiniu.disanshijie.top/img/20190820213719.png)

![](http://file.qiniu.disanshijie.top/img/20190820213905.png)


### docker-squid3代理服务器

使用：
curl -fsSL https://raw.githubusercontent.com/disanshijie/vultr/master/docker/docker-squid3.sh | sh

### 参考