#r "nuget: System.Text.Encoding.CodePages, 4.7.0"

using System.Linq;

// 本脚本用于将 gbk 编码的文件批量转换为 utf-8 编码

Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);

var files = Directory.GetFiles("./src/", "*.*", SearchOption.AllDirectories);

foreach (var (file, text) in from file in files
                             let text = File.ReadAllText(file, Encoding.GetEncoding("GB2312"))
                             select (file, text))
{
    System.IO.File.WriteAllText(file, text, Encoding.UTF8);
}
