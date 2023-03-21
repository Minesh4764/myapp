from flask import Flask
import signal
from datetime import datetime
app = Flask(__name__)

import logging
import sys

# Configure the logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

# Create a formatter
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

# Create a handler that writes to stdout
stdout_handler = logging.StreamHandler(sys.stdout)
stdout_handler.setLevel(logging.DEBUG)
stdout_handler.setFormatter(formatter)

# Create a handler that writes to stderr
stderr_handler = logging.StreamHandler(sys.stderr)
stderr_handler.setLevel(logging.ERROR)
stderr_handler.setFormatter(formatter)

# Add the handlers to the logger
logger.addHandler(stdout_handler)
logger.addHandler(stderr_handler)

# Use the logger to write log messages
logger.info('Starting the app')

# Your application code goes here

logger.info('Application finished')
@app.route("/")
def home():
    print("thisis jsut a test")
    now = datetime.now()
    return f"Hello, World! Minesh Patel{now}"

def shutdown_server(signum, frame):
    print('Received signal %s, shutting down server...' % signum)
    func = request.environ.get('werkzeug.server.shutdown')
    if func is None:
        raise RuntimeError('Not running with the Werkzeug Server')
    func()


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=82)
