onExit(){
  echo "exiting!" > "$XDG_CONFIG_HOME/logs/exit"
  [ ! -f "$HOME/xdgconfig.enc" ] && echo "???? xdgconfig.enc missing !" > "$XDG_CONFIG_HOME/logs/exit"
  myencrypt "$XDG_CONFIG_HOME" "$SSH_XDG_CONFIG_PASSWD" "$HOME/xdgconfig.enc"
  [ ! -f "$HOME/xdgconfig.enc" ] && echo "[error] xdgconfig.enc generation fails !" > "$XDG_CONFIG_HOME/logs/exit"
  mv "$XDG_CONFIG_HOME" "$XDG_CONFIG_HOME.bak"

}

