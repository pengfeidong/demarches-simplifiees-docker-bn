#!/bin/sh
echo '--Start delayed_job--'
bundle exec "./bin/delayed_job restart"
echo '--Delayed_job started--'