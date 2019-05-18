
 rsGen - An Universal Reserve Shell Command Genrator.
 =

  rsGen 是一款基于Widows BAT&JS混编实现的多功能反弹shell命令生成器。不仅支持生成原生反弹shell命令，还支持生成“命令中转”形式的一句话反弹shell命令。
  
>“中转命令” ：类似于远控上线找IP，将命令上传至pastebin类网站，然后使用curl/wget/certutil等工具远程请求执行命令。

## Usage
rsGen默认至少需要提供用于反弹接收的IP和端口两个参数，如若不提供任何参数，默认输出帮助信息。

![rsgen](https://github.com/FlyfishSec/rsGen/blob/master/Usage/rsgen_default.png "rsgen_default")  

仅生成原生格式反弹shell命令。

![rsgen](http://rsgen_raw.png)  

-pub 参数，生成“中转命令”。
    PS:使用该参数，将执行命令上传，并将编码后的命令上传至公共pastebin网站(目前提供了两个接口:p.ip.fi和dpaste.com)。
    
-lan 参数，用于有些情况下目标机器无法请求外网。

    PS:该参数会同时调用command目录下mongoose.exe(一个迷你的web服务器，仅144kb，详见官网：https://cesanta.com/),在本地80端口启用一个web服务，用于命令请求执行。工具使用完后，需要手动退出。

  -listen 参数，在本地启用端口监听，用于接收反弹回来的shell

    PS:在本地启用端口监听，用于接收反弹回来的shell，功能等同于netcat(调用powercat.ps1)。
rsgen_listen.png

## 环境需求

   一台Windows 7以上的操作系统。

## Q&A
>Q:你这个工具包含了网上最全的反弹shell的XX中方法吗？

>A: 并没有，本工具仅用于生成常用的反弹shell命令，以及“中转命令”，各种lua、perl、java等少见或反弹命令较长的暂时没有添加。

>Q: “命令中转”的意义是什么？

>A：缩短原生命令，同时有效避免在碰到一些代码执行接口/命令盲执行等情况下，原生命令中特殊字符因URL转码/应用接口转码报错等未知因素导致的命令执行失败。

>Q: 你这个工具测试环境是什么？支持Windows 2003和Windows XP吗？

>A：（1）关于工具：测试环境我用的Windows10 和Windows 7，同时建议使用Widows10以获得较佳体验(Win10支持ANSI彩显，Win7未全部使用彩色输出)。Windows XP及2003未做兼容，理论上也可以用，但是“中转命令”肯定废了，因为该功能部分调用powershell实现。
（2）关于生成的命令：目前不支持WinXP和Win2003，已在存在Thinkphp5.x代码执行的Windows Server 2012、存在weblogic反序列命令盲执行的Linux服务器、Struts命令执行等环境进行测试，均可快速获得shell。

## TODO
   
   添加更多的反弹命令

   代码优化&BUG修复

   尝试添加类似ngrok公共服务器，用于无NAT映射、无VPS亦可轻松接收shell

## BUG反馈&改进建议 
Flyfish#lcx.cc
