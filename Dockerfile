FROM dongpengfei/ruby-node-yarn:3.1.3-16.20.0-1.22.19 as builder

RUN apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get clean && apt-get install -y htop curl build-essential sudo git gnupg wget libcurl3-dev libpq-dev zlib1g-dev libicu-dev s3fs && apt-get autoremove && apt-get clean

# DS
ARG TAG=2023-04-25-01
RUN git clone --branch $TAG --depth 1 https://github.com/demarches-simplifiees/demarches-simplifiees.fr.git ds
WORKDIR /ds

RUN yarn install --production
RUN bundle install
COPY resources/* /ds

RUN mv config/initializers/flipper.rb config/initializers/flipper.rb.backup
RUN RAILS_ENV=production bundle exec rails assets:precompile
RUN mv config/initializers/flipper.rb.backup config/initializers/flipper.rb

RUN rm -rf node_modules

FROM ruby:3.1.3 as runner

WORKDIR /ds
COPY --from=builder /ds /ds
RUN bundle install

RUN sh ds-update-code.sh

EXPOSE 3000
RUN if [ "$DS_ENTRYPOINT" = "true" ] ; then sh /ds/ds-entry-point.sh ; fi
CMD ["rails", "server", "-p", "3000"]