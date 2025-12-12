truecolor() {
    # This function echoes 24-bit color codes to demonstrate true color support
    # Original source: https://github.com/gnachman/iTerm2/blob/master/tests/24-bit-color.sh
    # Foreground: \x1b[38;2;<r>;<g>;<b>m
    # Background: \x1b[48;2;<r>;<g>;<b>m
    # Reset: \x1b[0m

    # 兼容 Bash/Zsh 的局部函数声明
    local setBackgroundColor resetOutput rainbowColor

    setBackgroundColor() {
        # 引号包裹避免特殊字符解析问题
        printf '\x1b[48;2;%s;%s;%sm' "$1" "$2" "$3"
    }

    resetOutput() {
        # 兼容双端的转义序列输出
        echo -en "\x1b[0m\n"
    }

    # Converts HSV (hue 0-255) to RGB (0-255 each)
    rainbowColor() { 
        local h f t q input="$1"
        # 兼容 Bash/Zsh 的算术运算语法（替换 let）
        (( h = input / 43 ))
        (( f = input - 43 * h ))
        (( t = f * 255 / 43 ))
        (( q = 255 - t ))

        case $h in
            0) echo "255 $t 0" ;;
            1) echo "$q 255 0" ;;
            2) echo "0 255 $t" ;;
            3) echo "0 $q 255" ;;
            4) echo "$t 0 255" ;;
            5) echo "255 0 $q" ;;
            *) echo "0 0 0" ;; # Fallback
        esac
    }

    # 兼容 Bash/Zsh 的循环语法（使用 seq 保持兼容性，避免 Zsh 数组歧义）
    # Red gradient
    for i in $(seq 0 127); do
        setBackgroundColor "$i" 0 0
        echo -en " "
    done
    resetOutput
    for i in $(seq 255 -1 128); do
        setBackgroundColor "$i" 0 0
        echo -en " "
    done
    resetOutput

    # Green gradient
    for i in $(seq 0 127); do
        setBackgroundColor 0 "$i" 0
        echo -n " "
    done
    resetOutput
    for i in $(seq 255 -1 128); do
        setBackgroundColor 0 "$i" 0
        echo -n " "
    done
    resetOutput

    # Blue gradient
    for i in $(seq 0 127); do
        setBackgroundColor 0 0 "$i"
        echo -n " "
    done
    resetOutput
    for i in $(seq 255 -1 128); do
        setBackgroundColor 0 0 "$i"
        echo -n " "
    done
    resetOutput

    # Rainbow gradient
    for i in $(seq 0 127); do
        setBackgroundColor $(rainbowColor "$i")
        echo -n " "
    done
    resetOutput
    for i in $(seq 255 -1 128); do
        setBackgroundColor $(rainbowColor "$i")
        echo -n " "
    done
    resetOutput
}
