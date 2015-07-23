-module(user_chu_pai_handler).

-export([handle_request/3]).

handle_request(Pid, Cmd, InfoBin) ->
    {Cards} = user_chu_pai_decoder:decode(InfoBin),
    UserId = user_map:get_userid_by_pid(Pid),
    DeskId = user_helper:get_user_deskid(UserId),

    case user_chu_pai_validator:is_request_validate(DeskId, UserId, Cmd, Cards) of
        true ->
            desk_working_pool_wrapper:do_desk_request(DeskId, Cmd, {UserId, Cards});
        _ ->
            ignore
    end,
    ok.