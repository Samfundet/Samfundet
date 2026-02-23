# Set manually (from '.ruby-version') because Dockerfile is unable to cat from file.
FROM ruby:3.3-trixie

# Docker example.
# https://docs.docker.com/samples/rails/

# Change RUN shell from /bin/sh to /bin/bash.
SHELL ["/bin/bash", "-c"]

# Update Ubuntu Software repository.
RUN ls \
    && apt update -y \
    && apt upgrade -y \
    && apt install -y --no-install-recommends build-essential openssl ca-certificates git procps curl file git nano sudo ncdu gcc postgresql libpq-dev make git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison libyaml-dev libncurses5-dev libffi-dev libgdbm-dev imagemagick nodejs bzip2 graphviz shared-mime-info \
    && sudo update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set working directory.
WORKDIR /Samfundet

# Set manually (from '.bundler-version') because Dockerfile is unable to cat from file.
RUN gem install bundler:2.4.22

# Copy dependency files into workdir (optimise docker cache layers)
COPY Gemfile Gemfile.lock ./

# Install dependencies.
RUN bundle install

# Copy the project into image.
COPY . /Samfundet

# Set environment.
ENV RAILS_ENV=development

# Compile assets (might not be needed).
RUN bundle exec rake assets:precompile

# Expose port.
EXPOSE 3000

# Enables us to run code before the final command.
ENTRYPOINT ["/Samfundet/entrypoint.sh"]

# Start server listening on all interfaces.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
