-module(app_config).

-export([get_socket_port/0]).
-export([get_node_caller_prefix/0]).
-export([get_pgsql_ip/0, get_pgsql_username/0, get_pgsql_password/0, get_pgsql_db/0]).
-export([get_redis_ip/0, get_redis_port/0]).

get_socket_port() ->
    {ok, Val} = application:get_env(listen_port),
    Val.

get_node_caller_prefix() ->
    {ok, Val} = application:get_env(node_caller_prefix),
    Val.

get_pgsql_ip() ->
    {ok, Val} = application:get_env(pgsql_ip),
    Val.

get_pgsql_username() ->
    {ok, Val} = application:get_env(pgsql_username),
    Val.

get_pgsql_password() ->
    {ok, Val} = application:get_env(pgsql_password),
    Val.

get_pgsql_db() ->
    {ok, Val} = application:get_env(pgsql_db),
    Val.

get_redis_ip() ->
    {ok, Val} = application:get_env(redis_ip),
    Val.

get_redis_port() ->
    {ok, Val} = application:get_env(redis_port),
    Val.