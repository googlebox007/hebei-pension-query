Set WshShell = CreateObject("WScript.Shell")
strDesktop = WshShell.SpecialFolders("Desktop")
Set oShellLink = WshShell.CreateShortcut(strDesktop & "\河北养老认证查询工具.lnk")
oShellLink.TargetPath = WScript.Arguments(0)
oShellLink.WorkingDirectory = WScript.Arguments(1)
oShellLink.Description = "河北省养老保险待遇资格认证查询工具"
oShellLink.Save 