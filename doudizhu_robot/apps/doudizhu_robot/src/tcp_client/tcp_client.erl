-module(tcp_client).

-export([start/2, stop/1]).

start({Ip, Port}, ClientNumber) ->
    case tcp_client_handler_sup:start_link({Ip, Port}) of
        {ok, Pid} ->
            IndexList = lists:seq(1, ClientNumber),
            lists:foreach(
                fun(_Index) ->
                    tcp_client_handler_sup:start_child()
                end,
                IndexList
            ),
            {ok, Pid};
        _ ->
            {error, failed}
    end.

stop(_S) ->
    ok.