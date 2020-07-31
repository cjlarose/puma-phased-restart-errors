FROM ruby:2.7.0

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
COPY vendor ./vendor

RUN bundle config set path '.bundle'
RUN bundle install --local

COPY . .

CMD ["./entrypoint.sh"]
