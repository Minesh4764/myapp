from flask import Flask
import signal
from datetime import datetime
app = Flask(__name__)

@app.route("/")
def home():
    print("thisis jsut a test")
    now = datetime.now()
    return f"Hello, World! Minesh Patel {now}"

def shutdown_server(signum, frame):
    print('Received signal %s, shutting down server...' % signum)
    func = request.environ.get('werkzeug.server.shutdown')
    if func is None:
        raise RuntimeError('Not running with the Werkzeug Server')
    func()


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
