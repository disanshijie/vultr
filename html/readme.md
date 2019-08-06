---
title: readme
date: 2019-08-04 23:35:53
author: sun bo
notebook: blog
evernote-version: 0
source: 原创/转载
share: false/true
thumbnail: 
tags: [默认]
categories:
    - e:\Data\VSCode\WorkSpace\Space1\vultr\html
blogexcerpt:
---
vultr-api 接口实现自动创建服务器 使用实例

<!-- more -->

#### 必备条件

有一个vultr账号，并且有一定余额
vultr账号开通 api 功能 [链接](https://my.vultr.com/settings/#settingsapi)

#### 使用

如果第一次使用，按一下步骤

##### step1 设置apikey

获取到自己账号的api ，填入 常量->apikey 输入框中

![](https://gitee.com/sunjinchao/cloudfile_C01/raw/master/img/20190805210219.png)

step2 创建脚本

点击新建脚本-->填写参数-->提交 

eg:

![](https://gitee.com/sunjinchao/cloudfile_C01/raw/master/img/20190805213619.png)

```
#参数name
test33
#参数type
boot
#参数script
#!/bin/bash
curl -fsSL https://raw.githubusercontent.com/disanshijie/vultr/master/start.sh | sh
```

点击 获取脚本列表 列出所有脚本

![](https://gitee.com/sunjinchao/cloudfile_C01/raw/master/img/20190806114801.png)

选中某个脚本，点击使用，常量 SCRIPTID 会被自动填充应用的值

##### step3 创建一个服务器

点击购买，弹出购买服务器的SUBID 稍等片刻后
点击获取服务器列表，查看服务器是否已经创建 及创建状态
状态为active 点击测试，查看服务器是否启动已经 脚本命令是否也已经启动

![](https://gitee.com/sunjinchao/cloudfile_C01/raw/master/img/20190806114935.png)

ps：测试按钮 打开的是 http://ip/index.html 页面，原因是我的脚本是装nginx脚本
可以结合实际的脚本内容测试脚本是否运行成功
另外：最好先ping 一下ip 万一IP是被封了的

#### 电脑端

可以将当前目录下文件下载到本地，浏览器打开index.html运行
js文件内的baseUrl最好可以自己设置nginx代理 附nginx.conf的server配置

#### 手机端

当前 html文件下载到手机后，找到文件位置，浏览器打开index.html

复制浏览器地址到笔记本 地址后添加 ?apikey&SCRIPTID 例:

```
file:///storage/emulated/0/%E7%94%B5%E8%84%91%E5%90%8C%E6%AD%A5/vultr/index.html?3PTCR56ERV22YUA3I45AURCI3TFTOOSJ2V54Q
```

没有SCRIPTID 可不加

以后手机浏览器输入地址就可以使用

![](https://gitee.com/sunjinchao/cloudfile_C01/raw/master/img/20190806114653.png)



ps：哪位前端兄弟可以优化一下这个页面....

### 参考


