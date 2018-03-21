#!/bin/sh

cd /home/app/spellsheet/
RAILS_ENV=$PASSENGER_APP_ENV bundle exec rake db:migrate