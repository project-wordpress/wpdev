import json
import logging
import re
import sys
import urllib.parse

import requests

logger = logging.getLogger(__name__)

URL = sys.argv[1]
NETLOC = urllib.parse.urlparse(URL)[1]

ALLOWED_MAP = {
    # if any of these strings is in url, error is allowed
    405: ["/xmlrpc.php", "wp-comments-post.php"],
    400: ["?rest_route="],
}

def parse_urls(body: str):
    # todo handle all urls, not only these starting with http
    return [x[:-1] for x in re.findall(r"http[s]?://.*?[\'\"]", body)]

def is_parsable(url: str):
    parsed = urllib.parse.urlparse(url)
    if parsed[1] == NETLOC:
        logging.debug(f"Parsable url {url}")
        return True
    logging.debug(f"Not parsable {url}")
    return False

def get_body(url: str) -> (int, str):
    resp = requests.get(url, allow_redirects=True)
    try:
        if any(x in url for x in ["js", ".css", ".png", ".jpg", ".jpeg", ".gif", ".ico"]):
            return resp.status_code, ""
        body = resp.content.decode()
        return resp.status_code, body
    except Exception as exc:
        # parsing this body failed
        logger.exception(exc)
        return 0, exc.__repr__()

def main():
    SUCCESS = {}
    ERRORS = {}
    ERRORS_ALLOWED = {}
    ERRORS_BODY = {}
    PARSED = {}
    TODO = []
    ALL = []

    homepage_status, homepage = get_body(URL)
    if homepage_status != 200: raise Exception(URL, homepage_status)

    TODO.extend(parse_urls(homepage))

    if not TODO:
        raise Exception("TODO is empty! Fuck!")

    while TODO:
        for url in TODO.copy():
            TODO.pop(0)
            if is_parsable(url) and not PARSED.get(url):
                status, body = get_body(url)

                if status == 0:
                    ERRORS_BODY[url] = body

                urls = parse_urls(body)

                ALL.extend(urls)
                TODO.extend(urls)

                PARSED[url] = status

    for url, status in PARSED.items():

        if status == 200:
            SUCCESS[url] = status
            continue

        elif rules := ALLOWED_MAP.get(status):
            if any(r in url for r in rules):
                ERRORS_ALLOWED[url] = status
                continue
        else:
            ERRORS[url] = status

    print("PARSED")
    print(json.dumps(PARSED, indent=4))
    print("ERRORS_ALLOWED")
    print(json.dumps(ERRORS_ALLOWED, indent=4))
    print("ERRORS_BODY")
    print(json.dumps(ERRORS_BODY, indent=4))
    print("ERRORS")
    print(json.dumps(ERRORS, indent=4))

    if ERRORS:
        logging.error("Errors! Fuck!")
        sys.exit(1)

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    main()
