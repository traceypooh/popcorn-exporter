/etc/init.d/rabbitmq-server start
rabbitmqctl add_vhost myvhost
rabbitmqctl add_user myuser mypassword
rabbitmqctl set_permissions -p myvhost myuser ".*" ".*" ".*"
celery -A server.celery worker &
uwsgi --socket 0.0.0.0:5000 --protocol=http -w wsgi
# python server.js
