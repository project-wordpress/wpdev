import http.client
import logging
import sys
import time

"""
This script will wait for a host and perform a `GET` request.
It will retry each second till `http status` `STATUS` is given.
Timeout is not a timeout actually.
Example:
    python ./connect.py HOST PORT PATH STATUS TIMEOUT
"""
# While Wordpress is not installed:
# status: `302` -> /wp-admin/install.php
# When its installed, it should:
# status: `200`
# When its installing or preparing:
# status: `502`

logger = logging.getLogger(__name__)

HOST = sys.argv[1]
PORT = int(sys.argv[2])
PATH = sys.argv[3]
STATUS = int(sys.argv[4])
TIMEOUT = int(sys.argv[5]) if len(sys.argv) >= 6 else 60

MSG = dict(host=HOST, port=PORT, path=PATH, status=STATUS, timeout=TIMEOUT)

def response(tries=0, err=None):

    while tries < TIMEOUT:  # its a timeout, but not really
        try:
            conn = http.client.HTTPConnection(HOST, PORT, TIMEOUT)
            logger.info(MSG)

            conn.request("GET", PATH)
            resp = conn.getresponse()

            if resp.status != STATUS:
                logger.debug(f"Status {resp.status}... waiting...")
                raise ConnectionError()
            else:
                logging.info(resp.headers)
                return

        except (ConnectionError, http.client.ImproperConnectionState) as exc:
            err=exc
            tries+=1
            time.sleep(1)
            
    try: logging.info(resp.headers)
    except: pass

    raise err


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    response()
