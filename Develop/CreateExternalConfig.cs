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
                    .Where(p2 => p2.StartsWith("ExternalConfig/"))
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
