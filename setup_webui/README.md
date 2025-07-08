# Setup-WebUI für OpenMower_UbuntuOS

## Lokale Entwicklung

1. Python venv anlegen und aktivieren:
   ```bash
   cd setup_webui
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   python app.py
   ```

2. Das Web-UI ist dann unter http://localhost:5000 erreichbar.

## Produktion (z.B. auf dem Raspberry Pi)

- Auch hier wird die App in einer venv ausgeführt:
   ```bash
   cd /pfad/zu/setup_webui
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   python app.py
   ```

- Für Autostart kann ein systemd-Service genutzt werden (Beispiel folgt).
