# Neovim Windows Development Environment — Field Guide

> A practical reference for returning to this Neovim setup after weeks or months away.
>
> Primary environment: Windows 10 Pro, Neovim 0.12.5, native `vim.pack` package management.

---

## 1. What This Setup Is For

This Neovim environment is designed to support:

- Java development with Gradle and JDTLS
- C and C++ development with Clang/LLVM, CMake, Ninja, and LLDB
- Python development with basedpyright, Ruff, and debugpy
- Lua development for both Neovim configuration and future game scripting
- Security engineering / detection engineering work
- Log analysis
- JSON / YAML / Markdown / JavaScript / TypeScript editing
- Git-centric development

The design goal is intentionally modular: Neovim provides the editor and orchestration layer, while external tools provide compilers, formatters, language servers, debuggers, and security utilities.

---

# 2. Important Paths

## Neovim

```text
Config: C:\Users\Eric\AppData\Local\nvim
Data:   C:\Users\Eric\AppData\Local\nvim-data
```

Main configuration structure:

```text
nvim/
├── init.lua
└── lua/
    ├── config/
    │   ├── options.lua
    │   ├── keymaps.lua
    │   ├── lsp.lua
    │   └── java.lua
    └── plugins/
        ├── treesitter.lua
        ├── telescope.lua
        ├── completion.lua
        ├── formatting.lua
        ├── git.lua
        ├── dap.lua
        ├── java.lua
        ├── candela.lua
        └── colorscheme.lua
```

## Development directories

```text
C:\Users\Eric\Dev
C:\Users\Eric\Tools
```

Important standalone tools currently live under `C:\Users\Eric\Tools`.

---

# 3. Core Neovim Concepts

## Leader key

The leader key is **Space**.

```lua
vim.g.mapleader = " "
vim.g.maplocalleader = " "
```

When this document says `Space f`, press Space and then `f`.

## Native package management

This setup uses Neovim's built-in `vim.pack` package manager rather than Lazy.nvim or another plugin manager.

Typical plugin installation pattern:

```lua
vim.pack.add({
    "https://github.com/OWNER/REPOSITORY",
})
```

Plugin data is stored beneath:

```text
C:\Users\Eric\AppData\Local\nvim-data\site\pack\core\opt
```

Do not treat `nvim-data` as the primary configuration backup. The important files to version-control are under `AppData\Local\nvim`.

---

# 4. Keybind Reference

## General

| Key | Action |
|---|---|
| `Space w` | Save current file |
| `Space q` | Quit current window |
| `Esc` | Clear search highlighting |
| `Ctrl-h` | Move to window on the left |
| `Ctrl-j` | Move to window below |
| `Ctrl-k` | Move to window above |
| `Ctrl-l` | Move to window on the right |

## Formatting

| Key | Action |
|---|---|
| `Space f` | Format current buffer using Conform |

Formatting is global and does **not** depend on an LSP being attached.

## Telescope

| Key | Action |
|---|---|
| `Space f f` | Find files |
| `Space f g` | Live grep through project using ripgrep |
| `Space f b` | Find open buffers |
| `Space f s` | Search document symbols |
| `Space e` | Browse the project structure |

## LSP navigation and diagnostics

| Key | Action |
|---|---|
| `K` | Hover documentation |
| `g d` | Go to definition |
| `g D` | Go to declaration |
| `g i` | Go to implementation |
| `g r` | Find references |
| `Space r n` | Rename symbol |
| `Space c a` | Code action |
| `Space d` | Open diagnostic details |
| `[ d` | Previous diagnostic |
| `] d` | Next diagnostic |

Useful LSP health check:

```vim
:checkhealth vim.lsp
```

`LspInfo` is not relied on in this Neovim configuration.

## Completion — blink.cmp

| Key | Action |
|---|---|
| `Tab` | Advance snippet placeholder / fallback |
| `Shift-Tab` | Move backward through snippet placeholders / fallback |

Completion sources include:

