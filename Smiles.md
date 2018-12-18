# Smiles

There is in repository pre built version of simles.rcc.

To update smile you should download files from `https://github.com/Ranks/emojione/tree/master/assets/png`
to `<sourceRoot>\Develop\Assets\Smiles\`

Than run script to generate resource file:

```sh
rcc.exe -compress 3 -threshold 4 -binary  smiles.qrc" -o smiles.rcc
```
