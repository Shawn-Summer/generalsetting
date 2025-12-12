mylogout(){
  echo "log out !!!" > "$XDG_CONFIG_HOME/logs/exit"
  [ ! -f "$HOME/xdgconfig.enc" ] && echo "???? xdgconfig.enc missing !" > "$XDG_CONFIG_HOME/logs/exit"
  myencrypt "$XDG_CONFIG_HOME" "$SSH_XDG_CONFIG_PASSWD" "$HOME/xdgconfig.enc" >> "$XDG_CONFIG_HOME/logs/exit"
  [ ! -f "$HOME/xdgconfig.enc" ] && echo "[error] xdgconfig.enc generation fails !" >> "$XDG_CONFIG_HOME/logs/exit"
  rm -rf "$XDG_CONFIG_HOME"

}

