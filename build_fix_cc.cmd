/*
@rem Для чего нужен этот препроцессор.

@rem ==============================================================================================================
@rem В этом файле 2 варианта препроцессинга и они практически идентичны. Для того, чтобы работал первый
@rem случай нужно прописать в с++ части проекта в importPath хак с qrc импортом (":/") - в этом случае начинают
@rem работать импорты модулей в qml файлах, однако для создания qml из js через Qt.createComponent требуется
@rem использовать аобсолютные пути внутри qrc файлов. В этом случае есть ограничения на то, что все виды 
@rem использования Loader тоже требуют подстановки хака с qrc. Поэтому прямо сейчас используется второй вариант.

@rem Второй вариант напротив синтаксический "сахар" с модулями заменяет на ручное подключение папки, игнорируя
@rem модули и qmldir. Это не требует замены для Qt.createComponent, однако вызывает сложности с разрешением версий
@rem в модулях, потому, что при простом иморте это не работает. Этот препроцессинг это и делает.  
@rem ==============================================================================================================
*/

/*
@rem ==============================================================================================================
@rem Для использования необходимо положить батник в корень проекта.
@rem Имя файла с результатом должно быть указано в первом параметре.
@rem ==============================================================================================================

Set TargetPath=%1

@rem @echo off && cls
@echo off
set WinDirNet=%WinDir%\Microsoft.NET\Framework
@rem IF EXIST "%WinDirNet%\v2.0.50727\csc.exe" set csc="%WinDirNet%\v2.0.50727\csc.exe"
IF EXIST "%WinDirNet%\v3.5\csc.exe" set csc="%WinDirNet%\v3.5\csc.exe"
IF EXIST "%WinDirNet%\v4.0.30319\csc.exe" set csc="%WinDirNet%\v4.0.30319\csc.exe"
%csc% /nologo /out:"%~0.exe" %0
echo ========================================================================
echo "%~0.exe" %TargetQrcName%
"%~0.exe" %TargetPath%
del "%~0.exe"

goto end

*/

using System;
using System.Linq;

namespace Build_Fix_CreateComponent_Qrc_Bug
{
    using System.IO;
    using System.Text.RegularExpressions;

    class Program
    {
        static void Main(string[] args)
        {
            string targetDirectory = args.Length > 0
                ? args[0] 
                : AppDomain.CurrentDomain.BaseDirectory;

            if (!Path.IsPathRooted(targetDirectory))
            {
                 targetDirectory = new Uri(Path.Combine(Directory.GetCurrentDirectory(), targetDirectory)).LocalPath;
            }

            string[] filenames = Directory.GetFiles(targetDirectory, "*.*", SearchOption.AllDirectories)
                .Select(Path.GetFullPath)       
                .Where(s => s.EndsWith(".qml") || s.EndsWith(".js"))
                .ToArray();

/*
            foreach (var filename in filenames)
            {
                string qrcPath = Path.GetDirectoryName(filename)
                    .Replace(targetDirectory, string.Empty);

                qrcPath = qrcPath.Split(new[] { "\\" }, 0)
                    .Aggregate((s, s1) => s + "../");
                
                string content = File.ReadAllText(filename);
                string res = Regex.Replace(content, @"import ((?!qGNA)(\w+(?=\.))([\w\.]+)) \d+\.\d+", match => "import \"" + qrcPath + match.Groups[1].ToString().Replace(".", "/") + "\"");

                if (res != content)
                {
                    File.WriteAllText(filename, res);  
                }
            }
*/

/*
            foreach (var filename in filenames)
            {
                string qrcPath = Path.GetDirectoryName(filename)
                    .Replace(targetDirectory, "qrc:")
                    .Replace("\\", "/");

                string content = File.ReadAllText(filename);
                string res = Regex.Replace(content, "Qt.createComponent\\((.+?)\\)", "Qt.createComponent('" +qrcPath + "/' + $1)");

                if (res != content)
                {
                    File.WriteAllText(filename, res);  
                }
            }
*/
            Console.WriteLine("Preprocess finished.");
        }
    }
}


/*
:end
*/
