-module(app_config).

-export([get_ruby_script_path/0]).

get_ruby_script_path() ->
    {ok, Val} = application:get_env(ruby_script_path),
    Val.