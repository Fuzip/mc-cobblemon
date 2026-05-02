Minecraft Cobblemon Server

# Troubleshooting

Minecraft server with Cobblemon modpack.

## Downloaded architectury neoforge instead of fabric loader

Stop the container :

```console
docker compose stop
```

Then delete all the mods :

```console
sudo rm -rf ./data/mods/*.jar
```

And restart the container :
```console
docker compose up -d --wait
```