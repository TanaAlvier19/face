# Usa Python 3.10.11 baseado no Debian Bullseye (leve)
FROM python:3.10.11

# Define o diretório principal do projeto
WORKDIR /app

# Variáveis de ambiente
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Instala pacotes do sistema necessários para compilar dlib
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    gfortran \
    libopenblas-dev \
    liblapack-dev \
    libx11-dev \
    libgtk-3-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala dependências Python
COPY ./requirements.txt /app/
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copia o restante do código para o container
COPY . /app/

# Coleta arquivos estáticos e aplica migrações
RUN python manage.py collectstatic --noinput
RUN python manage.py migrate

# Expõe a porta usada pelo Gunicorn (Render espera 8000)
EXPOSE 8000

# Comando de inicialização do servidor (substitui o ENTRYPOINT)
CMD ["gunicorn", "recursos.wsgi:application", "--bind", "0.0.0.0:8000"]
