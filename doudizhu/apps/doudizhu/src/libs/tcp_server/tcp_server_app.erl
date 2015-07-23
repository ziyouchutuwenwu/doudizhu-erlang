-module(tcp_server_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
    ok.

stop(_S) ->
    ok.