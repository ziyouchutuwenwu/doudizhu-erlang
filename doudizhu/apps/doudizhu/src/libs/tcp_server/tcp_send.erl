-module(tcp_send).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([send_data/3]).

send_data(Pid, Cmd, JsonBin) ->
    case erlang:is_pid(Pid) of
        true ->
            gen_server:cast(Pid, {send_socket_msg, Cmd, JsonBin});
        false ->
%%             io:format("socket pid invalid, ignore~n"),
            ignore
    end.