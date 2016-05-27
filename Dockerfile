# Dockerfile

FROM phusion/passenger-ruby21:0.9.15
MAINTAINER Aditya Raghuwanshi "adi.version1@gmail.com"

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Expose Nginx HTTP service
EXPOSE 80

# Start Nginx / Passenger
RUN rm -f /etc/service/nginx/down

# Remove the default site
RUN rm /etc/nginx/sites-enabled/default

# Add the nginx site and config
ADD nginx.conf /etc/nginx/sites-enabled/spree-store.conf
ADD rails-env.conf /etc/nginx/main.d/rails-env.conf

# Install bundle of gems
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install

# Add the Rails app
ADD . /home/app/spree-store
RUN chown -R app:app /home/app/spree-store

# Clean up APT and bundler when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
