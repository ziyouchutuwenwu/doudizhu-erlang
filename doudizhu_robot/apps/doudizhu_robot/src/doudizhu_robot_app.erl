-module(doudizhu_robot_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    user_map:start(),

    ServerIp = app_config:get_server_ip(),
    ServerPort = app_config:get_server_port(),
    tcp_client:start({ServerIp, ServerPort}, 2).

stop(_State) ->
    ok.
