FROM ruby:2.2.7
RUN mkdir /temp
COPY Gemfile* /temp/
RUN gem install bundler
WORKDIR /temp
RUN bundle install
VOLUME /app
WORKDIR /app
