
/*
@rem Для использования необходимо положить батник в корень проекта.
@rem Имя файла с результатом должно быть написано тут:
Set TargetQrcName=qGNA.qrc

@rem @echo off && cls
@echo off
set WinDirNet=%WinDir%\Microsoft.NET\Framework
@rem IF EXIST "%WinDirNet%\v2.0.50727\csc.exe" set csc="%WinDirNet%\v2.0.50727\csc.exe"
IF EXIST "%WinDirNet%\v3.5\csc.exe" set csc="%WinDirNet%\v3.5\csc.exe"
IF EXIST "%WinDirNet%\v4.0.30319\csc.exe" set csc="%WinDirNet%\v4.0.30319\csc.exe"
%csc% /nologo /out:"%~0.exe" %0
echo ========================================================================
echo "%~0.exe" %TargetQrcName% >> qrc_build.log
"%~0.exe" %TargetQrcName% >> qrc_build.log
del "%~0.exe"

goto end

*/

using System;
using System.Linq;
using System.Text;
using System.IO;

namespace Test_QrcGenerator
{
    class Program
    {
        static void Main(string[] args)
        {
            string targetFile = "_NO_FILE_NAME_.qrc";
            if (args.Length > 0)
                targetFile = args[0];

            string targetDirectory = AppDomain.CurrentDomain.BaseDirectory;
            string qrcFullPath = Path.Combine(targetDirectory, targetFile);
            string result;
            try
            {
                result =
                "<RCC>\r\n\t<qresource prefix=\"/\">\r\n\t\t"
                + Directory.GetFiles(targetDirectory, "*.*", SearchOption.AllDirectories)
                    .Where(f => f.EndsWith(".qml") || f.EndsWith(".js") || f.EndsWith("qmldir"))
                    .Select(p => p.Remove(0, targetDirectory.Length).Replace('\\', '/'))
                    .OrderBy(q => q)
										.Where(p2 => !p2.StartsWith("Tests/"))
                    .Select(p1 => "<file>" + p1 + "</file>").Aggregate((s, s1) => s + "\r\n\t\t" + s1)
                + "\r\n\t</qresource>\r\n</RCC>";
            }
            catch (Exception ex)
            {
                Console.WriteLine("Fail {0}", ex);
                return;
            }

            File.WriteAllText(qrcFullPath, result, Encoding.UTF8);
            Console.WriteLine("Qrc generation finished. File: {0}", qrcFullPath);
        }
    }
}

/*
:end
*/