lvim.plugins = {
  {
    "markwoodhall/vim-nuget",
    dependencies = {
      "mattn/webapi-vim",
      "junegunn/fzf.vim",
      "Shougo/deoplete.nvim",
    }
  },
  { "tpope/vim-commentary" },
  {
    "stevearc/oil.nvim",
    init = function()
      require("oil").setup()
    end
  },
  {
    "mfussenegger/nvim-dap-python",
    init = function()
      require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
    end
  },
  { "nvim-neotest/nvim-nio" },
  -- dotnet configuration
  {
    "NicholasMata/nvim-dap-cs",
    init = function()
      require("dap-cs").setup()
    end
  },
  { "nvim-neotest/neotest-python" },
  {
    "Issafalcon/neotest-dotnet",
    dependencies = {
      "nvim-neotest/neotest"
    },
    init = function()

    end
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter"
    },

    init = function()
      require("neotest").setup({
        adapters = {
          require("neotest-dotnet")({
            dap = {
              -- Extra arguments for nvim-dap configuration
              -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
              args = { justMyCode = false },
              -- Enter the name of your dap adapter, the default value is netcoredbg
              adapter_name = "coreclr"
            },

            -- Provide any additional "dotnet test" CLI commands here. These will be applied to ALL test runs performed via neotest. These need to be a table of strings, ideally with one key-value pair per item.
            dotnet_additional_args = {
              "--verbosity detailed"
            },

            -- Tell neotest-dotnet to use either solution (requires .sln file) or project (requires .csproj or .fsproj file) as project root
            -- Note: If neovim is opened from the solution root, using the 'project' setting may sometimes find all nested projects, however,
            --       to locate all test projects in the solution more reliably (if a .sln file is present) then 'solution' is better.
            discovery_root = "solution" -- Default

          }),

          require("neotest-python")({
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            dap = { justMyCode = false },
            -- Command line arguments for runner
            -- Can also be a function to return dynamic values
            args = { "--log-level", "DEBUG" },
            -- Runner to use. Will use pytest if available by default.
            -- Can be a function to return dynamic value.
            runner = "pytest",

            -- Custom python path for the runner.

            -- Can be a string or a list of strings.

            -- Can also be a function to return dynamic value.

            -- If not provided, the path will be inferred by checking for

            -- virtual envs in the local directory and for Pipenev/Poetry configs

            python = ".venv/bin/python",

            -- Returns if a given file path is a test file.

            -- NB: This function is called a lot so don't perform any heavy tasks within it.

            -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test

            -- instances for files containing a parametrize mark (default: false)

            pytest_discover_instances = true,

          })
        }
      })
    end
    ,
  },
  { "lambdalisue/vim-suda" },
}

-- nvim-dap config

local dap = require('dap')

dap.adapters.coreclr = {
  type = 'executable',
  command = '/home/wesley/.local/share/lvim/mason/bin/netcoredbg',
  args = { '--interpreter=vscode' }
}


dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}


require("dap-cs").setup()

-- Key Maps
lvim.keys.normal_mode["-"] = { "<cmd>Oil<cr>" }
lvim.builtin.which_key.mappings["-"] = {
  "<CMD>Oil<CR>", "Opens File Explorer"
}
lvim.keys.normal_mode["<C>n"] = { "<cmd>InstallPackage<cr>" }

lvim.builtin.which_key.mappings["t"] = {
  name = "Testing",
  r = { "<cmd>Neotest run<cr>", "Run Tests" },
  i = { "<cmd>Neotest summary<cr>", "Show Tests" },
  s = { "<cmd>Neotest stop<cr>", "Stop All Tests" },
  d = { function() require('neotest').run.run({ strategy = 'dap' }) end, "Debug Nearest Test" },
  p = { "<cmd>Neotest output-panel<cr>", "Toggle Output panel" },
  o = { "<cmd>Neotest output<cr>", "Toggle output" },
  a = { function()
    vim.notify("Running Tests...", vim.log.levels.INFO)
    require("neotest").run.run(vim.fn.expand("%"))
  end, "Run all tests in current file" },
  w = { function() require("neotest").watch.toggle(vim.fn.expand("%")) end, "Watch all tests and re-runs on changes to the current file" },
}

lvim.format_on_save.enabled = true
