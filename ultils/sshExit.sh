mylogout(){
  echo "log out !!!" 
  myencrypt "$XDG_CONFIG_HOME" "$ENCRYPT_PASSWD" "$HOME/xdgconfig.enc"
  [ ! -f "$HOME/xdgconfig.enc" ] && echo "[error] xdgconfig.enc generation fails !" 
  [ -f "$HOME/xdgconfig.enc" ] && rm -rf "$XDG_CONFIG_HOME"

}

