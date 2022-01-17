var constant = {
    //baseUrl: 'http://localhost:2222/', //本地代理
    baseUrl: 'http://sunjc.top:7110/script/', //服务器代理
    //baseUrl: 'http://localhost:8080/script/', //服务器代理
    oldTime: ""
}

var httpUrl = {
    server_create: constant.baseUrl + 'v1/ecs/add', //创建ecs
    server_update: constant.baseUrl + 'v1/ecs/update', //更新ecs
    server_list: constant.baseUrl + 'v1/ecs/query', //查询ecs

    server_reboot: constant.baseUrl + 'v1/server/reboot',
    server_reinstall: constant.baseUrl + 'v1/server/reinstall',
    server_destroy: constant.baseUrl + 'v1/ecs/delete', //销毁服务器

    dns_update: constant.baseUrl + 'v1/dns/update', //更新DNS
}

function getApiKey() {
    return $("#apikey").val();
}

function getResult(data) {
    $("#outputinfo").val(data);
}

function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
}
//
function ajaxGet(url, params, callback) {
    ajaxRequest("GET", url, params, callback);
}

function ajaxPost(url, params, callback) {
    ajaxRequest("POST", url, params, callback);
}

function ajaxRequest(type, url, params, callback) {
    $.ajax({
        url: url,
        data: params,
        dataType: 'JSON',
        timeout: 10000, //设置超时的时间10s
        async: false, //请求是否异步，默认为异步
        type: type,
        beforeSend: function(request) {
            request.setRequestHeader("appid", getApiKey());
            //request.setRequestHeader("Access-Control-Allow-Origin", "*");
        },
        success: function(list) {
            callback(list);
        },
        //调用执行后调用的函数，无论成功或失败都调用
        complete: function(XMLHttpRequest, textStatus) {
            if (textStatus == 'timeout') {
                if (error_callback != null && error_callback != "") {
                    error_callback();
                };
            }
        },
        error: function() {
            console.error("请求失败");
        }
    });
}

/**更新dns服务 */
function updateDns() {
    let apikey = $("#apikey").val();
    if (!apikey) {
        alert("请输入apikey");
        return;
    }
    let params = $("#updateDns").serialize();
    //console.log("请求参数："+params);
    ajaxGet(httpUrl.dns_update, params, function(res) {
        let str = "";
        if (res && res.code == 200) {
            //copySubid(res.data);
            console.log("返回结果" + res.data);
            alert("执行成功");
            return;
        } else {
            str = res.msg;
        }
        alert("执行结束" + str);
    })
}

//获取服务器列表
function getServerList() {
    $("#server-list").html("<p style='color:red;'>获取中...</p>");
    //alert("获取中...");
    let time = (new Date().getTime() - constant.oldTime) / 1000;
    constant.oldTime = new Date();
    let timeStr = "<p>距上次刷新" + time + "秒</p>";


    let regionId = $("#J_regionId").val();
    let url = httpUrl.server_list + "?regionId=" + regionId;

    ajaxGet(url, null, function(res) {
        let str = "<p style='color:red;'>获取数据失败...</p>";
        if (res) {
            if (res.code == 200) {
                str = serverList(regionId, res.data);
                if (!str) {
                    str = "<p style='color:red;'>没有...</p>";
                }
            }
        }
        $("#server-list").html(timeStr + str);
        ////setTimeout(function() {}, 5 * 1000);
    })
}


var serverList = (regionId, data) => {
    let html = "";
    if (data) {
        //arr.forEach((item, index) => console.log(item));
        let lastIp = "";
        for (let item of data) {
            let str = '';
            str += '<ul class="">';

            str += '	<li>实例Id：<a class="a-pw">' + item.instanceId + '</a></li>';
            str += '	<li>使用镜像：<a class="a-price">' + item.imageId + '</a></li>';
            str += '	<li>创建时间：<a class="a-date">' + '空' + '</a></li>';
            let ips = item.publicIpAddress;
            if (ips) {
                ips.forEach((v, i) => {
                    str += '	<li>ip：<a class="a-ip">' + v + '</a></li>';
                    //str += '	<li>状态：<a class="a-status">' + '空' + '</a> <a href="http://' + v + '/index.html" target="_blank">测试</a></li>';
                    str += '	<li><a class="a-control" href="http://' + v + '" target="_blank">搜索引擎</a></li>';
                    str += '	<li></li>';
                    lastIp = v;
                });
            }
            str += '	<li></li>';
            //str += '	<button onclick="serverReboot(\'' + regionId + '\',\''+item.instanceId + '\')">重启</button>';
            //str += '	<button onclick="serverReinstall(\'' + regionId + '\',\''+item.instanceId + '\')">重装</button>';
            str += '	<button onclick="serverDestroy(\'' + regionId + '\',\'' + item.instanceId + '\')">销毁</button>';
            str += '</ul>';
            html += str;
        };
        $("#J_ip").val(lastIp); //DNS那边更新为最新的ip
    }
    return html;
}

//重买
function serverUpdate() {
    if (!confirm("确定要重买服务器吗？ <br/>重买将删除当前地域下的服务器,重新购买一台指定配置的服务器")) {
        return;
    }
    serverCommit(httpUrl.server_update);
}

