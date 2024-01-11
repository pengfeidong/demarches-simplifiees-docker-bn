#!/bin/sh
echo '--Start delete SMTP config--'
sed -i 's/ENV.fetch("SMTP_PORT"),/ENV.fetch("SMTP_PORT")/g' config/environments/production.rb
sed -i '/domain:               ENV.fetch("SMTP_HOST")/d' config/environments/production.rb
sed -i '/ENV.fetch("SMTP_USER")/d' config/environments/production.rb
sed -i '/ENV.fetch("SMTP_PASS")/d' config/environments/production.rb
sed -i '/ENV.fetch("SMTP_AUTHENTICATION")/d' config/environments/production.rb
sed -i '/ENV.fetch("SMTP_TLS")/d' config/environments/production.rb
sed -i '/config.force_ssl/d' config/environments/production.rb
echo '--End delete SMTP config--'
cat config/environments/production.rb