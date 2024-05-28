FROM ruby:3.0.6

RUN apt-get update -qq && \
    apt-get install -y build-essential \
                        libpq-dev \
                        nodejs

RUN mkdir /foodtravel

ENV APP_ROOT /foodtravel 
WORKDIR $APP_ROOT

ADD ./Gemfile $APP_ROOT/Gemfile
ADD ./Gemfile.lock $APP_ROOT/Gemfile.lock

RUN gem install bundler 
RUN bundle install
ADD . $APP_ROOT

