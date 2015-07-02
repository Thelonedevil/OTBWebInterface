#!/bin/bash
jruby -S bundle install
jruby -S bundle exec rake assets:precompile
jruby -S bundle exec warble war