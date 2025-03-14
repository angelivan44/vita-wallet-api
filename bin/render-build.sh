#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Como estás usando una instancia gratuita, necesitas
# realizar las migraciones de la base de datos en el comando de construcción
bundle exec rails db:migrate