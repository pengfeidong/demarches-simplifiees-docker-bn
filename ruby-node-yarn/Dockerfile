FROM docker.io/ruby:3.3.0

RUN apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get clean
RUN apt-get install -y curl sudo && apt-get autoremove && apt-get clean


RUN curl -sL https://deb.nodesource.com/setup_20.x | sudo bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get upgrade -y && apt-get install -y yarn && apt-get autoremove && apt-get clean

