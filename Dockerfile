FROM dongpengfei/ruby-node-yarn:3.1.3-16.20.0-1.22.19

RUN apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get clean
RUN apt-get install -y htop build-essential git gnupg wget libcurl3-dev libpq-dev zlib1g-dev libicu-dev && apt-get autoremove && apt-get clean

# DS
ARG TAG=main
RUN git clone --branch $TAG --depth 1 https://github.com/demarches-simplifiees/demarches-simplifiees.fr.git ds
WORKDIR /ds

RUN yarn install --production
RUN bundle install
COPY resources/* /ds

RUN mv config/initializers/flipper.rb config/initializers/flipper.rb.backup
RUN RAILS_ENV=production bundle exec rails assets:precompile
RUN mv config/initializers/flipper.rb.backup config/initializers/flipper.rb

EXPOSE 3000
RUN if [ "$DS_ENTRYPOINT" = "true" ] ; then sh /ds/ds-entry-point.sh ; fi
RUN openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout ds_ssl.key -out ds_ssl.crt -subj "/C=FR/ST=Paris/L=Paris/O=Global Security/OU=IT Department/CN=demarches-simplifiees.fr"
CMD ["rails", "server", "-b", "ssl://0.0.0.0:3000?key=ds_ssl.key&cert=ds_ssl.crt"]