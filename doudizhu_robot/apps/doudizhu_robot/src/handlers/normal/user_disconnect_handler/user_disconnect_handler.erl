-module(user_disconnect_handler).

-export([handle_response/2]).

handle_response(Pid, _Cmd) ->
    UserId = user_map:get_userid_by_pid(Pid),

    case length(UserId) of
        0 ->
            ignore;
        _ ->
            user_storage:destroy(UserId),
            user_map:remove_by_pid(Pid)
    end,
    io:format("client disconnected ~n"),
    ok.