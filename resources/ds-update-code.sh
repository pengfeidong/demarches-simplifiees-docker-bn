#!/bin/sh
echo '--Start delete SMTP config--'
sed -i '/ENV.fetch("SMTP_USER")/d' config/environments/production.rb
sed -i '/ENV.fetch("SMTP_PASS")/d' config/environments/production.rb
sed -i '/ENV.fetch("SMTP_AUTHENTICATION")/d' config/environments/production.rb
sed -i '/ENV.fetch("SMTP_TLS")/d' config/environments/production.rb
echo '--End delete SMTP config--'
cat config/environments/production.rb