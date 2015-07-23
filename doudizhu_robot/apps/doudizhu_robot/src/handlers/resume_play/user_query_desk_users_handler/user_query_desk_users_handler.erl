-module(user_query_desk_users_handler).

-export([handle_response/3]).

handle_response(Pid, Cmd, InfoBin) ->
    user_sit_on_desk_handler:handle_response(Pid, Cmd, InfoBin).