
#### 说明

整理了一下 [vultr的接口文档](https://www.vultr.com/api)
使用接口文档可以很方便的调用 创建 销毁服务器 运行相关脚本
eg：搭建aria离线下载 nginx断点续传 ssr

<!-- more -->

#### 内容（psotman）



![](https://gitee.com/sunjinchao/cloudfile_C01/raw/master/img/20190804002918.png)

#### 使用

##### 开通api

登陆[vultr](https://my.vultr.com/)   用户——>设置——>api  开启api 并设置允许ip地址 [链接](https://my.vultr.com/settings/#settingsapi)

![](https://gitee.com/sunjinchao/cloudfile_C01/raw/master/img/20190804004330.png)

复制 api-key



##### postman 使用

导入 `Vultr.postman_collection.json`

![](https://gitee.com/sunjinchao/cloudfile_C01/raw/master/img/20190804003638.png)

设置 自己的api-key

![](https://gitee.com/sunjinchao/cloudfile_C01/raw/master/img/20190804003237.png)

ps：SUBID 创建服务器后才有



### 参考

https://www.vultr.com/api
