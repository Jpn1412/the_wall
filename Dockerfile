# Use an official Ruby runtime as a parent image
FROM ruby:3.2.2

ENV BUNDLER_VERSION=2.3.2

# Install dependencies
RUN apt-get update && \
    apt-get install -y --force-yes \
    gnupg2 \
    build-essential \
    nodejs 

# Set the working directory
WORKDIR /mv_wall

# COPY 
COPY mv_wall /mv_wall
RUN gem install bundler -v '~> 2.3.26' && \
    bundle install --jobs 4

RUN gem update --system 3.4.22
RUN gem install debase-ruby_core_source 

# Expose ports
EXPOSE 3001

# Set the entrypoint command
CMD ["rails", "server", "-b", "0.0.0.0","-e","development"]