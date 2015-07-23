-module(app_config).

-export([get_server_port/0, get_server_ip/0]).

get_server_port() ->
    {ok, Val} = application:get_env(server_port),
    Val.

get_server_ip() ->
    {ok, Val} = application:get_env(server_ip),
    Val.