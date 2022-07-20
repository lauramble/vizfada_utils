FROM python:3.8.5

WORKDIR /code

RUN apt-get update
RUN apt-get install libgirepository1.0-dev python-cairo python3-gi gobject-introspection gir1.2-gtk-3.0 -y

RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.30.0/bedtools.static.binary
RUN mv bedtools.static.binary /usr/bin/bedtools 
RUN chmod a+x /usr/bin/bedtools

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY . /code/app
WORKDIR /code/app

EXPOSE 8080

CMD ["gunicorn", "--conf", "conf/gunicorn_conf.py", "--bind", "0.0.0.0:8080", "VizFaDa.wsgi:application"]
