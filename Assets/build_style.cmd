/*
@rem @echo off && cls
@echo off
set WinDirNet=%WinDir%\Microsoft.NET\Framework
@rem IF EXIST "%WinDirNet%\v2.0.50727\csc.exe" set csc="%WinDirNet%\v2.0.50727\csc.exe"
IF EXIST "%WinDirNet%\v3.5\csc.exe" set csc="%WinDirNet%\v3.5\csc.exe"
IF EXIST "%WinDirNet%\v4.0.30319\csc.exe" set csc="%WinDirNet%\v4.0.30319\csc.exe"
%csc% /nologo /out:"%~0.exe" %0
echo ========================================================================
echo "%~0.exe"
"%~0.exe" 
del "%~0.exe"

goto end

*/

using System;
using System.IO;
using System.Text.RegularExpressions;

namespace Test_QrcGenerator
{
    class Program
    {
        static void Main(string[] args)
        {
    string output = @"{
    ""id"": ""mainStyle"",
    ""default"": true,
    ""name"": {
        ""ru"": ""..."",
        ""en"": ""..."",
    },
    ""styles"": {
";

            string sourceData = File.ReadAllText(@"..\Application\Core\Styles\Styles.qml");
            MatchCollection matches = Regex.Matches(sourceData, "property color (.+?): [\"'](.+)[\"']");

            for (int i = 0; i < matches.Count; i++)
            {
                output += "        " + "\"" 
                    + matches[i].Groups[1].Value + "\": \"" 
                    + matches[i].Groups[2].Value.Replace("'", "\"")
                    + "\""  
                    + ((i + 1 !=  matches.Count) ? "," : "") 
                    + "\r\n";
            }
            output += "    }\r\n";
            output += "}";

            Console.WriteLine(output);
            File.WriteAllText("output.style", output);  
        }
    }
}

/*
:end
*/