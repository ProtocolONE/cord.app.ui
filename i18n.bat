mkdir i18n
SET lupdate=%QTDIR%\bin\lupdate.exe
SET UpdateConfig= -no-obsolete -locations absolute
Set TsTool=QtTsTool.exe

%lupdate% %UpdateConfig% . -ts ./i18n/qml_en.ts
%lupdate% %UpdateConfig% . -ts ./i18n/qml_ru.ts

%TsTool% sort ./i18n/qml_en.ts
%TsTool% sort ./i18n/qml_ru.ts

%TsTool% fixKeys ./i18n/qml_ru.ts

%QTDIR%\bin\lconvert.exe ./i18n/qml_ru.ts -o ./i18n/qml_ru.qm
%QTDIR%\bin\lconvert.exe ./i18n/qml_en.ts -o ./i18n/qml_en.qm

