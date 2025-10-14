-- Rerun tests only if their modification time changed.
cache = true

std = luajit
codes = true

self = false

-- Glorious list of warnings: https://luacheck.readthedocs.io/en/stable/warnings.html
ignore = {
    "122", -- Indirectly setting a readonly global
}

-- Global objects defined by the C code
read_globals = {
    "vim"
}


exclude_files = {
    "**/packer_compiled.lua"
}

