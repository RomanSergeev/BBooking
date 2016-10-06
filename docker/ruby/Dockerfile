FROM ruby:2.3.1
RUN apt-get update && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /project
WORKDIR /project
ADD Gemfile.lock /project/Gemfile.lock
ADD Gemfile /project/Gemfile
RUN bundle install
ADD . /project
