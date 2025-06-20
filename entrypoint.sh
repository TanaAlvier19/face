echo "Iniciando Django..."
python manage.py collectstatic --noinput
python manage.py migrate
echo "Iniciando Gunicorn na porta $PORT"
exec gunicorn recursos.wsgi:application --bind 0.0.0.0:$PORT
