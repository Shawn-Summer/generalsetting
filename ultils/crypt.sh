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
  (cd "$src_dir" && tar czf - "$src_name" 2>/dev/null) | openssl enc -aes-256-cbc -salt -pbkdf2 -pass pass:"$password" -out "$output_path"
  
  if [ $? -eq 0 ]; then
    echo "加密成功！加密文件：$output_path"
  else
    echo "加密失败！请检查路径/密码/权限"
    [ -f "$output_path" ] && rm -f "$output_path"
  fi
}
# ===================== 解密函数 mydecrypt() =====================
mydecrypt() {
  if [ $# -ne 3 ]; then
    echo "解密函数参数错误！用法：mydecrypt 待解密文件 密码 解密产物存放目录"
    echo "示例：mydecrypt ~/docs_encrypted.enc xxl ~/decrypted_files"
    return 1
  fi

  local enc_path="$1"       # 待解密的 .enc 文件（myencrypt 生成）
  local password="$2"       # 解密密码（与加密时一致）
  local output_dir="$3"     # 解密产物的存放目录（仅指定目录，不指定文件名/文件夹名）

  # 检查待解密文件是否存在
  if [ ! -f "$enc_path" ]; then
    echo "错误：待解密文件 $enc_path 不存在！"
    return 1
  fi

  # 确保存放目录存在（不存在则自动创建，包括多级目录）
  if [ ! -d "$output_dir" ]; then
    mkdir -p "$output_dir" || { echo "错误：无法创建存放目录 $output_dir！"; return 1; }
  fi

  echo "开始解密：$enc_path → 存放目录：$output_dir"
  # 核心逻辑：解密后直接解压到指定存放目录，自动还原原始名称和结构
  openssl enc -d -aes-256-cbc -pbkdf2 -pass pass:"$password" -in "$enc_path" 2>/dev/null | tar xzf - -C "$output_dir"

  # 检查解密是否成功（判断存放目录是否有新增产物）
  if [ $? -eq 0 ] && [ "$(ls -A "$output_dir")" != "" ]; then
    echo "解密成功！产物已存放在：$output_dir"
    echo "解密产物清单："
    ls -lh "$output_dir"  # 可选：列出存放目录中的产物，直观确认
  else
    echo "解密失败！请检查密码/加密文件完整性/权限"
    # 清理空目录（避免残留无效目录）
    [ -d "$output_dir" ] && rmdir --ignore-fail-on-non-empty "$output_dir"
  fi
}
