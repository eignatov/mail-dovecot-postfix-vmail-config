
exec >&2

makelink(){
  local linkfile="$1"
  local target="$2"
  local date="$(date)"

  if [ -L "$linkfile" ]; then
    echo "Check $linkfile points to $target"
  elif [ -e /etc/dovecot ]; then
    mv "$linkfile" "$linkfile.${date// /_}"
    echo "Backup $linkfile to $linkfile.${date// /_}"
    ln -s "$target" "$linkfile"
  else
    ln -s "$target" "$linkfile"
  fi
}

redo postfix/all
# redo-ifchange dovecot postfix/main.cf postfix/valias postfix/valiad.db

makelink /etc/dovecot "$(pwd)/dovecot"
makelink /etc/postfix/main.cf   "$(pwd)/postfix/main.cf"
makelink /etc/postfix/valias    "$(pwd)/postfix/valias"
makelink /etc/postfix/valias.db "$(pwd)/postfix/valias.db"

echo "If you update /etc/aliases then run newaliases"
