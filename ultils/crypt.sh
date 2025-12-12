# ===================== 加密函数 myencrypt() =====================
myencrypt() {
  if [ $# -ne 3 ]; then
    echo "加密函数参数错误！用法：myencrypt 待加密路径 密码 输出加密文件路径"
    echo "示例：myencrypt ~/docs xxl ~/.123"
    return 1
  fi

  local src_path="$1"
  local password="$2"
  local output_path="$3"

  if [ ! -e "$src_path" ]; then
    echo "错误：待加密路径 $src_path 不存在！"
    return 1
  fi

  # 关键修改：获取 src_path 的上级目录和相对名称
  local src_dir=$(dirname "$src_path")  # src_path 的上级目录（如 /Users/xxl）
  local src_name=$(basename "$src_path") # src_path 的名称（如 docs）

  echo "开始加密：$src_path → $output_path"
  # 切换到上级目录，用相对路径打包（仅保留 src_name 的结构）
  (cd "$src_dir" && tar czf - "$src_name" 2>/dev/null) | openssl enc -aes-256-cbc -salt -pass pass:"$password" -out "$output_path"
  
  if [ $? -eq 0 ]; then
    echo "加密成功！加密文件：$output_path"
  else
    echo "加密失败！请检查路径/密码/权限"
    [ -f "$output_path" ] && rm -f "$output_path"
  fi

