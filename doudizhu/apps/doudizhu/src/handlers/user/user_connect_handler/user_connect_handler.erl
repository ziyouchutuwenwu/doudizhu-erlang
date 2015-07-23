-module(user_connect_handler).

-export([handle_request/1]).

handle_request(_Pid) ->
    io:format("Client connected ~n"),
    ok.