//创建
function serverCreate() {
    if (!confirm("确定要购买服务器吗？")) {
        return;
    }
    serverCommit(httpUrl.server_create);
}

//创建
function serverCommit(url) {
    let apikey = $("#apikey").val();
    if (!apikey) {
        alert("请输入apikey");
        return;
    }
    //$("#serverCreate").find(".scriptid").val(scriptid);
    // let params = $("#serverCreate").serializeArray();
    let params = $("#serverCreate").serialize();
    //console.log(params);
    params = customIOS(params); //自定义选择操作系统处理
    //console.log("请求参数："+params);
    ajaxGet(url, params, function(res) {
        let str = "";
        if (res && res.code == 200) {
            //copySubid(res.data);
            console.log("返回结果" + res.data);

            set_select_checked('J_regionId', $("#serverCreate").find(".region option:selected").val());
            //获取一遍
            getServerList();
        } else {
            str = res;
        }
        //$("#buyResult").html("购买结果：" + str);

    })
}

//自定义选择操作系统处理
function customIOS(params) {
    let obj_region = $("#serverCreate").find(".region option:selected");
    let obj_autoReleaseTime = $("#serverCreate").find(".autoReleaseTime option:selected");
    //params.pop();
    //params.push({ name: "number", value: obj.attr("data") });

    //使用镜像模板号
    params += "&number=" + obj_region.attr("data");
    let releaseHour = obj_autoReleaseTime.val();
    if (releaseHour && releaseHour > 0) {
        let autoReleaseTime = new Date(new Date().getTime() + releaseHour * 60 * 60 * 1000);
        params += "&autoReleaseTime=" + formatTime(autoReleaseTime);
    }
    return params;
}



//重启
function serverReboot(SUBID) {
    if (!confirm("确定要重启服务器吗？")) {
        return;
    }
    ajaxPost(httpUrl.server_reboot, {
        regionId: regionId,
        instanceId: instanceId
    }, function(res) {
        console.log(res);
        getResult(res);
    })
}
//重装
function serverReinstall(SUBID) {
    if (!confirm("确定要重装服务器吗？")) {
        return;
    }
    ajaxPost(httpUrl.server_reinstall, {
        regionId: regionId,
        instanceId: instanceId
    }, function(res) {
        console.log(res);
        getResult(res);
    })
}
//销毁服务器
function serverDestroy(regionId, instanceId) {
    if (!confirm("确定要销毁服务器吗？")) {
        return;
    }
    ajaxGet(httpUrl.server_destroy, {
        regionId: regionId,
        instanceId: instanceId
    }, function(res) {
        console.log(res);
        getResult(res);
    })
}

/**
 * 时间格式化 https://blog.csdn.net/yan263364/article/details/80748829 
 * 
 * currentTime时间类型
 * fmt格式化形式
 * eg：frontOneHour(new Date(),'yyyy-MM-dd hh:mm:ss') // "2018-06-20 16:11:59"
 * eg：frontOneHour(new Date(),'yyyy-MM-dd') // "2018-06-20"
 */
function formatTime(currentTime, fmt) {
    if (!fmt) {
        fmt = 'yyyy-MM-dd hh:mm:ss';
    }
    //var currentTime = new Date(new Date().getTime())
    console.log(currentTime) // Wed Jun 20 2018 16:12:12 GMT+0800 (中国标准时间)
    var o = {
        'M+': currentTime.getMonth() + 1, // 月份
        'd+': currentTime.getDate(), // 日
        'h+': currentTime.getHours(), // 小时
        'm+': currentTime.getMinutes(), // 分
        's+': currentTime.getSeconds(), // 秒
        'q+': Math.floor((currentTime.getMonth() + 3) / 3), // 季度
        'S': currentTime.getMilliseconds() // 毫秒
    }
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (currentTime.getFullYear() + '').substr(4 - RegExp.$1.length))
    for (var k in o) {
        if (new RegExp('(' + k + ')').test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (('00' + o[k]).substr(('' + o[k]).length)))
    }
    return fmt;
}

/** 
 * 设置select控件选中 
 * @param selectId select的id值 
 * @param checkValue 选中option的值  
 * eg：set_select_checked('edit-group', group_id);
 */
function set_select_checked(selectId, checkValue) {
    var select = document.getElementById(selectId);

    for (var i = 0; i < select.options.length; i++) {
        if (select.options[i].value == checkValue) {
            select.options[i].selected = true;
            break;
        }
    }
}

//编码
function b64Encode() {
    let str = $("#J_userData").val();
    //let res = btoa(encodeURIComponent(str));
    let res = btoa(unescape(encodeURIComponent(str)));
    $("#J_userData").val(res);
}
//解码
function b64Decode() {
    let str = $("#J_userData").val();
    //let res = decodeURIComponent(atob(str));
    let res = decodeURIComponent(escape(atob(str)));
    $("#J_userData").val(res);
}
//let strChinaBase64 = b64Encode('你好'); // "JUU0JUJEJUEwJUU1JUE1JUJE"
//console.log(b64Decode(strChinaBase64)); // "你好"

//应用当前脚本
function putShell(obj) {
    let str = $(obj).parents(".J_shell").find("textarea").val();
    let res = btoa(unescape(encodeURIComponent(str)));
    $("#J_userData").val(res);
}