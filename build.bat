@echo off

echo /============ PREPARE =============
echo /

xcopy .\amxmodx\scripting\include C:\AmxModX\1.9.0\include /s /e /y
xcopy .\amxmodx\scripting\include C:\AmxModX\1.10.0\include /s /e /y

if exist .\amxmodx\plugins rd /S /q .\amxmodx\plugins
mkdir .\amxmodx\plugins
cd .\amxmodx\plugins

echo /
echo /
echo /============ COMPILE =============
echo /

for /R ..\scripting\ %%F in (*.sma) do (
    echo / /
    echo / / Compile %%~nF:
    echo / /
    amxx190 %%F
)

echo /
echo /
echo /============ BUILD =============
echo /

cd ..\..
mkdir .\.build\UAFKM-Kicker\amxmodx\scripting\

xcopy .\amxmodx\ .\.build\UAFKM-Kicker\amxmodx\ /s /e /y
copy .\README.md .\.build\

if exist .\UAFKM-Kicker.zip del .\UAFKM-Kicker.zip
cd .\.build
zip -r .\..\UAFKM-Kicker.zip .
cd ..
rmdir .\.build /s /q

echo /
echo /
echo /============ END =============
echo /

set /p q=