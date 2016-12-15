#!/usr/bin/env bash
set -e

echo "Join Consul WAN ..."
sudo consul join -wan ${retry_join_wan}
