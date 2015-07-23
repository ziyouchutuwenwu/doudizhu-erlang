-module(user_disconnect_handler).

-include_lib("doudizhu/src/const/socket_const.hrl").
-include_lib("doudizhu/src/const/playing_status_const.hrl").
-export([handle_request/2]).

%% 如果用户没进入桌子，则直接退出
%% 如果用户在桌子，没玩，则把他从桌子上弄出去，通知别人他下线
%% 如果用户在桌子，在玩，则通知别人他下线

handle_request(Pid, _Cmd) ->
    UserId = user_map:get_userid_by_pid(Pid),
    DeskId = user_helper:get_user_deskid(UserId),
    user_helper:set_user_online(UserId, 0),

    case desk_helper:get_desk_playing_status(DeskId) of
        ?STATUS_NOT_PLAYING ->
%%             清理用户的一些状态
            user_leave_desk_handler:do_user_leave_desk(?CMD_USER_LEAVE_DESK, UserId);
        _ ->
%%          先通知桌子上的人，有人下线，服务器打牌结束以后自动移除用户
            UsersOnDesk = desk_helper:sync_get_desk_all_users(DeskId),

            lists:foreach(
                fun(DeskUserId) ->
                    JsonBin = user_other_disconnect_encoder:encode(UserId),
                    UserPid = user_map:get_pid_by_userid(DeskUserId),
                    tcp_send:send_data(UserPid, ?CMD_OTHER_CLIENT_DISCONNECTED, JsonBin)
                end,
                UsersOnDesk
            )
    end,

    user_map:remove_by_pid(Pid),
    io:format("Client disconnected ~n"),
    ok.