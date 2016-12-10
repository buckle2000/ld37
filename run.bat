@echo off
echo Compiling Moons...
rd /s /q compiled
md compiled
pushd moons
moonc -t ..\compiled .
popd
echo.
echo Copying raw files...
xcopy /e raw\* compiled
echo.
echo Generating images...
for %%i in (assets_image\*) do (
echo %%~nxi
aseprite -b %%i --save-as compiled/assets/image/%%~ni.png
)
pushd compiled
echo.
echo Starting Game^>^>^>
echo.
love .
popd