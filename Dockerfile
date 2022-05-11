FROM ruby:3.1.2-alpine

WORKDIR /app

# get dependencies
COPY Gemfile /app/Gemfile

# install dependencies
RUN apk add make gcc g++ musl-dev curl \
 && bundle install \
 && apk del gcc g++ musl-dev

# copy file for the application
COPY config.ru /app/config.ru
COPY run.rb    /app/run.rb
COPY public    /app/public
COPY source    /app/source
COPY views     /app/views
COPY config    /app/config

# run aapplication as a service on port 8080
EXPOSE 8080

CMD ruby run.rb -s Puma -p 8080 -e production
