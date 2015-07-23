-module(doudizhu_app).

-behaviour(application).
-export([start/2, stop/1]).

init_user_map() ->
    user_map:start().

init_desk_map() ->
    desk_map:start().

init_desk_timers() ->
    desk_timer:init_timers().

start_user_working_pool() ->
    user_working_pool_sup:start_link().

start_desk_operation_pool() ->
    desk_working_pool_sup:start_link().

start_redis_conn_pool() ->
    redis_conn_pool_sup:start_link().

start_pgsql_conn_pool() ->
    pgsql_conn_pool_sup:start_link().

start_node_caller_pool() ->
    node_caller_pool_sup:start_link().


start(_StartType, _StartArgs) ->

    crypto:start(),

    init_user_map(),
    init_desk_map(),
    init_desk_timers(),

    start_user_working_pool(),
    start_desk_operation_pool(),
    start_redis_conn_pool(),
    start_pgsql_conn_pool(),
    start_node_caller_pool(),

    ListenPort = app_config:get_socket_port(),
    io:format("~p~n", [ListenPort]),
    tcp_server:start(doudizhu, ListenPort).

stop(_State) ->
    ok.