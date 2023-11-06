local os = require('os')
local dap = require('dap')

local debugpy_location = os.getenv('DEBUGPY_PATH')
local netcoredbg_location = os.getenv('NETCOREDBG_PATH')

local is_windows = function()
    return vim.loop.os_uname().sysname:find("Windows", 1, true) and true
end

local get_python_path = function()
  local venv_path = os.getenv('VIRTUAL_ENV')
  if venv_path then
    if is_windows() then
        return venv_path .. '\\Scripts\\python.exe'
    end
    return venv_path .. '/bin/python'
  end
  -- TODO show message to a user
  return nil
end

dap.adapters.python = {
    type = 'executable';
    command = debugpy_location;
    args = { '-m', 'debugpy.adapter' };
}

dap.adapters.coreclr = {
  type = 'executable',
  command = netcoredbg_location,
  args = {'--interpreter=vscode'}
}

dap.adapters.coreclrserver = {
    type = 'server',
    host = '127.0.0.1',
    port = 4987,
}

dap.configurations.python = {
    {
        type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = 'launch';
        name = "Launch file";
        program = "${file}"; -- This configuration will launch the current file if used.
        pythonPath = get_python_path;
    },
    {
        type = 'python';
        request = 'attach';
        name = "Attach to process";
        program = "${file}";
        processId = require('dap.utils').pick_process;
    },
    {
        type = 'python';
        request = 'launch';
        name = "Launch file with arguments";
        program = "${file}";
        pythonPath = get_python_path;
        args = function()
            local args_string = vim.fn.input('Arguments: ')
            return vim.split(args_string, " +")
        end;
    },
    {
        type = 'python';
        request = 'launch';
        name = "Launch module with arguments";
        module = function() return vim.fn.input("Module: "); end;
        pythonPath = get_python_path;
        args = function()
            local args_string = vim.fn.input('Arguments: ')
            return vim.split(args_string, " +")
        end;
    }
}

dap.configurations.cs = {
  {
    type = "coreclr";
    request = "attach";
    name = "Attach to process - netcoredbg";
    program = "${file}";
    processId = require('dap.utils').pick_process;
  },
  {
    type = "coreclrserver";
    request = "attach";
    name = "Attach to process - netcoredbg (in docker)";
    pathMappings = {
        { 
            localRoot = vim.fn.getcwd();
            remoteRoot = '/opt/app';
        },
    };
    processId = function()
        return vim.fn.input('Process id ')
    end;

  },
  {
    type = "coreclr";
    name = "Launch - netcoredbg";
    request = "launch";
    program = function()
        return vim.fn.input('Path to dll ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end;
  },
  {
    type = "coreclr";
    name = "Launch with arguments - netcoredbg";
    request = "launch";
    program = function()
        return vim.fn.input('Path to dll ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end;
    args = function()
        local args_string = vim.fn.input('Arguments: ')
        return vim.split(args_string, " +")
    end;
  },
}

