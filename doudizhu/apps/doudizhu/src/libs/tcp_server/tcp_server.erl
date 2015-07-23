-module(tcp_server).

-export([start/2, stop/1]).

start(Name, Port) ->
    tcp_server_listener_sup:start_link(Name, Port).

stop(_S) ->
    ok.