- LSP
- filesystem paths
- current buffer
- snippets

## Git — Gitsigns

| Key | Action |
|---|---|
| `] h` | Next Git hunk |
| `[ h` | Previous Git hunk |
| `Space h p` | Preview current hunk |
| `Space h s` | Stage current hunk |
| `Space h r` | Reset current hunk |
| `Space h b` | Blame current line |

## Debugging — nvim-dap

| Key | Action |
|---|---|
| `Space d c` | Start / continue debugging |
| `Space d n` | Step over |
| `Space d i` | Step into |
| `Space d o` | Step out |
| `Space b` | Toggle breakpoint |
| `Space B` | Conditional breakpoint |
| `Space d u` | Toggle DAP UI |

The DAP UI opens automatically when a debug session starts and closes when the session terminates/exits.

Useful debugging commands:

```vim
:DapShowLog
:DapSetLogLevel TRACE
```

## Candela log analysis

| Key | Action |
|---|---|
| `Space c u` | Toggle Candela UI |

Useful commands:

```vim
:Candela help
:Candela health
:Candela add
:Candela lightbox
```

---

# 5. Installed Neovim Plugins

## nvim-treesitter

Provides syntax-tree based parsing and highlighting.

Configured languages include or are intended to include:

```text
bash
c
cpp
cmake
dockerfile
go
html
java
javascript
json
lua
markdown
markdown_inline
powershell
python
query
regex
sql
toml
typescript
vim
vimdoc
yaml
```

Use Treesitter for syntax-aware highlighting and parsing. It is distinct from formatting and LSP functionality.

## telescope.nvim + plenary.nvim

Fuzzy finder for:

- files
- buffers
- text search
- LSP/document symbols

`ripgrep` is installed and powers live grep.

`fd` is also installed for fast filesystem searching.

## blink.cmp + blink.lib + friendly-snippets

Completion engine.

Provides:

- LSP completion
- path completion
- buffer completion
- snippets
- automatic documentation display

## conform.nvim

Formatting orchestrator.

Current formatter mapping:

| File type | Formatter |
|---|---|
| Lua | StyLua |
| Python | Ruff |
| C | clang-format |
| C++ | clang-format |
| Java | google-java-format |
| JavaScript | Prettier |
| TypeScript | Prettier |
| JSON | Prettier |
| YAML | Prettier |
| Markdown | Prettier |

`Space f` formats the current buffer.

A formatter generally expects syntactically valid code. For example, Ruff cannot repair Python that no longer parses.

## gitsigns.nvim

Adds Git change information directly to buffers and provides hunk navigation, staging, reset, preview, and line blame.

## nvim-dap

Debug Adapter Protocol client used for Java, Python, C, and C++ debugging.

## nvim-dap-ui + nvim-nio

Provides the visual debugger interface:

- variables / scopes
- call stacks
- breakpoints
- watches
- console/output

## nvim-jdtls

Neovim integration for Eclipse JDT Language Server.

Handles Java project awareness, Gradle project import, LSP functionality, and Java debugger configuration.

## Candela.nvim

Interactive log-analysis plugin.

Useful for:

- regex-based highlighting
- selecting multiple patterns
- focusing on matching lines
- temporarily hiding unrelated lines via lightbox behavior
- reusable pattern sets

Particularly useful during security investigations and log triage.

## cyberdream.nvim

Current colorscheme.

Configured with transparency so the Windows Terminal transparent background shows through Neovim.

Important setting:

```lua
transparent = true
```

Cyberdream also integrates visually with several installed plugins including Telescope, Gitsigns, blink.cmp, and DAP UI.

---

# 6. Language Support

# Lua

## Components

- Treesitter
- Lua Language Server 3.19.1
- blink.cmp
- StyLua

LuaLS executable:

```text
C:\Users\Eric\Tools\lua-language-server\bin\lua-language-server.exe
```

The Neovim config uses LuaJIT semantics and recognizes the global `vim` API.

