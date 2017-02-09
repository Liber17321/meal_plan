FROM ruby:2.3.1

ADD sources.list /etc/apt/sources.list

RUN  apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 40976EAF437D05B5 \
  &&  apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 3B4FE6ACC0B21F32 \
  && bundle config mirror.https://rubygems.org https://gems.ruby-china.org

RUN apt-get update -yq \
  && apt-get install -yq --no-install-recommends \
    postgresql-client \
    nodejs \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists

# Pre-install gems with native extensions
RUN gem install nokogiri -v "1.6.8.1"

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .

EXPOSE 3000
CMD rails server -b 0.0.0.0
