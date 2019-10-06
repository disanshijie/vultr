#! /bin/bash  

#晚上凌点执行 每30分钟一次
#*/30 0-1 * * * /root/crontask.sh > /tmp/corn_vultr.log 2>&1
#晚上凌点20分执行
#20 0 * * * /root/crontask.sh > /tmp/corn_vultr.log 2>&1

task_list(){

echo `date`

chmod +x /root/vultr/destory.sh
#执行vultr服务器销毁
/root/vultr/destory.sh <api-key值>

echo `date`
}

task_list