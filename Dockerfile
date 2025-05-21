FROM docker.io/ruby:3.4.4 as base

RUN apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get clean
RUN apt-get install -y curl sudo && apt-get autoremove && apt-get clean

RUN curl -sL https://deb.nodesource.com/setup_22.x | sudo bash -
RUN curl -fsSL https://bun.sh/install | bash
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get upgrade -y && apt-get install -y yarn && apt-get autoremove && apt-get clean

FROM base as builder

RUN apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get clean && apt-get install -y htop curl build-essential sudo git gnupg wget libcurl3-dev libpq-dev zlib1g-dev libicu-dev s3fs && apt-get autoremove && apt-get clean

# DS
ARG TAG=2025-05-21-01
RUN git clone --branch $TAG --depth 1 https://github.com/demarches-simplifiees/demarches-simplifiees.fr.git ds
WORKDIR /ds

RUN bundle install
RUN yarn install
ENV PATH="/root/.bun/bin:$PATH"
RUN bun install --production
COPY resources/* /ds

RUN mv config/initializers/flipper.rb config/initializers/flipper.rb.backup
RUN RAILS_ENV=production bundle exec rails assets:precompile
RUN mv config/initializers/flipper.rb.backup config/initializers/flipper.rb

RUN rm -rf node_modules

FROM ruby:3.4.4 as runner

WORKDIR /ds
COPY --from=builder /ds /ds
RUN bundle install

RUN sh ds-update-code.sh

EXPOSE 3000
RUN if [ "$DS_ENTRYPOINT" = "true" ] ; then sh /ds/ds-entry-point.sh ; fi
CMD ["rails", "server", "-p", "3000"]