@echo off
setlocal enabledelayedexpansion

REM ------------------------------------------------------------
REM Analyze all VHD/VHDL files in this Lab4 folder using GHDL
REM Usage:
REM   analyze_lab4.bat          -> analyze all files
REM   analyze_lab4.bat clean    -> delete *.cf first, then analyze
REM Return code: 0 = success, 1 = failure
REM ------------------------------------------------------------

set "SCRIPT_DIR=%~dp0"
pushd "%SCRIPT_DIR%"

echo ==========================================
echo   GHDL analyze (Lab4) in: %CD%
echo   GHDL: expecting in PATH
echo   Standard: --std=08 (VHDL-2008)
echo ==========================================

set "GHDL_STD=--std=08"
set "ERR=0"

if /I "%1"=="clean" (
  echo Cleaning: removing previous analysis files (*.cf)...
  del /Q /F *.cf 2>nul
)

REM Analyze .vhd files (sorted)
for /f "usebackq delims=" %%F in (`dir /b /on *.vhd 2^>nul`) do (
  echo [GHDL] Analyzing %%F
  ghdl -a %GHDL_STD% "%%F"
  if errorlevel 1 (
    echo [ERROR] Failure analyzing: %%F
    set ERR=1
    goto :end
  )
)

REM Analyze .vhdl files (sorted)
for /f "usebackq delims=" %%F in (`dir /b /on *.vhdl 2^>nul`) do (
  echo [GHDL] Analyzing %%F
  ghdl -a %GHDL_STD% "%%F"
  if errorlevel 1 (
    echo [ERROR] Failure analyzing: %%F
    set ERR=1
    goto :end
  )
)

echo.
if "%ERR%"=="0" (
  echo [OK] SUCCESS: All files analyzed without errors.
) else (
  echo [FAIL] Errors occurred during analysis.
)

:end
popd
exit /b %ERR%
