FROM ruby:2.4.2

ENV APP_PATH /usr/src/app/

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir -p $APP_PATH

WORKDIR $APP_PATH

ADD ./Gemfile* $APP_PATH

RUN bundle install

CMD ["bundle", "exec"]