Example LuaLS settings:

```lua
settings = {
    Lua = {
        runtime = {
            version = "LuaJIT",
        },
        diagnostics = {
            globals = { "vim" },
        },
        workspace = {
            library = {
                vim.env.VIMRUNTIME,
            },
            checkThirdParty = false,
        },
        telemetry = {
            enable = false,
        },
    },
}
```

### Future game scripting

For game engines such as FreeSpace Open, use project-specific LuaLS configuration rather than assuming Neovim/LuaJIT settings.

A game project may expose custom Lua globals and APIs. Add engine-specific stubs/libraries or a project `.luarc.json` when needed.

---

# Python

## Components

- Python 3.14.5 — primary system/development Python
- Python 3.13 — installed side-by-side for debugger testing/use
- basedpyright 1.39.10
- Ruff 0.16.5
- debugpy 1.8.21
- Treesitter
- blink.cmp
- nvim-dap

## LSP

basedpyright provides:

- completion
- type checking
- diagnostics
- navigation
- hover information

## Formatting

`Space f` runs Ruff formatting.

Example valid-but-ugly Python:

```python
def greet(name:str)->str:
    return f"Hello, {name}"
```

Ruff will normalize it.

Ruff will **not** format syntactically invalid Python such as a function body with missing indentation.

## Debugging

Python DAP currently points directly at the Python 3.13 interpreter rather than the Windows `py.exe` launcher.

Current pattern:

```lua
dap.adapters.python = {
    type = "executable",
    command = "C:\\Users\\Eric\\AppData\\Local\\Programs\\Python\\Python313\\python.exe",
    args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch current file",
        program = "${file}",
        pythonPath = "C:\\Users\\Eric\\AppData\\Local\\Programs\\Python\\Python313\\python.exe",
    },
}
```

Breakpoints and stepping work.

The debug session naturally closes when execution reaches the end of the program. nvim-dap may report the debug adapter process exiting with code `1` as the session tears down even when the script itself exits normally outside the debugger.

To verify the actual script independently:

```powershell
python .\Test.py
$LASTEXITCODE
```

---

# Java

## Components

- Eclipse Temurin Java 25.0.4.1 — default JDK
- Eclipse Temurin Java 21 — retained side-by-side
- Gradle 9.7.1
- Eclipse JDT Language Server 1.60.0
- nvim-jdtls
- Microsoft java-debug 0.53.2
- google-java-format 1.36.1
- nvim-dap
- DAP UI

Primary Java 25 location:

```text
C:\Program Files\Eclipse Adoptium\jdk-25.0.4.101-hotspot
```

Java 21 location:

```text
C:\Program Files\Eclipse Adoptium\jdk-21.0.12.101-hotspot
```

Expected environment:

```text
JAVA_HOME = C:\Program Files\Eclipse Adoptium\jdk-25.0.4.101-hotspot
```

Verify:

```powershell
java --version
javac --version
$env:JAVA_HOME
where.exe java
```

## Gradle

Gradle is installed under:

```text
C:\Users\Eric\Tools\gradle-9.7.1
```

For projects with a Gradle wrapper, prefer:

```powershell
.\gradlew.bat build
.\gradlew.bat run
```

The wrapper ensures the project uses its intended Gradle version.

## JDTLS workspace

JDTLS project metadata is stored under:

```text
C:\Users\Eric\AppData\Local\nvim-data\jdtls-workspaces\PROJECT_NAME
```

If JDTLS project metadata becomes corrupted or must be rebuilt, close Neovim and delete that project's workspace directory.

Example:

```powershell
Remove-Item `
  "$env:LOCALAPPDATA\nvim-data\jdtls-workspaces\nvim-java-test" `
  -Recurse -Force
```

Then reopen the project and a Java file so JDTLS reimports it.

## Required Java 25 runtime declaration

A major issue encountered was:

```text
IllegalStateException: Missing system library
```

The JDTLS log also showed:

