FROM ruby:2.7.1-alpine

RUN apk update -qq && apk add nodejs postgresql-client

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY Gemfile /usr/src/app

COPY Gemfile.lock /usr/src/app

RUN apk --update add --no-cache --virtual run-dependencies \
  bash \
  build-base \
  tzdata \
  postgresql-client \
  postgresql-dev \
  git

RUN gem install bundler

RUN bundle install

RUN mkdir /usr/src/app/config

COPY config/schedule.rb /usr/src/app/config/

RUN touch /var/log/cron.log

RUN bundle exec whenever --update crontab

RUN gem install rails -v 5.2.6

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

ENV DOCKERIZE_VERSION v0.5.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz


# Start the main process.
CMD dockerize -wait tcp://postgres:5432 -timeout 1m && rails server -b 0.0.0.0 && crond && tail -f /var/log/cron.log