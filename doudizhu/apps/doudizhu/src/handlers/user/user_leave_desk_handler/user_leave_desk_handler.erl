-module(user_leave_desk_handler).

-export([handle_request/3]).
-export([do_user_leave_desk/2]).

handle_request(Pid, Cmd, _InfoBin) ->
    UserId = user_map:get_userid_by_pid(Pid),

    %验证有效，向桌子上所有的人群发消息
    case user_leave_desk_validator:is_request_validate(UserId) of
        true ->
            do_user_leave_desk(Cmd, UserId);
        _ ->
            ignore
    end,
    ok.

%以供换桌调用
do_user_leave_desk(Cmd, UserId) ->
    %验证有效，向桌子上所有的人群发消息
    DeskId = user_helper:get_user_deskid(UserId),
    UsersOnDesk = desk_helper:sync_get_desk_all_users(DeskId),

    desk_helper:sync_remove_user_from_desk(DeskId, UserId),
    user_helper:remove_user_deskid(UserId),

    user_helper:remove_user_online(UserId),
    user_helper:remove_user_gender(UserId),
    user_helper:remove_user_ready(UserId),

    lists:foreach(
        fun(DeskUserId) ->
            JsonBin = user_leave_desk_encoder:encode(UserId),
            UserPid = user_map:get_pid_by_userid(DeskUserId),
            tcp_send:send_data(UserPid, Cmd, JsonBin)
        end,
        UsersOnDesk
    ).