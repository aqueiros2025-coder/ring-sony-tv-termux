#!/data/data/com.termux/files/usr/bin/sh
# Instala o ring-to-android-tv no Termux, a correr na própria Android TV.
set -e

pkg update -y && pkg upgrade -y
pkg install -y nodejs git nano

cd "$HOME"
[ -d ring-to-android-tv ] || git clone https://github.com/stevenflesch/ring-to-android-tv.git
cd ring-to-android-tv
npm install
[ -f .env ] || cp .env.example .env

# Aponta o script para a própria TV (PiPup corre no mesmo aparelho)
if grep -q '^R2ATV_IP_ADDRESS=' .env; then
  sed -i 's/^R2ATV_IP_ADDRESS=.*/R2ATV_IP_ADDRESS=127.0.0.1/' .env
else
  echo 'R2ATV_IP_ADDRESS=127.0.0.1' >> .env
fi

# Script de arranque automático (requer Termux:Boot)
mkdir -p "$HOME/.termux/boot"
cat > "$HOME/.termux/boot/ring.sh" <<'EOF'
#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
cd "$HOME/ring-to-android-tv" && node index.js
EOF
chmod +x "$HOME/.termux/boot/ring.sh"

cat <<'EOF'

Instalação concluída. Falta:
 1) Gerar o token:   npx -p ring-client-api ring-auth-cli
 2) Editar o .env:   nano ~/ring-to-android-tv/.env
    (preencher R2ATV_API_TOKEN e, se quiseres, R2ATV_DISPLAY_TIME)
 3) Testar:          cd ~/ring-to-android-tv && node index.js
 4) Abrir o Termux:Boot uma vez para registar o arranque automático.
EOF
