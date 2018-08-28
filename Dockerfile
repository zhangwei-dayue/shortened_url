FROM ruby:2.3.4

LABEL maintainer "zhangwei UrlShortener zhangwei19890518@gmail.com"

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs npm nodejs-legacy mysql-client vim

RUN gem install bundler

RUN mkdir -p /var/url_shortener

WORKDIR /var/url_shortener

COPY Gemfile /var/url_shortener/Gemfile
COPY Gemfile.lock /var/url_shortener/Gemfile.lock
RUN bundle install

ADD . /var/url_shortener
WORKDIR /var/url_shortener

EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
