FROM ruby:2.4

COPY . .
RUN gem uninstall bundler && gem install bundler && bundle install

CMD ["bundle", "exec", "puma", "-C", "puma.rb"]