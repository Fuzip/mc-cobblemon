# Minecraft Cobblemon Server

A Docker Minecraft server with Cobblemon modpack.

## Restoring a backup

To restore a backup :

* Stop the Docker container :
```bash
docker compose down
```

* Remove the `data` folder
```bash
rm -rf ./data
```

* Add the backup `tar` file into `backup`, to get from remote server use `scp` :
```bash
scp <user>@<server>:<path>/backups/world-yyyymmdd-hms.tar.gz ./backups/
````

* Start up the docker containers :
```bash
docker compose up -d
```

## Troubleshooting

### Downloaded architectury neoforge instead of fabric loader

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