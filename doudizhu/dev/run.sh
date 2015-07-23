cd ../;
rebar clean;
rebar compile;
cd dev;
erl -pa ../apps/*/ebin ../deps/*/ebin -config doudizhu.config -args_file vm.args -eval "application:start(doudizhu)."
