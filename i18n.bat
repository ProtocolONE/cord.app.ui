mkdir i18n
SET lupdate=%QTDIR%\bin\lupdate.exe
SET UpdateConfig= -no-obsolete -locations absolute

%lupdate% %UpdateConfig% . -ts ./i18n/qml_en.ts
%lupdate% %UpdateConfig% . -ts ./i18n/qml_ru.ts

@rem Test_TranslateConverter.exe sort ./i18n/qml_en.ts
@rem Test_TranslateConverter.exe sort ./i18n/qml_ru.ts

@rem Test_TranslateConverter.exe fixKeys ./i18n/qml_ru.ts

%QTDIR%\bin\lconvert.exe ./i18n/qml_ru.ts -o ./i18n/qml_ru.qm
%QTDIR%\bin\lconvert.exe ./i18n/qml_en.ts -o ./i18n/qml_en.qm
