# OpenMower_UbuntuOS

Automatisiert erstelltes Ubuntu 24.04 LTS Server-Image für Raspberry Pi 4/5 mit LXDE, VS Code, NoMachine und Podman/ROS1.

## Features
- Ubuntu Server 24.04 LTS (aktuellste LTS)
- LXDE Desktop (leichtgewichtig, ohne unnötige Apps)
- VS Code & NoMachine nativ installiert
- Podman mit ROS1 (Details folgen)
- Zentrale Konfigurationsdatei als Template (`config.template.yaml`)
- Image als `.img.xz`
- Erweiterbar für weitere Features
- Build via GitHub Actions

## Konfiguration
Alle benutzerspezifischen Einstellungen (User, SSH-Key, WiFi, Ethernet-IP, Sprache, Zeitzone) werden über eine zentrale Konfigurationsdatei vorgenommen. Das Template liegt als `config.template.yaml` im Repo. Die ausgefüllte Datei `config.yaml` wird nicht eingecheckt.

## Build
Das Image wird automatisiert via GitHub Actions gebaut und als Artifact bereitgestellt.

## Ordnerstruktur
- `.github/workflows/` – CI/CD Workflows
- `build/` – Build-Skripte und Hilfsdateien
- `config.template.yaml` – Vorlage für Konfiguration

## ToDo
- Details zu ROS1/Podman
- Weitere Tools & Features
