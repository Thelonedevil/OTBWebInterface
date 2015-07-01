@echo off
call bundle exec rake assets:precompile
call bundle exec warble war
pause