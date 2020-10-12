FROM ruby:2.7.0-alpine

RUN apk update && apk add bash build-base nodejs postgresql-dev tzdata

ENV RAILS_ENV=development

RUN mkdir /web
WORKDIR /web

COPY Gemfile Gemfile.lock ./
RUN gem install bundler --no-document
RUN bundle install --no-binstubs --jobs $(nproc) --retry 3

COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
