#!/bin/sh
set -e

# Docker example.
# https://docs.docker.com/samples/rails/

# Remove a potentially pre-existing server.pid for Rails.
# https://stackoverflow.com/questions/35022428/rails-server-is-still-running-in-a-new-opened-docker-container
rm -f tmp/pids/server.pid

# Fix host port error.
# https://github.com/locomotivecms/wagon/issues/340
cp /etc/hosts /etc/hosts.new && \
    sed -i 's/::1\tlocalhost ip6-localhost ip6-loopback/::1 ip6-localhost ip6-loopback/' /etc/hosts.new && \
    cp -f /etc/hosts.new /etc/hosts

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"