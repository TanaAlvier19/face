# Usa Python 3.10.11
FROM python:3.10.11-slim-bookworm

WORKDIR /app
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN apt-get update

RUN pip install --upgrade pip
COPY ./requirements.txt /app/
RUN pip install -r requirements.txt

COPY . /app/

RUN python manage.py collectstatic --noinput
RUN python manage.py migrate

EXPOSE 8000

ENTRYPOINT ["gunicorn", "recursos.wsgi"]
