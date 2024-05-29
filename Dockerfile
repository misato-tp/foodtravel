FROM ruby:3.0.6
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn
WORKDIR /foodtravel
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
RUN bundle exec rails webpacker:install
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
