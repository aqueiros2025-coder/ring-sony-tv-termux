# Ring na Android TV (Sony) via Termux

Mostra os eventos da campainha **Ring** (toque e movimento) como pop-up na própria Android TV, sem servidor externo.
Usa o projeto [ring-to-android-tv](https://github.com/stevenflesch/ring-to-android-tv) + a app **PiPup**, tudo a correr na TV com o **Termux**.

> Limitação: o Android pode matar processos em segundo plano. Se a TV cortar a rede em standby, os avisos só chegam com a TV ligada. Para fiabilidade total, usa um Raspberry Pi ou outro servidor sempre ligado.

## 1. Instalar as apps na TV
- **Termux** e **Termux:Boot** (APK do GitHub ou F-Droid; a versão da Play Store está desatualizada)
- **PiPup** (APK do GitHub `rogro82/PiPup`)

## 2. Permissão do PiPup (ADB, a partir do PC)
```
adb shell appops set nl.rogro82.pipup SYSTEM_ALERT_WINDOW allow
```

## 3. Instalar no Termux
```
pkg install -y git
git clone https://github.com/aqueiros2025-coder/ring-sony-tv-termux.git
cd ring-sony-tv-termux
sh install.sh
```

## 4. Token da Ring
```
npx -p ring-client-api ring-auth-cli
```
Faz login (com 2FA) e copia o *refresh token*.

## 5. Configurar o `.env`
```
nano ~/ring-to-android-tv/.env
```
- `R2ATV_IP_ADDRESS=127.0.0.1`
- `R2ATV_API_TOKEN=` o token
- `R2ATV_DISPLAY_TIME=` segundos que o pop-up fica visível

## 6. Testar
```
cd ~/ring-to-android-tv && node index.js
```
Toca à campainha e confirma que o pop-up aparece.

## 7. Manter ativo
- Desativa a otimização de bateria para Termux, Termux:Boot e PiPup (definições da TV).
- Abre o **Termux:Boot** uma vez para registar o arranque automático (o `install.sh` já cria `~/.termux/boot/ring.sh`).
- No Termux, corre `termux-wake-lock`.
