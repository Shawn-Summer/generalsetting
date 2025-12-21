return {
  "lervag/vimtex",
  lazy = false, -- lazy-loading will disable inverse search
  config = function()
    vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
    vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
   
    -- 编译指令--
      -- 使用 latexmk 编译指令
    vim.g.vimtex_compiler_method = "latexmk"
      -- 使用 lualatex 作为默认引擎 （对中文兼容好）
    vim.g.vimtex_compiler_latexmk_engines = {
      ['_']                = '-xelatex' ,  -- 默认引擎直接设为 xelatex（中文优先）
      ['pdflatex']         = '-pdf',      -- 备用：纯英文文档可切换
      ['lualatex']         = '-lualatex', -- 备用：xelatex 出问题时用
      ['xelatex']          = '-xelatex',  -- 核心：中文文档专用
    }
      -- latex 的参数
    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-shell-escape", -- 允许调用系统命令
        -- "-verbose", -- 输出详细编译日志（方便排错）
        "-file-line-error", -- 错误提示显示「文件名+行号」（精准定位错误）
        "-synctex=1", -- 启用 SyncTeX（正向/反向搜索必备）
        "-interaction=nonstopmode", -- 编译出错时不中断，继续尝试完成编译
      },
    }

    vim.g.tex_flavor = "latex" -- Default tex file format

    -- viewer 相关
    vim.g.vimtex_view_method = "skim" -- 使用skim做viewer
    vim.g.vimtex_view_skim_activate = 1 -- skim 自动前置
    vim.g.vimtex_view_skim_sync = 1 -- Skim 正向搜索
    vim.g.vimtex_view_reverse_search_edit_cmd = 'edit' -- 反向搜索时，若当前不是界面，则新建一个

    -- 错误window （quickfix window）
    vim.g.vimtex_quickfix_mode = 2 -- 有错误自动打开错误窗口
    vim.g.vimtex_quickfix_autoclose_after_keystrokes = 2  -- 光标移动2次后，自动消除错误窗口的干扰
    vim.g.vimtex_quickfix_ignore_filters = { -- 忽略一些错误
        "Command terminated with space",
        "LaTeX Font Warning: Font shape",
        "Package caption Warning: The option",
        [[Underfull \\hbox (badness [0-9]*) in]],
        "Package enumitem Warning: Negative labelwidth",
        [[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in]],
        [[Package caption Warning: Unused \\captionsetup]],
        "Package typearea Warning: Bad type area settings!",
        [[Package fancyhdr Warning: \\headheight is too small]],
        [[Underfull \\hbox (badness [0-9]*) in paragraph at lines]],
        "Package hyperref Warning: Token not allowed in a PDF string",
        [[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in paragraph at lines]],
    }
    vim.g.tex_comment_nospell = 1 --注释拼写不检查
        -- 关闭所有隐藏功能
    vim.g.vimtex_syntax_conceal = {
        accents = 0,
        ligatures =0,
        cites = 0,
        fancy = 0,
        greek = 0,
        math_bounds = 0,
        math_delimiters = 0,
        math_fracs = 0,
        math_super_sub = 0,
        math_symbols = 0,
        sections = 0,
        styles = 0,
    }
  end,
  keys = {
    { "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
  },
}