```text
Unable to locate JDK types through index.
```

The fix was to explicitly register Java 25 in JDTLS:

```lua
settings = {
    java = {
        configuration = {
            runtimes = {
                {
                    name = "JavaSE-25",
                    path = "C:\\Program Files\\Eclipse Adoptium\\jdk-25.0.4.101-hotspot",
                    default = true,
                },
            },
        },
    },
}
```

After changing this setting, rebuild the JDTLS workspace.

## Java debugger console

The default generated Java configuration used:

```lua
console = "integratedTerminal"
```

This caused terminal takeover / ghost-terminal behavior.

The working setup explicitly initializes Java DAP with:

```lua
require("jdtls.dap").setup_dap({
    hotcodereplace = "auto",
    config_overrides = {
        console = "internalConsole",
    },
})
```

Then:

```lua
jdtls.start_or_attach(config)
```

This causes generated Java DAP configurations to use:

```lua
console = "internalConsole"
```

## CRITICAL: Windows Java breakpoint patch

This was the most difficult issue in the setup.

### Symptom

Java debugging launched correctly, but breakpoints remained:

```text
verified = false
```

The Java debugger could stop on entry and map bytecode back to the correct source file and line, but regular breakpoints would not bind.

### Root cause

On Windows, nvim-dap was sending source paths such as:

```text
C:/Users/Eric/DEV/nvim-java-test/app/src/main/java/org/example/App.java
```

Microsoft java-debug expected a Windows-style path:

```text
C:\Users\Eric\Dev\nvim-java-test\app\src\main\java\org\example\App.java
```

`noshellslash` did **not** fix this on Neovim 0.12.5 because:

```lua
vim.api.nvim_buf_get_name(0)
```

still returned forward slashes.

### Working patch

File:

```text
C:\Users\Eric\AppData\Local\nvim-data\site\pack\core\opt\nvim-dap\lua\dap\session.lua
```

Find:

```lua
local path = api.nvim_buf_get_name(bufnr)
```

Change to:

```lua
local path = api.nvim_buf_get_name(bufnr):gsub("/", "\\")
```

After this exact change, Java breakpoints bound successfully.

### Maintenance warning

This modifies the installed nvim-dap plugin checkout directly.

A future plugin update can overwrite this change.

After updating nvim-dap, if Java breakpoints suddenly remain unverified again, check this line first.

Recommended long-term approach:

1. Store this change as a small local patch alongside the Neovim config.
2. Reapply it after nvim-dap updates.
3. Remove the patch when upstream provides a native Windows path-normalization fix.

Do not reintroduce the earlier global `Session.request` monkey-patch. The narrow `set_breakpoints()` path modification is the proven fix.

---

# C / C++

## Components

- LLVM / Clang 23.1.0
- clangd
- clang-format
- lldb-dap
- MSVC Build Tools
- CMake
- Ninja
- Treesitter
- blink.cmp
- nvim-dap

LLVM location:

```text
C:\Program Files\LLVM\bin
```

LLDB DAP executable:

```text
C:\Program Files\LLVM\bin\lldb-dap.exe
```

## LSP

clangd is restricted to C-family filetypes:

```lua
filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
```

Useful root markers include:

```text
compile_commands.json
compile_flags.txt
.git
```

## Compile a simple C++ program with debug symbols

From the project directory:

```powershell
clang++ -g .\main.cpp -o .\main.exe
```

The `-g` flag includes debugging information.

## LLDB DAP configuration

```lua
dap.adapters.lldb = {
    type = "executable",
    command = "C:\\Program Files\\LLVM\\bin\\lldb-dap.exe",
    name = "lldb",
}

dap.configurations.cpp = {
    {
        name = "Launch executable",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input(
                "Path to executable: ",
                vim.fn.getcwd() .. "\\",
                "file"
            )
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = true,
        args = {},
    },
}

dap.configurations.c = dap.configurations.cpp
```

Current workflow:

