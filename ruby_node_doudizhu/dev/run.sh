cd ../;
rebar clean;
rebar compile;
cd dev;
erl -pa ../apps/*/ebin ../deps/*/ebin -config ruby_node_doudizhu.config -args_file vm.args -eval "application:start(ruby_node_doudizhu)."
