Troubleshooting

NVIM Breakpoint issue fix:

.patch file contents:
--- a/lua/dap/session.lua
+++ b/lua/dap/session.lua
@@
-  local path = api.nvim_buf_get_name(bufnr)
+  local path = api.nvim_buf_get_name(bufnr):gsub("/", "\\")

run this command in power shell:
$dap = "$env:LOCALAPPDATA\nvim-data\site\pack\core\opt\nvim-dap"
$patch = "$env:LOCALAPPDATA\nvim\patches\nvim-dap-windows-breakpoints.patch"

git -C $dap apply $patch

then verify with:

git -c $dap diff

Alse utilize the powershell script at:
C:\Users\Eric\AppData\Local\nvim\scripts\apply-local-patches.ps1