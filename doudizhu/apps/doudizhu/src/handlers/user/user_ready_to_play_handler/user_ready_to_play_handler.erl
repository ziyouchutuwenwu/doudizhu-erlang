-module(user_ready_to_play_handler).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([handle_request/3]).

%先设置当前用户的ready状态，最后检查所有人是不是都是ready，如果是，则开始叫地主
handle_request(Pid, Cmd, _InfoBin) ->
    UserId = user_map:get_userid_by_pid(Pid),

    DeskId = user_helper:get_user_deskid(UserId),
    UsersOnDesk = desk_helper:sync_get_desk_all_users(DeskId),

    user_helper:set_user_ready(UserId, 1),

    lists:foreach(
        fun(DeskUserId) ->
            JsonBin = user_ready_to_play_encoder:encode(UserId),
            UserPid = user_map:get_pid_by_userid(DeskUserId),
            tcp_send:send_data(UserPid, Cmd, JsonBin)
        end,
        UsersOnDesk
    ),

    AreAllDeskUsersReady = lists:all(
        fun(DeskUserId) ->
            1 == user_helper:get_user_ready(DeskUserId)
        end,
        UsersOnDesk
    ),

    if
        length(UsersOnDesk) =:= 3 andalso AreAllDeskUsersReady =:= true ->
            case user_ready_to_play_validator:is_request_validate(DeskId) of
                true ->
                    desk_working_pool_wrapper:do_desk_request(DeskId, ?CMD_USER_READY_TO_PLAY, {UserId});
                _ ->
                    ignore
            end;
        true ->
            ignore
    end,
    ok.