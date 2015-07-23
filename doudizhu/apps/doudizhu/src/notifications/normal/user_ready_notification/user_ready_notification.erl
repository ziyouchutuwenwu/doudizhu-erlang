-module(user_ready_notification).

-export([send_notitication/1]).
-include_lib("doudizhu/src/const/socket_const.hrl").

%% 当桌子上的用户是ready状态，就发
send_notitication(UserId) ->
    DeskId = user_helper:get_user_deskid(UserId),

    UsersOnDesk = desk_helper:get_desk_all_users(DeskId),
    lists:foreach(
        fun(DeskUserId) ->
            DeskUserReady = user_helper:get_user_ready(DeskUserId),
            case DeskUserReady of
                1 ->
                    JsonBin = user_ready_to_play_encoder:encode(DeskUserId),
                    UserPid = user_map:get_pid_by_userid(UserId),
                    tcp_send:send_data(UserPid, ?CMD_USER_READY_TO_PLAY, JsonBin);
                _ ->
                    ignore
            end
        end,
        UsersOnDesk
    ).