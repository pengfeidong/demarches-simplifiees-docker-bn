#!/bin/sh
set -e

bundle exec rake db:migrate || bundle exec rake db:schema:load && bundle exec rake db:seed
bundle exec rake jobs:schedule

exec bundle exec "$@"