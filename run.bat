@echo off
md compiled
rem rd /s /q compiled :: clear cache

echo Compiling Moons...
pushd moons
moonc -t ..\compiled .
popd
echo.
echo Copying raw files...
xcopy /d /y assets_image\*.png compiled\assets\image\
xcopy /d /y /e raw\* compiled
echo.
echo Generating images...
rem for %%i in (assets_image\*) do (
rem 	echo %%~nxi
rem 	set filename=%%~ni
rem 	if "%filename:~-1%"=="#" (
rem 		aseprite -b "%%i" --sheet "compiled/assets/image/%%~ni.png" --data "compiled/assets/image/%%~ni.json"
rem 	) else (
rem 	aseprite -b "%%i" --save-as "compiled/assets/image/%%~ni.png"
rem 	)
rem )
pushd compiled
echo.
echo Starting Game^>^>^>
echo.
love .
popd