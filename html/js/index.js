var constant = {
    //baseUrl: 'https://api.vultr.com/',
    //baseUrl: 'http://localhost:2222/', //本地代理
    baseUrl: 'http://sunjc.top:2222/', //服务器代理
    oldTime: ""
}

var httpUrl = {
    plans_list: constant.baseUrl + 'v1/plans/list', //服务器价格

    server_list: constant.baseUrl + 'v1/server/list', //服务器列表
    server_create: constant.baseUrl + 'v1/server/create',
    server_reboot: constant.baseUrl + 'v1/server/reboot',
    server_reinstall: constant.baseUrl + 'v1/server/reinstall',
    server_destroy: constant.baseUrl + 'v1/server/destroy', //销毁服务器
    startupscript_create: constant.baseUrl + 'v1/startupscript/create', //创建启动脚本
    startupscript_destroy: constant.baseUrl + 'v1/startupscript/destroy', //创建启动脚本
    startupscript_list: constant.baseUrl + 'v1/startupscript/list', //获取启动脚本列表

    dns_update: 'http://sunjc.top:7110/script/v1/dns/update', //更新DNS
}

function getApiKey() {
    return $("#apikey").val();
}

function getAppId() {
    return $("#appid").val();
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
            request.setRequestHeader("API-Key", getApiKey());
            request.setRequestHeader("appid", getAppId());
        },
        //调用执行后调用的函数，无论成功或失败都调用
        complete: function(XMLHttpRequest, textStatus) {
            if (textStatus == 'timeout') {
                if (error_callback != null && error_callback != "") {
                    error_callback();
                };
            }
        },
        success: function(list) {
            callback(list);
        },
        error: function() {
            console.error("请求失败");
        }
    });
}

/**自动更新 dns */
function autoUpdateDns(subid) {
    let maxTime = 5;
    var fader = setInterval(function() {
        ajaxGet(httpUrl.server_list, null, function(res) {
            if (res && res.length != 0) {
                let address = "";
                let index = -1;
                for (let key in res) {
                    address = res[key].main_ip;
                    index++;
                }
                if (address && address.length > 3 && address != "0.0.0.0") {
                    let name = index == 0 ? "app" : "app" + index;
                    updateDns(address, name);
                    clearInterval(fader);
                }
            }
        });
        if (maxTime < 1) {
            clearInterval(fader);
        }
        maxTime--;
    }, 1000);
}

//更新dns
function updateDns(ip, name) {
    let param = "name=" + name + "&ip=" + ip + "&config=aliyunConfigUser2&domain=disanshijie.top";
    ajaxGet(httpUrl.dns_update, param, function(res) {
        let str = "";
        if (res && res.code == 200) {
            console.log("返回结果" + res.data);
            alert("执行成功");
            return;
        } else {
            str = res.msg;
        }
    });
}

function getPlansList(params) {
    ajaxGet(httpUrl.plans_list, null, function(res) {
        console.log(res);
        getResult(res);
    })
}
//获取服务器列表
function getServerList(params) {
    $("#server-list").html("<p style='color:red;'>获取中...</p>");
    //alert("获取中...");
    let time = (new Date().getTime() - constant.oldTime) / 1000;
    constant.oldTime = new Date();
    let timeStr = "<p>距上次刷新" + time + "秒</p>";
    ajaxGet(httpUrl.server_list, null, function(res) {
        let str = "<p style='color:red;'>获取数据失败...</p>";
        if (res) {
            if (res.length == 0) {
                str = "<p style='color:red;'>没有...</p>";
            } else {
                str = serverList(res);
            }
        }
        $("#server-list").html(timeStr + str);
        ////setTimeout(function() {}, 5 * 1000);
    })
}


var serverList = (data) => {
    let html = "";
    if (data) {
        for (let key in data) {
            let str = '';
            str += '<ul class="">';
            str += '	<li>ip：<a class="a-ip">' + data[key].main_ip + '</a></li>';
            str += '	<li>密码：<a class="a-pw">' + data[key].default_password + '</a></li>';
            str += '	<li>SUBID：<a class="a-subid">' + key + '</a></li>';
            str += '	<li>月费：<a class="a-price">' + data[key].cost_per_month + '</a></li>';
            str += '	<li>地址：<a class="a-price">' + data[key].location + '</a></li>';
            str += '	<li>系统：<a class="a-price">' + data[key].os + '</a></li>';
            str += '	<li>IPv6：<a class="a-price">' + data[key].v6_main_ip + '</a></li>';
            str += '	<li>创建时间：<a class="a-date">' + data[key].date_created + '</a></li>';
            // str += '	<li><a class="a-control" href="' + data[key].main_ip + '" target="_blank">搜索引擎</a></li>';
            str += '	<li>状态：<a class="a-status">' + data[key].status + '</a> <a href="http://' + data[key].main_ip + '/index.html" target="_blank">测试</a></li>';
            str += '	<li><a class="a-control" href="' + data[key].kvm_url + '" target="_blank">打开控制台</a></li>';
            str += '	<li></li>';
            str += '	<li><button style="width: 10%;" class="a-control" onclick="updateDns(\'' + data[key].main_ip + '\',\'app\')">更新DNS</button></li>';
            str += '	<button onclick="serverReboot(' + key + ')">重启</button>';
            str += '	<button onclick="serverReinstall(' + key + ')">重装</button>';
            str += '	<button onclick="serverDestroy(' + key + ')">销毁</button>';
            str += '</ul>';
            html += str;
        };
    }
    return html;
}

