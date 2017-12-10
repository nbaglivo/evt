FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libmysqlclient-dev
RUN mkdir /dipo
WORKDIR /dipo
ADD Gemfile /dipo/Gemfile
ADD Gemfile.lock /dipo/Gemfile.lock
RUN bundle install
ADD . /dipo
