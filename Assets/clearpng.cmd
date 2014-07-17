pushd "...\Images"
for /r %%x in (*.png) do pngcrush -brute -ow "%%x"
popd