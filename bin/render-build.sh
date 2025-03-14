#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install


# Como estás usando una instancia gratuita, necesitas
# realizar las migraciones de la base de datos en el comando de construcción
bundle exec rails db:migrate