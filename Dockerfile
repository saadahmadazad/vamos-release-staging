FROM ruby:2.6.2
ENV LANG C.UTF-8

ENV APP_ROOT /usr/src/app/

# install required libraries
RUN apt-get update -qq
RUN apt-get install -y gnupg
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y build-essential libpq-dev postgresql-client nodejs curl npm
RUN npm install -g n
RUN n stable
RUN npm install -g yarn

# install bundler
RUN gem install bundler

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

ADD package.json package.json
ADD yarn.lock yarn.lock
RUN yarn install --check-files

WORKDIR ${APP_ROOT}
COPY . ${APP_ROOT}