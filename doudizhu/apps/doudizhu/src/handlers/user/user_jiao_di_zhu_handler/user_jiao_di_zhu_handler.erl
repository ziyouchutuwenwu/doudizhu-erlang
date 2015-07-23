-module(user_jiao_di_zhu_handler).

-export([handle_request/3]).

handle_request(Pid, Cmd, InfoBin) ->
    {JiaoDiZhu} = user_jiao_di_zhu_decoder:decode(InfoBin),
    UserId = user_map:get_userid_by_pid(Pid),
    DeskId = user_helper:get_user_deskid(UserId),

    case user_jiao_di_zhu_validator:is_request_validate(DeskId, UserId, Cmd, JiaoDiZhu) of
        true ->
            desk_working_pool_wrapper:do_desk_request(DeskId, Cmd, {UserId, JiaoDiZhu});
        _ ->
            ignore
    end.