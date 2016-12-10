rd /s /q compiled
md compiled
pushd moons
moonc -t ..\compiled .
popd
xcopy /s raw\* compiled
pushd compiled
love .
popd