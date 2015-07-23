-module(query_desk_users_notification).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([notify/1]).

notify(UserId) ->
    DeskId = user_helper:get_user_deskid(UserId),
    UserIdList = desk_helper:get_desk_all_users(DeskId),

    LeftUserId = sort_helper:get_left_user(UserId, UserIdList),
    LeftUserOnline = user_helper:get_user_online(LeftUserId),
    LeftUserGender = user_helper:get_user_gender(LeftUserId),

    RightUserId = sort_helper:get_right_user(UserId, UserIdList),
    RightUserOnline = user_helper:get_user_online(RightUserId),
    RightUserGender = user_helper:get_user_gender(RightUserId),

    JsonBin = query_desk_users_encoder:encode(DeskId, 0,
        LeftUserId, LeftUserOnline, LeftUserGender,
        RightUserId, RightUserOnline, RightUserGender),
    UserPid = user_map:get_pid_by_userid(UserId),
    tcp_send:send_data(UserPid, ?CMD_QUERY_DESK_USERS, JsonBin),

    notify_other_users_sit(UserId, DeskId, UserIdList),
    ok.


%%     给桌子其他人发他进桌子的消息
notify_other_users_sit(UserId, DeskId, UserIdList) ->
    lists:foreach(
        fun(DeskUserId) ->
            case string:equal(DeskUserId, UserId) of
                false ->
                    LeftUserId = sort_helper:get_left_user(DeskUserId, UserIdList),
                    LeftUserOnline = user_helper:get_user_online(LeftUserId),
                    LeftUserGender = user_helper:get_user_gender(LeftUserId),

                    RightUserId = sort_helper:get_right_user(DeskUserId, UserIdList),
                    RightUserOnline = user_helper:get_user_online(RightUserId),
                    RightUserGender = user_helper:get_user_gender(RightUserId),

                    JsonBin = query_desk_users_encoder:encode(DeskId, 0,
                        LeftUserId, LeftUserOnline, LeftUserGender,
                        RightUserId, RightUserOnline, RightUserGender),
                    UserPid = user_map:get_pid_by_userid(DeskUserId),
                    tcp_send:send_data(UserPid, ?CMD_USER_SIT_ON_DESK, JsonBin);
                _ ->
                    ignore
            end
        end,
        UserIdList
    ).