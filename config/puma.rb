app = "modl-uk"

workers  5
threads  1, 1 # relying on many workers for thread-unsafe apps

rackup      DefaultRackup
port        8080
environment 'production'

pidfile "./puma.pid"
bind "unix:/tmp/puma.socket"