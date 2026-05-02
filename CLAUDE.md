# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A Docker-based Minecraft 1.21.1 Fabric server running the [Cobblemon](https://modrinth.com/modpack/cobblemon-fabric) modpack, managed via Docker Compose.

## Common Commands

```bash
# Start the server (waits until healthy)
docker compose up -d --wait

# Stop the server
docker compose stop

# View live server logs
docker compose logs -f mc

# Run RCON commands (server must be running)
docker compose exec mc rcon-cli <command>

# Trigger a manual backup
docker compose exec mc-backup backup

# Full teardown (keeps volumes/data)
docker compose down
```

## Architecture

Three Docker services work together:

- **`mc`** — The game server (`itzg/minecraft-server:java21`). Uses `TYPE: MODRINTH` to auto-download the `cobblemon-fabric` modpack plus additional mods listed under `MODRINTH_PROJECTS`. Depends on `mc-restore-backup` completing first.
- **`mc-restore-backup`** — Init container (`itzg/mc-backup`) that runs `restore-tar-backup` once on startup to restore the latest backup from `./backups` into `./data` if the data volume is empty.
- **`mc-backup`** — Sidecar container that takes automatic hourly backups via RCON once `mc` is healthy. Stores compressed world archives in `./backups/`.

All persistent state lives in `./data` (server files, mods, world, configs) and `./backups` (world tarballs). RCON is enabled; credentials are in `data/server.properties` and `data/.rcon-cli.yaml`.

## Adding or Updating Mods

Edit the `MODRINTH_PROJECTS` list in `compose.yaml` with the Modrinth slug and version pin, then restart:

```bash
docker compose up -d --wait
```

## Troubleshooting: Wrong Mod Loader Downloaded

If the server downloads NeoForge instead of Fabric loaders, stop and wipe the mods directory, then restart:

```bash
docker compose stop
sudo rm -rf ./data/mods/*.jar
docker compose up -d --wait
```