1. Compile executable with `-g`.
2. Open source in Neovim.
3. Set breakpoint with `Space b`.
4. Start debugger with `Space d c`.
5. Enter/select path to `.exe` when prompted.
6. Use normal DAP stepping controls.

The initial LLDB test produced:

```text
Expected process to be stopped.
```

The successful configuration uses `stopOnEntry = true` and a valid freshly compiled executable containing debug symbols.

As CMake usage grows, this can later be improved to automatically derive the executable from build targets instead of prompting manually.

---

# 7. Formatting Toolchain

## StyLua

Installed with Cargo.

Verify:

```powershell
stylua --version
```

## Ruff

Python formatter/linter.

Verify:

```powershell
ruff --version
```

## clang-format

Installed with LLVM.

Verify:

```powershell
clang-format --version
```

## google-java-format

JAR:

```text
C:\Users\Eric\Tools\google-java-format\google-java-format.jar
```

Version tested:

```text
1.36.1
```

Windows wrapper:

```text
C:\Users\Eric\AppData\Local\bin\google-java-format.cmd
```

Wrapper contents:

```bat
@echo off
java -jar "%USERPROFILE%\Tools\google-java-format\google-java-format.jar" %*
```

Verify:

```powershell
google-java-format --version
```

## Prettier

Installed globally through npm.

Verify:

```powershell
prettier --version
```

Node/npm are required.

If PowerShell blocks `npm.ps1`, the user-level execution policy was changed to allow local scripts:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

---

# 8. Security and CLI Utility Layer

Installed utilities:

| Tool | Purpose |
|---|---|
| `rg` / ripgrep | Very fast recursive text search; powers Telescope and Candela workflows |
| `fd` | Fast filesystem search |
| `jq` | JSON parsing/filtering/transformation |
| `yq` | YAML parsing/filtering/transformation |
| `bat` | Syntax-highlighted `cat` replacement |
| `fzf` | Terminal fuzzy finder |
| `ShellCheck` | Shell script static analysis |
| `hadolint` | Dockerfile linting |
| `yamllint` | YAML linting |
| `Semgrep` | Static analysis / security pattern scanning |
| `Trivy` | Vulnerability, container, filesystem, config, and IaC scanning |
| `lnav` | Large / multi-file interactive log analysis |

Current lnav version observed:

```text
lnav 0.14.1-dirty
```

## Candela vs lnav

Use **Candela** when:

- already working inside Neovim
- analyzing a manageable log file
- highlighting multiple patterns
- quickly focusing/hiding nonmatching lines

Use **lnav** when:

- examining larger logs
- combining multiple log files
- wanting a dedicated log-navigation interface
- exploring timestamps, fields, and event streams interactively

---

# 9. Common Workflows

## Open a project

From PowerShell:

```powershell
cd C:\Users\Eric\Dev\PROJECT
nvim .
```

Or open a specific source file:

```powershell
nvim .\path\to\file
```

## Find a file

```text
Space f f
```

## Search project contents

```text
Space f g
```

Type the text/regex and select a result.

## Search symbols in current file

```text
Space f s
```

## Format current file

```text
Space f
```

## Inspect a diagnostic

Move cursor to the diagnostic and press:

```text
Space d
```

Navigate diagnostics:

```text
[d
]d
```

## Rename a symbol

Place cursor on symbol:

```text
Space r n
```

## Git hunk review

```text
]h      next hunk
[h      previous hunk
Space h p   preview
Space h s   stage
Space h r   reset
Space h b   blame line
```

## Generic debugging workflow

1. Open source file.
2. Put cursor on executable line.
3. Toggle breakpoint:

```text
Space b
```

4. Launch/continue:

```text
Space d c
```

5. Step:

```text
Space d n   over
Space d i   into
Space d o   out
```

6. Toggle debugger UI manually if needed:

```text
Space d u
```

## Java project workflow

From project root:

```powershell
.\gradlew.bat build
```

Open a Java file so JDTLS attaches/imports the project.

