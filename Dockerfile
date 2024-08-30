FROM ruby:3.3

ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    BUNDLE_PATH=/gems

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libsqlite3-dev \
  nodejs \
  yarn \
  vim \
  git

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install --without development test

COPY . .

RUN bundle exec rake assets:precompile

EXPOSE 3000

RUN bundle exec rails db:migrate

RUN bundle exec rails runner "VideoDataExtractor.extract_and_upsert_videos"

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
