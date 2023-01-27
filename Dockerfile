FROM ruby:3.1.3

RUN apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get clean
RUN apt-get install -y htop curl build-essential sudo git gnupg wget libcurl3-dev libpq-dev zlib1g-dev libicu-dev && apt-get autoremove && apt-get clean

# Yarn
RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get upgrade -y && apt-get install -y yarn && apt-get autoremove && apt-get clean

# DS
RUN git clone https://github.com/betagouv/demarches-simplifiees.fr.git ds
WORKDIR /ds

RUN yarn install --production
RUN bundle install
COPY resources/* /ds

RUN mv config/initializers/flipper.rb config/initializers/flipper.rb.backup
RUN RAILS_ENV=production bundle exec rails assets:precompile
RUN mv config/initializers/flipper.rb.backup config/initializers/flipper.rb

EXPOSE 3000
ENTRYPOINT ["/ds/ds-entry-point.sh"]
RUN openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout ds_ssl.key -out ds_ssl.crt -subj "/C=FR/ST=Paris/L=Paris/O=Global Security/OU=IT Department/CN=demarches-simplifiees.fr"
CMD ["rails", "server", "-b", "ssl://0.0.0.0:3000?key=ds_ssl.key&cert=ds_ssl.crt"]
