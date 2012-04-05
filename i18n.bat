mkdir i18n
%QTDIR%\bin\lupdate.exe . -ts ./i18n/qml_ru.ts
%QTDIR%\bin\lupdate.exe . -ts ./i18n/qml_en.ts

%QTDIR%\bin\lconvert.exe ./i18n/qml_ru.ts -o ./i18n/qml_ru.qm
%QTDIR%\bin\lconvert.exe ./i18n/qml_en.ts -o ./i18n/qml_en.qm
