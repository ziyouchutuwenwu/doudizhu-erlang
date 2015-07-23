-module(user_query_desk_chu_pai_handler).

-export([handle_response/3]).

handle_response(Pid, Cmd, InfoBin) ->
    user_chu_pai_handler:handle_response(Pid, Cmd, InfoBin).