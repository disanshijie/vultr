
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