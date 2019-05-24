
 rsGen - An Universal Reverse Shell Command Genrator.
 =

  rsGen is an universal reverse shell command genrator based on Widows Batch and  Jscript hybrids. Not only supports the generation of raw Reverse shell commands, but also supports the generation of a "Transfer command" form of a reverse shell command.
  
>"Transfer command": Similar to the rat to find the IP, upload the command to the pastebin website, and then use the tools such as curl/wget/certutil to remotely request the execution of the command.

## Usage
By default, rsGen needs to provide at least two parameters for the IP and port of the reverse shell. If no parameters are provided, the default output help information.

`-pub` &nbsp;&nbsp; Generate a "transfer command".

    PS:Using this parameter, the command will be uploaded and the encoded command will be uploaded to the public pastebin website (currently two interfaces are provided: p.ip.fi and dpaste.com).  
`-lan` &nbsp;&nbsp; In some cases, the target machine cannot request an external network.

    PS:This parameter will call mongoose.exe in the command directory (a mini web server, only 144kb, see the website: https://cesanta.com/), enable a web service on the local port 80 for command request execution. After the tool is used, you need to manually exit it.
`-listen` Enable port listening locally to receive shells that bounce back.

    PS:Enable port listening locally to receive a shell that bounces back, functioning the same as netcat (calling powercat.ps1).
![rsGen](https://raw.githubusercontent.com/FlyfishSec/rsGen/master/Usage/rsGen.gif "rsGen.gif")

## Environmental needs

   A Windows 7 or higher operating system.

## Q&A
>Q:Does your tool contain all the methods of XX in the reverse shell on the Internet?

>A: No, currently this tool is only used to generate common reverse shell commands, as well as "transfer commands". Various lua, perl, java, etc., or reverse commands are not added.

>Q: What is the meaning of "transfer commands"?

>A：Shorten the raw command, and effectively avoid the command execution failure caused by unknown factors such as URL transcoding/application interface transcoding error in the native command when some code execution interface/command blind execution is encountered.

>Q: What is your tool testing environment? Support for Windows 2003 and Windows XP?

>A：(1) About the tool: Test environment I use Windows10 and Windows 7, and I recommend using Widows10 for better experience (Win10 supports ANSI color display, Win7 does not use color output all). Windows XP and 2003 are not compatible, and can be used theoretically, but the "transfer command" is definitely abolished because the function part calls powershell.
(2) About the generated command: WinXP and Win2003 are not currently supported. It has been tested in the environment of Windows Server 2012 with Thinkphp5.x code execution, Linux server with weblogic anti-sequence command blind execution, Struts command execution, etc. Get the shell.

## TODO
   
   * Add more reverse shell commands.

   * Code Optimization & BUG Fix.

   * Try adding a similar ngrok public server for NAT-free mapping, no VPS, and easy to receive shells.

## BUG Feedback & Advice
Flyfish#lcx.cc
