FROM ruby:2.3.1
RUN apt-get update && apt-get install -y build-essential libpq-dev nodejs
RUN useradd -ms /bin/bash dockeruser
USER dockeruser
WORKDIR /home/dockeruser/project
ADD Gemfile.lock /home/dockeruser/project/Gemfile.lock
ADD Gemfile /home/dockeruser/project/Gemfile
RUN bundle install
ADD . /home/dockeruser/project
