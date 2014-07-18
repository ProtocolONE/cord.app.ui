pushd "...\Images"
for /r %%x in (*.png) do pngcrush -force -rem tEXt -rem iTXt -ow "%%x"
popd