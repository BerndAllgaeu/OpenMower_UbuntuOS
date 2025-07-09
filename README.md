# OpenMower_UbuntuOS

Automatisiertes Setup für Ubuntu 24.04 LTS auf Raspberry Pi 4/5 – alle Anpassungen erfolgen nach dem ersten Boot per Ansible-Playbook.

## Konzept
- Du nutzt das offizielle Ubuntu-Image für den Raspberry Pi (z.B. von cdimage.ubuntu.com).
- Nach dem ersten Boot führst du das Setup-Skript aus diesem Repository aus.
- Das Skript installiert Ansible, klont das Setup-Repo und führt das Playbook lokal aus.
- Alle Systemanpassungen, Installationen und Konfigurationen laufen deklarativ per Ansible.

## Nutzung
1. Ubuntu-Image auf SD-Karte flashen und Raspberry Pi booten.
2. Setup-Skript ausführen:

   ```bash
   bash <(curl -fsSL https://raw.githubusercontent.com/<dein-github-user>/<repo>/main/build/build-image.sh)
   ```
   (oder das Skript manuell herunterladen und ausführen)

3. Das Playbook übernimmt alle weiteren Anpassungen (siehe `build/playbook.yml`).

## Dateien
- `build/build-image.sh`: Setup-Skript für den Pi (installiert Ansible, klont Repo, startet Playbook)
- `build/playbook.yml`: Ansible-Playbook für alle Anpassungen (z.B. Setup-WebUI, Systemdienste)
- `config.template.yaml`/`config.yaml`: (Optional) Konfigurationsdateien für individuelle Anpassungen
- `setup_webui/`: (Optional) Quellcode oder Hinweise für die Setup-WebUI

## Hinweise
- Das Repository enthält keine Image-Build-Skripte oder CI-Workflows mehr.
- Alle Anpassungen erfolgen direkt auf dem Raspberry Pi nach dem ersten Boot.
- Das Playbook ist leicht erweiterbar und kann beliebig angepasst werden.

---

Fragen oder Wünsche? Einfach ein Issue eröffnen!
