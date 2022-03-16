

--------------------------------------------------------------------
update.sh DNS更新
appid=""

异常分析：
ErrCode:SubDomainInvalid.ValueThe DNS record is invalid or in the wrong format.
原因：ip地址对不对

参数说明：
默认更新域名：pic.disanshijie.top; go.disanshijie.top
-a 更新DNS的秘钥 必要
-n 二级域名的前缀 默认值：pic,go
-d 域名 默认值：disanshijie.top
-u 用户名 默认值：aliyunConfigUser2

使用举例：
更新wee.disanshijie.top; werw.disanshijie.top 两个域名
./updateDns.sh -a $appid -n wee,werw

更新
./updateDns.sh -a $appid -n wee,werw -d disanshijie.top

---



运行定义的任务
crontask.sh文件再 ~目录下

执行销毁
destory.sh文件在 ~/vultr 目录下




添加定时器任务步骤

1. 赋予crontask.sh文件可执行权限

```
chmod +x crontask.sh
```

2. 命令 crontab -e 添加任务

3. 编辑任务 输入

```
#晚上凌点20分执行
20 0 * * * /root/crontask.sh > /tmp/corn_vultr.log 2>&1
```

4. 保存 退出