Check LSP:

```vim
:checkhealth vim.lsp
```

Format:

```text
Space f
```

Debug:

```text
Space b
Space d c
```

## Python workflow

Open `.py` file.

Check that basedpyright is attached:

```vim
:checkhealth vim.lsp
```

Format:

```text
Space f
```

Debug:

```text
Space b
Space d c
```

## C++ workflow without CMake

Compile:

```powershell
clang++ -g .\main.cpp -o .\main.exe
```

Then:

```text
Space b
Space d c
```

Select `main.exe` when prompted.

## Log triage with Candela

Open a log file.

```text
Space c u
```

Useful patterns might include:

```text
ERROR
WARN
failed
denied
10\.\d+\.\d+\.\d+
```

Use Candela's lightbox/focus behavior to hide irrelevant lines and inspect only matches.

## JSON command-line analysis

```powershell
Get-Content .\data.json | jq '.'
```

Example field selection:

```powershell
Get-Content .\data.json | jq '.events[] | .user'
```

## YAML command-line analysis

```powershell
yq '.some.path' .\config.yaml
```

---

# 10. Troubleshooting

## `Space f` does nothing

Check mapping:

```vim
:verbose nmap <leader>f
```

Expected description:

```text
Format buffer
```

Then inspect Conform:

```vim
:ConformInfo
```

Check whether the formatter executable is available:

```vim
:lua print(vim.fn.executable("stylua"))
```

`1` means Neovim can find the executable.

## Formatter refuses to format

Formatters generally require valid syntax.

Example Python error:

```text
Expected an indented block after function definition
```

Fix the syntax error first, then format.

## LSP does not attach

Run:

```vim
:checkhealth vim.lsp
```

Check:

- correct filetype
- correct project root
- language server executable path
- root markers
- environment PATH

## Java — `Missing system library`

Check JDTLS log:

```powershell
Select-String `
  -Path "$env:LOCALAPPDATA\nvim-data\jdtls-workspaces\PROJECT\.metadata\.log" `
  -Pattern "Missing system library|Unable to locate JDK types" `
  -Context 10,20
