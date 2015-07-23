-module(other_user_disconnect_handler).

-export([handle_response/3]).

handle_response(_Pid, _Cmd, _JsonBin) ->
    io:format("other client disconnected ~n"),
    ok.