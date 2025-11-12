# Dockerfile
FROM ruby:3.3-slim

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential libpq-dev nodejs curl

WORKDIR /app

# Install Ruby dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# Copy the rest of the app
COPY . .

# Precompile assets (if needed)
RUN bundle exec rails assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
