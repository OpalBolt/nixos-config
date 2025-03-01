-- ~/.config/nvim/lua/plugins/lint.lua
return {
   {
      "mfussenegger/nvim-lint",
      opts = {
         linters = {
            markdownlint = {
               args = { "--disable", "MD013", "--" },
               --args = { "-c /home/mads/.config/nvim/markdown.toml" },
            },
         },
      },
   },
}
