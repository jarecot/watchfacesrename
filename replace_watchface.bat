@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1

:: Initialize variables
set "binCount=0"
set "tempFile="
set "replacementFile="

:: Count and classify .bin files
for %%f in (*.bin) do (
    set /a binCount+=1
    echo %%f | findstr /b /c:"temp_" >nul
    if !errorlevel! equ 0 (
        set "tempFile=%%f"
    ) else (
        set "replacementFile=%%f"
    )
)

:: Verify total number of .bin files
if not !binCount! == 2 (
    echo ❌ ERROR: Found !binCount! .bin files.
    echo There must be exactly 2 .bin files in the folder:
    echo - One starting with "temp_"
    echo - One with any other name to use as the custom watchface.
    echo.

    if "!tempFile!"=="" (
        echo ⚠️ No file starting with "temp_" was found.
    )

    if "!replacementFile!"=="" (
        echo ⚠️ No .bin file was found to be used as replacement.
    )

    pause
    goto :eof
)

:: Validate that both files were properly identified
if "!tempFile!"=="" (
    echo ❌ ERROR: Two .bin files were found, but none starts with "temp_".
    pause
    goto :eof
)

if "!replacementFile!"=="" (
    echo ❌ ERROR: Two .bin files were found, but the replacement file was not detected.
    pause
    goto :eof
)

:: Feedback and execution
echo ✅ Replacement file identified: !replacementFile!
echo 🔄 Replacing the content of "!tempFile!" with "!replacementFile!"...
copy /Y "!replacementFile!" "!tempFile!" >nul

echo ✅ Operation completed successfully.
pause
