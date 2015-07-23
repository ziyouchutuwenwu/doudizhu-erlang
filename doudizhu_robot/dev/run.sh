cd ../;
rebar clean;
rebar compile;
cd dev;
erl -pa ../apps/*/ebin ../deps/*/ebin -config doudizhu_robot.config -args_file vm.args -eval "application:start(doudizhu_robot)."
