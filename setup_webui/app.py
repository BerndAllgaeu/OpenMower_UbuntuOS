from flask import Flask, render_template, request, redirect, url_for, flash
import yaml
import os

app = Flask(__name__)
app.secret_key = 'openmower-setup-key'

CONFIG_PATH = os.path.join(os.path.dirname(__file__), '../config.yaml')

@app.route('/', methods=['GET', 'POST'])
def setup():
    config = {}
    # Beim GET: config.yaml laden, falls vorhanden
    if os.path.exists(CONFIG_PATH):
        with open(CONFIG_PATH, 'r') as f:
            try:
                config = yaml.safe_load(f) or {}
            except Exception:
                config = {}
    if request.method == 'POST':
        config = {
            'user': request.form['user'],
            'password': request.form['password'],
            'ssh_authorized_keys': [request.form['ssh_key']],
            'wifi': {
                'ssid': request.form['wifi_ssid'],
                'psk': request.form['wifi_psk'],
                'country': request.form['wifi_country']
            },
            'eth': {
                'static_ip': request.form['eth_ip'],
                'netmask': request.form['eth_netmask'],
                'gateway': request.form['eth_gateway']
            },
            'language': request.form['language'],
            'timezone': request.form['timezone']
        }
        with open(CONFIG_PATH, 'w') as f:
            yaml.dump(config, f)
        flash('Konfiguration gespeichert! System kann jetzt neugestartet werden.')
        return redirect(url_for('setup'))
    # Werte an das Template übergeben
    return render_template('setup.html', config=config)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
