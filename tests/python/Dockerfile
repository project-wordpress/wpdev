FROM python:3.8-alpine
WORKDIR /apps

RUN pip install requests

ARG FILE="connect.py"
COPY $FILE /apps

RUN printf "#!/bin/sh\npython $FILE \$@\n" > entrypoint.sh

RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
