#!/bin/bash

#vultr 获取服务器列表 并销毁服务器

#当前正在执行脚本的绝对路径
workPath=$(cd `dirname $0`; pwd)

apikey=""
set apikey [lindex $argv 0]

# $1 文件全名
vultr_server_list(){
    echo "主方法"

    local vultr_list=$1
    curl -H "API-Key: ${apikey}" https://api.vultr.com/v1/server/list >> $workPath/$vultr_list

    #sleep 5
    wait
    vultr_server_list_result $vultr_list
}

#解析返回服务器列表 json格式
#简单处理拿到返回结果中的 服务器的SUBID值
# $1 文件全名
vultr_server_list_result(){

local file=$1
cd $workPath

#循环
for line in for line in `cat $file`
do
#get line txt
typeInf=$line

#判断是否为空
local cutStr='":'
if [[ $typeInf =~ $cutStr ]]
then
    echo "----start-----"
    echo "$typeInf"
    echo "$cutStr"
    echo "----end-----"
    #get type
    #去除右边第一个空格开始的后边所有字符
    #typetmp=${typeInf%% *}

    #去掉":后面的内容
    strBefore=${typeInf%%\":*}
    echo "$strBefore"
    #去掉"前面的内容
    strAfter=${strBefore##*\"}
    echo "$strAfter"

    #SUBID一定是数字
    echo "$strAfter"|[ -n "`sed -n '/^[0-9][0-9]*$/p'`" ] && vultr_server_destroy $strAfter

else
    echo "没有需要销毁的服务器"
fi

done

}

#销毁服务器
vultr_server_destroy(){

    echo "执行销毁"
    local SUBID=$1
    curl -H "API-Key: ${apikey}" https://api.vultr.com/v1/server/destroy --data "SUBID=$SUBID"
}


start_run(){
    echo "开始操作"

    local vultr_list='vultr_list.json'

    rm -rf $workPath/$vultr_list
    touch $workPath/$vultr_list

    vultr_server_list $vultr_list

}

main(){
    echo "启动"
    apikey='<api-key值>'
    
    start_run
}
#测试
#main

start_run
