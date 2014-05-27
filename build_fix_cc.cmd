/*
@rem Для использования необходимо положить батник в корень проекта.
@rem Имя файла с результатом должно быть написано тут:
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

exit
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
                .Select(x => Path.GetFullPath(x))
                .Where(s => s.EndsWith(".qml") || s.EndsWith(".js"))
                .ToArray();

            foreach (var filename in filenames)
            {
                string qrcPath = Path.GetDirectoryName(filename)
                    .Replace(targetDirectory, "qrc::/")
                    .Replace("\\", "/");

                string content = File.ReadAllText(filename);
                string res = Regex.Replace(content, "Qt.createComponent\\((.+?)\\)", "Qt.createComponent('" +qrcPath + "/' + $1)");
                
                if (res != content)
                {
                    File.WriteAllText(filename, res);  
                }
            }
        }
    }
}