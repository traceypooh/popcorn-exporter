celery -A server.celery worker &
uwsgi --socket 0.0.0.0:5000 --protocol=http -w wsgi
