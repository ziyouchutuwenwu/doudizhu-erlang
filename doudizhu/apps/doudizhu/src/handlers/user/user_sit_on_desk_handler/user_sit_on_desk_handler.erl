-module(user_sit_on_desk_handler).

-export([handle_request/3]).
-export([handle_delay_cast/1]).

handle_request(Pid, Cmd, InfoBin) ->
    {RoomId} = user_sit_on_desk_decoder:decode(InfoBin),
    UserId = user_map:get_userid_by_pid(Pid),

    case user_sit_on_desk_validator:is_request_validate(UserId) of
        true ->
            user_helper:set_user_roomid(UserId, RoomId),
            Num = random_generator:random_number() rem 3 + 1,
            user_working_pool_wrapper:delay_cast(Num * 1000, {?MODULE, handle_delay_cast}, {Pid, Cmd, UserId, RoomId});
        _ ->
            ignore
    end.

%% 私有方法
handle_delay_cast({Pid, Cmd, UserId, RoomId}) ->
    do_user_sit_on_desk(Pid, Cmd, UserId, RoomId),
    user_prompt_ready_notification:send_notitication(UserId),
    user_ready_notification:send_notitication(UserId).

do_user_sit_on_desk(Pid, Cmd, UserId, RoomId) ->
    DeskIdList = desk_helper:get_deskids_by_roomid(RoomId),

    case length(DeskIdList) of
        0 ->
            io:format("sorry no desk for this room~n"),
            DeskId = "",
            JsonBin = user_sit_on_desk_encoder:encode(DeskId, 1, "", 0, "", "", 0, ""),
            tcp_send:send_data(Pid, Cmd, JsonBin);
        _ ->
            Index = random_generator:random_number() rem length(DeskIdList) + 1,
            DeskId = lists:nth(Index, DeskIdList),
            UsersOnDeskNumber = desk_helper:sync_get_desk_user_number(DeskId),
            if UsersOnDeskNumber < 3 ->
                desk_helper:sync_add_user_to_desk(DeskId, UserId),
                user_helper:set_user_online(UserId, 1),
                user_helper:set_user_deskid(UserId, DeskId),

                %向桌子上所有的人群发消息
                UsersOnDesk = desk_helper:sync_get_desk_all_users(DeskId),
                io:format("延迟进桌子~n"),
                lists:foreach(
                    fun(DeskUserId) ->
                        LeftUserId = sort_helper:get_left_user(DeskUserId, UsersOnDesk),
                        LeftUserOnline = user_helper:get_user_online(LeftUserId),
                        LeftUserGender = user_helper:get_user_gender(LeftUserId),

                        RightUserId = sort_helper:get_right_user(DeskUserId, UsersOnDesk),
                        RightUserOnline = user_helper:get_user_online(RightUserId),
                        RightUserGender = user_helper:get_user_gender(RightUserId),

                        JsonBin = user_sit_on_desk_encoder:encode(DeskId, 0,
                            LeftUserId, LeftUserOnline, LeftUserGender,
                            RightUserId, RightUserOnline, RightUserGender),
                        UserPid = user_map:get_pid_by_userid(DeskUserId),
                        tcp_send:send_data(UserPid, Cmd, JsonBin)
                    end,
                    UsersOnDesk
                )
            end
    end.