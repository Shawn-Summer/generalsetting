-- lua/config/mason.lua
return {
  "mason-org/mason.nvim",
  opts = {
    -- 仅修改需要的字段，其他默认配置会自动合并
    registries = {
      "github:mason-org/mason-registry",  -- 保留官方源作为 fallback
    },
    github = {
      -- 替换 GitHub 下载链接为代理地址
      download_url_template = "https://github.com/%s/releases/download/%s/%s",
      -- download_url_template = "https://gh-proxy.org/https://github.com/%s/releases/download/%s/%s",
    },
    pip = {
      upgrade_pip = false,  -- 开启 pip 升级
      install_args = {
        "--index-url", "https://pypi.tuna.tsinghua.edu.cn/simple/",  -- 清华 PyPI 镜像
        "--trusted-host", "pypi.tuna.tsinghua.edu.cn",
      },
    },
    -- 其他默认配置（如 install_root_dir、PATH、ui 等）会自动保留，无需重复
  },
}
