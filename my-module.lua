local myModule = {}

function myModule.setupLazyPluginManager()
    local pathToLazy = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    local isLazyInstalled = vim.uv.fs_stat(pathToLazy)
    if not isLazyInstalled then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            pathToLazy,
        })
    end
    -- Add lazy to "runtimepath" (rtp) so its directory is searched for nvim
    -- runtime files.
    vim.opt.rtp:prepend(pathToLazy)
end

return myModule

