#!/bin/sh
set -e

# DISCORD_USER_IDS: comma-separated list of Discord user IDs, e.g. "123,456,789"

open_dm_channel() {
  curl -sf -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bot ${DISCORD_BOT_TOKEN}" \
    -d "{\"recipient_id\":\"$1\"}" \
    "https://discord.com/api/v10/users/@me/channels"
}

extract_channel_id() {
  printf '%s' "$1" | grep -o '"id":"[^"]*"' | head -1 | sed 's/"id":"//;s/"//'
}

broadcast() {
  local message="$1"
  local IFS=','

  for user_id in ${DISCORD_USER_IDS}; do
    user_id=$(printf '%s' "$user_id" | tr -d ' ')
    [ -z "$user_id" ] && continue

    local dm_response
    dm_response=$(open_dm_channel "$user_id") || { echo "discord-notify: failed to open DM for $user_id" >&2; continue; }

    local channel_id
    channel_id=$(extract_channel_id "$dm_response")

    if [ -z "$channel_id" ]; then
      echo "discord-notify: could not parse channel_id for $user_id" >&2
      continue
    fi

    curl -sf -X POST \
      -H "Content-Type: application/json" \
      -H "Authorization: Bot ${DISCORD_BOT_TOKEN}" \
      -d "{\"content\":\"${message}\"}" \
      "https://discord.com/api/v10/channels/${channel_id}/messages" > /dev/null \
      && echo "discord-notify: sent to $user_id" \
      || echo "discord-notify: failed to send to $user_id" >&2
  done
}

handle_stop() {
  broadcast "🔴Le serveur Minecraft Cobblemon est arrêté."
  exit 0
}

trap handle_stop TERM INT

broadcast "🟢Le serveur Minecraft Cobblemon est démarré !"

while true; do
  sleep 60 &
  wait $!
done