# Use slim Ruby image to keep size low
FROM ruby:3.3-slim AS base

# Default env vars
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=true \
    BUNDLE_PATH=/bundle \
    LANG=C.UTF-8

# Install base packages
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential libpq-dev git curl nodejs npm yarn \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy Gemfiles and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# Install JS deps (for Tailwind)
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy app code
COPY . .

# Precompile assets
RUN bundle exec rails assets:precompile

# Expose app port
EXPOSE 3000

# Default command
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]