//创建
function serverCreate() {
    if (!confirm("确定要购买服务器吗？")) {
        return;
    }

    let apikey = $("#apikey").val();
    let scriptid = $("#scriptid").val();
    if (!apikey) {
        alert("请输入apikey");
        return;
    }
    if (!scriptid) {
        alert("请输入scriptid");
        if (!confirm("没有输入scriptid,确定要购买服务器吗？,启动后将不运行任何命令")) {
            return;
        }
    }

    $("#serverCreate").find(".scriptid").val(scriptid);
    let params = $("#serverCreate").serializeArray();
    //console.log(params);

    params = customIOS(params); //自定义选择操作系统处理

    ajaxPost(httpUrl.server_create, params, function(res) {
        let str = "";
        if (res && res.SUBID) {
            copySubid(res.SUBID);
            str = res.SUBID;
        } else {
            str = res;
        }
        $("#buyResult").html("购买结果：" + str);
        //查询一下结果
        getServerList();
    })
}

//自定义选择操作系统处理
function customIOS(params) {
    let obj = $("#serverCreate").find(".osid option:selected");
    let osid = obj.val();

    if (osid == '164') {
        params.pop();
        params.push({ name: "SNAPSHOTID", value: obj.attr("data") });
        autoUpdateDns(); //自动更新dns
    } else if (osid == '159') { //ISOID
        params.push({ name: "ISOID", value: obj.attr("data") });
    } else if (osid == '186') { //APPID
        params.push({ name: "APPID", value: obj.attr("data") });
    }
    return params;

}


//重启
function serverReboot(SUBID) {
    if (!confirm("确定要重启服务器吗？")) {
        return;
    }
    ajaxPost(httpUrl.server_reboot, {
        SUBID: SUBID
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
        SUBID: SUBID
    }, function(res) {
        console.log(res);
        getResult(res);
    })
}
//销毁服务器
function serverDestroy(SUBID) {
    if (!confirm("确定要销毁服务器吗？")) {
        return;
    }
    ajaxPost(httpUrl.server_destroy, {
        SUBID: SUBID
    }, function(res) {
        console.log(res);
        getResult(res);
    })
}
//获取脚本列表
function startupscriptList() {
    $("#scriptIdList").html("<p>获取中...</p>");
    ajaxGet(httpUrl.startupscript_list, null, function(res) {
        let str = scriptListHtml(res);
        $("#scriptIdList").html(str);
        //setTimeout(function() {}, 5 * 1000);
    })
}

var scriptListHtml = (data) => {
    let html = "";
    if (data) {
        for (let key in data) {
            var str = '';
            str += '<tr>';
            str += '	<td>' + data[key].SCRIPTID + '</td>';
            str += '	<td>' + data[key].name + '</td>';
            str += '	<td>' + data[key].type + '</td>';
            str += '	<td><p style="max-width:100px;overflow:hidden">' + data[key].script + '</p></td>';
            str += '	<td><button style="width:" onclick="copyScript(' + data[key].SCRIPTID + ')">使用</button> ';
            str += '	<button style="width:" onclick="startupscriptDestroy(' + data[key].SCRIPTID + ')">删除</button></td>';
            str += '</tr>';
            html += str;
        };
    }
    return html;
}

//创建启动脚本
function startupscriptCreate(obj) {
    let form = $("#startupscriptForm");

    let script = $("#J_script").val();
    if (script.length < 5) {
        return;
    }

    $(obj).prop("disabled", "true");
    console.log("创建中...");
    //console.log("创建中..." + httpUrl.startupscript_create);
    ajaxPost(httpUrl.startupscript_create, {
        name: $("#J_name").val(),
        type: $("#J_type").val(),
        script: $("#J_script").val()
    }, function(res) {
        console.log(res);
        if (res && res.SCRIPTID) {
            alert("创建成功：" + res.SCRIPTID);
        } else {
            alert("创建失败：" + res);
        }
        //getResult(res);
    })
}

//删除启动脚本
function startupscriptDestroy(SCRIPTID) {
    if (!confirm("确定要删除启动脚本吗？删除后请手动刷新")) {
        return;
    }
    ajaxPost(httpUrl.startupscript_destroy, {
        SCRIPTID: SCRIPTID
    }, function(res) {
        console.log(res);
        if (res) {
            alert("结果：" + res);
        }
        //getResult(res);
    })
}