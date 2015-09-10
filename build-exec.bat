@echo off
call jruby -S bundle install
call jruby -S bundle exec rake assets:precompile
call jruby -S bundle exec warble executable war
pause