```

Verify Java 25 is explicitly registered under:

```text
settings.java.configuration.runtimes
```

Then rebuild the JDTLS workspace.

## Java breakpoint stays unverified

Check the local nvim-dap patch first.

Expected patched line:

```lua
local path = api.nvim_buf_get_name(bufnr):gsub("/", "\\")
```

If an nvim-dap update replaced it with:

```lua
local path = api.nvim_buf_get_name(bufnr)
```

reapply the Windows path-normalization patch.

## Java debugger takes over terminal

Generated DAP configuration should show:

```lua
console = "internalConsole"
```

Inspect generated Java configs if necessary:

```vim
:lua require("jdtls.dap").setup_dap_main_class_configs()
:lua print(vim.inspect(require("dap").configurations.java))
```

## DAP problems

Set trace logging:

```vim
:DapSetLogLevel TRACE
```

Inspect:

```vim
:DapShowLog
```

Log file:

```text
C:\Users\Eric\AppData\Local\nvim-data\dap.log
```

PowerShell:

```powershell
Get-Content "$env:LOCALAPPDATA\nvim-data\dap.log" -Tail 250
```

## JDTLS problems

Workspace log:

```text
C:\Users\Eric\AppData\Local\nvim-data\jdtls-workspaces\PROJECT\.metadata\.log
```

When the project model is clearly stale/corrupt, close Neovim and rebuild the project workspace rather than repeatedly changing unrelated DAP settings.

---

# 11. Moving This Setup to Another Windows Machine

The most important principle:

> Migrate the configuration; reinstall/regenerate the toolchain and caches.

Do **not** blindly copy the entire `nvim-data` directory to a new machine.

## Step 1 — Back up/version-control the Neovim config

Primary directory:

```text
C:\Users\Eric\AppData\Local\nvim
```

Recommended: keep this directory in Git.

At minimum, preserve:

```text
init.lua
lua/config/*
lua/plugins/*
patches/*        if created
scripts/*        if created
README.md
```

## Step 2 — Install baseline applications

Install on the new Windows machine:

```text
Neovim
Git
Windows Terminal
Python
Java / Temurin
Gradle
LLVM / Clang
Visual Studio Build Tools
CMake
Ninja
Rust / Cargo
Node.js / npm
```

Then install standalone CLI/language tools.

## Step 3 — Restore config

Place the config at:

```text
%LOCALAPPDATA%\nvim
```

Launch Neovim.

Because the config uses `vim.pack.add()`, Neovim can recreate plugin checkouts under `nvim-data` rather than requiring that directory to be copied from the old machine.

## Step 4 — Reinstall external tools

Reinstall/verify:

```text
ripgrep
fd
basedpyright
Ruff
debugpy
StyLua
Prettier
google-java-format
Lua Language Server
JDTLS
java-debug
jq
yq
bat
fzf
ShellCheck
hadolint
yamllint
Semgrep
Trivy
lnav
```

## Step 5 — Recheck hard-coded paths

Several current configs contain machine-specific Windows paths.

Search the config for:

```text
C:\Users\Eric
C:\Program Files
```

Important hard-coded areas currently include:

- Lua Language Server executable
- Python 3.13 debugger interpreter
- LLDB DAP executable
- JDTLS directory
- java-debug JAR
- Java runtime declaration

Long-term portability improvement: rewrite these using environment variables such as:

```lua
local home = vim.env.USERPROFILE
```

and build paths from `home` where possible.

## Step 6 — Java setup

Verify:

```powershell
java --version
javac --version
$env:JAVA_HOME
where.exe java
```

Ensure Java 25 is default.

Restore/download:

```text
JDTLS
java-debug
Gradle
```

Do not migrate old JDTLS workspace metadata. Let it regenerate.

## Step 7 — Reapply nvim-dap Windows Java patch

After nvim-dap is installed, check:

```text
%LOCALAPPDATA%\nvim-data\site\pack\core\opt\nvim-dap\lua\dap\session.lua
```

The Java breakpoint fix must currently be:

```lua
local path = api.nvim_buf_get_name(bufnr):gsub("/", "\\")
```

Without it, Java breakpoints may remain unverified on Windows.

## Step 8 — Verify toolchain

PowerShell sanity checks:

```powershell
nvim --version
git --version
python --version
py -0p
java --version
javac --version
gradle --version
clang --version
clangd --version
clang-format --version
where.exe lldb-dap
cmake --version
ninja --version
rustc --version
cargo --version
node --version
npm --version
stylua --version
ruff --version
prettier --version
google-java-format --version
jq --version
yq --version
bat --version
fzf --version
shellcheck --version
hadolint --version
yamllint --version
semgrep --version
trivy --version
lnav --version
```

## Step 9 — Verify Neovim

Inside Neovim:

```vim
:checkhealth
:checkhealth vim.lsp
:ConformInfo
:Candela health
```

Open one file for each major language and verify:

```text
Lua        LuaLS + StyLua
Python     basedpyright + Ruff + debugpy
Java       JDTLS + google-java-format + Java DAP
C/C++      clangd + clang-format + LLDB
```

## Step 10 — Test key workflows

Test:

```text
Space f f   Telescope files
Space f g   Telescope grep
Space f     formatting
K           LSP hover
Space b     breakpoint
Space d c   debugging
Space c u   Candela
```

If those work, the environment is substantially restored.

---

# 12. What Should and Should Not Be Backed Up

## Back up / version control

```text
%LOCALAPPDATA%\nvim
custom patch files
helper scripts
README / field guide
project-specific .luarc.json files
project build files such as build.gradle.kts and CMakeLists.txt
```

## Recreate instead of migrating

```text
%LOCALAPPDATA%\nvim-data plugin caches/checkouts
JDTLS workspaces
Gradle caches
compiler build outputs
DAP logs
Conform logs
Treesitter build artifacts
```

This keeps migration cleaner and avoids carrying corrupted/stale state to the new machine.

---

# 13. Recommended Future Improvements

These are not required for the current setup, but they are sensible next refinements.

## Put the Neovim config in Git

This is the highest-value improvement for portability.

It gives you:

- history
- rollback
- easy migration
- visibility into config changes
- a safe home for the Windows nvim-dap patch

## Replace hard-coded user paths

Use `vim.env.USERPROFILE` and environment variables wherever possible.

Example:

```lua
local home = vim.env.USERPROFILE
local lua_ls = home .. "\\Tools\\lua-language-server\\bin\\lua-language-server.exe"
```

## Persist the nvim-dap patch

Create a small `patches/` directory and maintain the Java Windows source-path fix as a local patch instead of relying on a manual edit that can disappear after updates.

## CMake-aware debugging

Current LLDB configuration asks for the executable path manually.

When CMake becomes part of regular C++ development, improve this so debug targets are selected or inferred from the CMake build directory.

## Project-specific Python environments

For larger Python projects, prefer virtual environments and make DAP select the project's interpreter rather than always pointing at the global Python 3.13 installation.

## Game-specific Lua environments

When using Lua in FreeSpace Open or another engine:

- identify the engine's Lua version
- identify engine-defined globals/functions
- add API stubs/libraries to LuaLS
- use project `.luarc.json` files

---

# 14. Fast “I Haven’t Used Neovim in Six Months” Checklist

If everything feels unfamiliar, start here:

```text
Space f f      find a file
Space f g      search project text
K              explain symbol under cursor
gd             go to definition
Space d        explain diagnostic
Space f        format file
Space w        save
Space q        quit
```

Git:

```text
]h / [h        next / previous change
Space h p      preview change
Space h b      blame line
```

Debugging:

```text
Space b        breakpoint
Space d c      start / continue
Space d n      step over
Space d i      step into
Space d o      step out
Space d u      debugger UI
```

Logs:

```text
Space c u      Candela UI
```

Health checks:

```vim
:checkhealth
:checkhealth vim.lsp
:ConformInfo
:DapShowLog
```

If Java breakpoints refuse to bind after an update, check the **nvim-dap Windows path patch first**.

---

# 15. Environment Snapshot

Versions observed while building this setup include:

```text
Neovim                 0.12.5
Git                    2.55.0.windows.5
Python                 3.14.5
Python debugger alt    3.13
basedpyright            1.39.10
Ruff                    0.16.5
debugpy                 1.8.21
Java / Temurin          25.0.4.1 LTS
Java alternate          21.0.12.1 LTS
Gradle                  9.7.1
JDTLS                   1.60.0
java-debug              0.53.2
google-java-format      1.36.1
LLVM / Clang            23.1.0
Tree-sitter CLI         0.26.13
Rust                    1.98.0
Lua Language Server     3.19.1
lnav                    0.14.1-dirty
```

Versions will naturally change over time; the architecture and troubleshooting notes are more important than preserving exact versions forever.

---

# 16. Mental Model

When something breaks, identify the layer before changing configuration:

```text
Neovim buffer
    ↓
Treesitter        syntax structure / highlighting
    ↓
LSP               completion / navigation / diagnostics
    ↓
Formatter         rewrites source formatting
    ↓
Compiler/build    produces executable / bytecode
    ↓
DAP client        nvim-dap
    ↓
Debug adapter     debugpy / java-debug / lldb-dap
    ↓
Runtime           Python / JVM / native process
```

For logs/security work:

```text
File / API data
    ↓
jq / yq / rg
    ↓
Candela or lnav
    ↓
manual analysis / detection development
```

The biggest lesson from building this environment: **debug the layer that is actually failing.** A formatter cannot repair invalid syntax, a DAP client cannot fix a broken project model, and a language server cannot compensate for a missing compiler/runtime.

