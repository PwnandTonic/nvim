local home = vim.env.USERPROFILE
local jdtls_dir = home .. "\\Tools\\jdtls"

local launcher = vim.fn.glob(jdtls_dir .. "\\plugins\\org.eclipse.equinox.launcher_*.jar")

local config_dir = jdtls_dir .. "\\config_win"

local java_debug = home
	.. "\\Tools\\java-debug\\com.microsoft.java.debug.plugin\\target\\com.microsoft.java.debug.plugin-0.53.2.jar"

local function find_root(bufnr)
	return vim.fs.root(bufnr, {
		"gradlew.bat",
		"gradlew",
		"settings.gradle",
		"settings.gradle.kts",
		"pom.xml",
		".git",
	})
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",

	callback = function(args)
		local bufname = vim.api.nvim_buf_get_name(args.buf)

		-- Ignore unnamed/special Java buffers.
		if bufname == "" or vim.bo[args.buf].buftype ~= "" then
			return
		end

		local root = find_root(args.buf)

		if not root then
			return
		end

		local project_name = vim.fs.basename(root)

		-- Persistent JDTLS project metadata.
		local workspace_dir = vim.fn.stdpath("data") .. "\\jdtls-workspaces\\" .. project_name

		local config = {
			cmd = {
				"java",

				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",

				"-Xmx1G",

				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",

				"-jar",
				launcher,

				"-configuration",
				config_dir,

				"-data",
				workspace_dir,
			},

			root_dir = root,

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
			},

			init_options = {
				bundles = {
					java_debug,
				},
			},
		}

		local jdtls = require("jdtls")

		require("jdtls.dap").setup_dap({
			hotcodereplace = "auto",
			config_overrides = {
				console = "internalConsole",
			},
		})

		jdtls.start_or_attach(config)
	end,
})
