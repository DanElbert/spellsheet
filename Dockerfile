FROM phusion/passenger-ruby24:latest

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Enable Nginx / Passenger
RUN rm -f /etc/service/nginx/down

# Install nginx config files
RUN rm /etc/nginx/sites-enabled/default
ADD docker/nginx_server.conf /etc/nginx/sites-enabled/spellsheet.conf
ADD docker/nginx_env.conf /etc/nginx/main.d/env.conf

# Set Default RAILS_ENV
ENV PASSENGER_APP_ENV docker

# Setup directory and install gems
RUN mkdir -p /home/app/spellsheet/
COPY Gemfile /home/app/spellsheet/
COPY Gemfile.lock /home/app/spellsheet/
RUN cd /home/app/spellsheet/ && bundle install --deployment

# Copy the app into the image
COPY . /home/app/spellsheet/
WORKDIR /home/app/spellsheet/

# Set log permissions
RUN mkdir -p /home/app/spellsheet/log
RUN chmod 0777 /home/app/spellsheet/log

# Compile assets
RUN env RAILS_ENV=production bundle exec rake assets:clobber assets:precompile

# Set ownership of the tmp folder
RUN chown -R app:app /home/app/spellsheet/tmp

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
