FROM python:3.9-slim-bookworm

RUN apt-get update \
  && apt-get install --no-install-recommends -y python3-pip git libglib2.0-dev python3-opencv

ARG ACCESS_KEY
ARG SECRET_ACCESS

ENV AWS_ACCESS_KEY_ID=$ACCESS_KEY
ENV AWS_SECRET_ACCESS_KEY=$SECRET_ACCESS

WORKDIR /app
 
COPY ./requirements.txt /requirements.txt
 
RUN pip install --no-cache-dir --upgrade -r /requirements.txt 
 
RUN git clone https://github.com/ultralytics/ultralytics /app

COPY ./app /app

RUN pip install --no-cache -e ".[export]" thop --extra-index-url https://download.pytorch.org/whl/cpu

RUN pip install --no-cache paddlepaddle==2.4.2 x2paddle uvicorn opencv-python-headless

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
