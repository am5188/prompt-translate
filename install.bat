@echo off
rem prompt-translate 跨 harness 安装脚本（Windows 版）
rem 用法: 双击本文件，或 install.bat --list 查看状态
setlocal enabledelayedexpansion
set SRC=%~dp0skills\prompt-translate\SKILL.md

if not exist "%SRC%" (
  echo 错误: 找不到 %SRC%
  exit /b 1
)

if /i "%~1"=="--list" (
  call :chk "%USERPROFILE%\.claude\skills\prompt-translate"
  call :chk "%USERPROFILE%\.codex\skills\prompt-translate"
  call :chk "%USERPROFILE%\.agents\skills\prompt-translate"
  call :chk "%USERPROFILE%\.gemini\skills\prompt-translate"
  call :chk "%USERPROFILE%\.cursor\skills\prompt-translate"
  exit /b 0
)

call :inst "%USERPROFILE%\.claude\skills\prompt-translate"  Claude Code
call :inst "%USERPROFILE%\.codex\skills\prompt-translate"   Codex CLI
call :inst "%USERPROFILE%\.agents\skills\prompt-translate"  Codex/Gemini/Cursor 通用
call :inst "%USERPROFILE%\.gemini\skills\prompt-translate"  Gemini CLI
call :inst "%USERPROFILE%\.cursor\skills\prompt-translate"  Cursor

echo.
echo 完成。客户端未安装时目录留空也无害，装上客户端即可生效。
exit /b 0

:inst
if not exist "%~1" mkdir "%~1"
copy /y "%SRC%" "%~1\SKILL.md" >nul
echo 已安装  %~1  ^(%~2^)
goto :eof

:chk
if exist "%~1\SKILL.md" (echo 已安装  %~1) else (echo 未安装  %~1)
goto :eof
