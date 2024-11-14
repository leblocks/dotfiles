local os = require('os')
local roslyn_server_dll_location = os.getenv('ROSLYN_SERVER_DLL_LOCATION') or '~'

require('roslyn').setup({
    config = {
        settings = {
            ["csharp|background_analysis"] = {
                dotnet_analyzer_diagnostics_scope = "openFiles",
                dotnet_compiler_diagnostics_scope = "openFiles",
            },

            ["csharp|completion"] = {
                dotnet_show_completion_items_from_unimported_namespaces = false,
                dotnet_show_name_completion_suggestions = false,
            },

            ["csharp|inlay_hints"] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,
                csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                csharp_enable_inlay_hints_for_types = true,
                dotnet_enable_inlay_hints_for_indexer_parameters = true,
                dotnet_enable_inlay_hints_for_literal_parameters = true,
                dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                dotnet_enable_inlay_hints_for_other_parameters = true,
                dotnet_enable_inlay_hints_for_parameters = true,
                dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            },

            ["csharp|code_lens"] = {
                dotnet_enable_references_code_lens = true,
            },

            ["csharp|symbol_search"] = {
                dotnet_search_reference_assemblies = false,
            },
        },
    },

    exe = { "dotnet", roslyn_server_dll_location },

    args = {
        "--logLevel=Information", "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path())
    },

    -- NOTE: Set `filewatching` to false if you experience performance problems.
    -- Defaults to true, since turning it off is a hack.
    -- If you notice that the server is _super_ slow, it is probably because of file watching
    -- Neovim becomes super unresponsive on some large codebases, because it schedules the file watching on the event loop.
    -- This issue goes away by disabling this capability, but roslyn will fallback to its own file watching,
    -- which can make the server super slow to initialize.
    -- Setting this option to false will indicate to the server that neovim will do the file watching.
    -- However, in `hacks.lua` I will also just don't start off any watchers, which seems to make the server
    -- a lot faster to initialize.
    filewatching = true,

    -- Optional function that takes an array of solutions as the only argument. Return the solution you
    -- want to use. If it returns `nil`, then it falls back to guessing the solution like normal
    -- Example:
    --
    -- choose_sln = function(sln)
    --     return vim.iter(sln):find(function(item)
    --         if string.match(item, "Foo.sln") then
    --             return item
    --         end
    --     end)
    -- end
    choose_sln = nil,
})
