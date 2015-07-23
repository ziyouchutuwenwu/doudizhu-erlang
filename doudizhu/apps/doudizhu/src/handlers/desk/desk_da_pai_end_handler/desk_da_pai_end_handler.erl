-module(desk_da_pai_end_handler).

-include_lib("doudizhu/src/const/playing_status_const.hrl").
-include_lib("doudizhu/src/const/socket_const.hrl").
-export([handle_request/3]).

handle_request(DeskId, Cmd, Params) ->
    {UserId} = Params,

    UserIdList = desk_helper:get_desk_all_users(DeskId),
    SortedUserIdList = sort_helper:get_userlist_by_play_index(UserIdList),

%%     获取用户的id，牌等属性
    UserId1 = UserId,
    LeftUserId1 = sort_helper:get_left_user(UserId1, SortedUserIdList),
    RightUserId1 = sort_helper:get_right_user(UserId1, SortedUserIdList),
    LeftUserId1Cards = user_helper:get_cards_in_user_hand(LeftUserId1),
    RightUserId1Cards = user_helper:get_cards_in_user_hand(RightUserId1),

    UserId2 = RightUserId1,
    LeftUserId2 = sort_helper:get_left_user(UserId2, SortedUserIdList),
    RightUserId2 = sort_helper:get_right_user(UserId2, SortedUserIdList),
    LeftUserId2Cards = user_helper:get_cards_in_user_hand(LeftUserId2),
    RightUserId2Cards = user_helper:get_cards_in_user_hand(RightUserId2),

    UserId3 = RightUserId2,
    LeftUserId3 = sort_helper:get_left_user(UserId3, SortedUserIdList),
    RightUserId3 = sort_helper:get_right_user(UserId3, SortedUserIdList),
    LeftUserId3Cards = user_helper:get_cards_in_user_hand(LeftUserId3),
    RightUserId3Cards = user_helper:get_cards_in_user_hand(RightUserId3),

%%     停止桌子动作，清除桌子数据
    desk_helper:set_desk_playing_status(DeskId, ?STATUS_NOT_PLAYING),
    reset_helper:reset_desk_play_status(DeskId),
    desk_timer:stop_timer(DeskId),

    lists:foreach(
        fun(DeskUserId) ->
            IsWin = (
                    case string:equal(DeskUserId, UserId) of
                        true ->
                            1;
                        _ ->
                            0
                    end
            ),
            LeftUserId = (
                    case DeskUserId of
                        UserId1 ->
                            LeftUserId1;
                        UserId2 ->
                            LeftUserId2;
                        UserId3 ->
                            LeftUserId3;
                        _ ->
                            ""
                    end
            ),
            LeftUserIdCards = (
                    case DeskUserId of
                        UserId1 ->
                            LeftUserId1Cards;
                        UserId2 ->
                            LeftUserId2Cards;
                        UserId3 ->
                            LeftUserId3Cards;
                        _ ->
                            []
                    end
            ),
            RightUserId = (
                    case DeskUserId of
                        UserId1 ->
                            RightUserId1;
                        UserId2 ->
                            RightUserId2;
                        UserId3 ->
                            RightUserId3;
                        _ ->
                            ""
                    end
            ),
            RightUserIdCards = (
                    case DeskUserId of
                        UserId1 ->
                            RightUserId1Cards;
                        UserId2 ->
                            RightUserId2Cards;
                        UserId3 ->
                            RightUserId3Cards;
                        _ ->
                            []
                    end
            ),
            JsonBin = desk_da_pai_end_encoder:encode(LeftUserId, LeftUserIdCards, RightUserId, RightUserIdCards, IsWin),
            UserPid = user_map:get_pid_by_userid(DeskUserId),
            tcp_send:send_data(UserPid, Cmd, JsonBin)
        end,
        UserIdList
    ),

%%     不在线的用户离开桌子
    lists:foreach(
        fun(DeskUserId) ->
            case user_helper:get_user_online(DeskUserId) of
                0 ->
                    user_leave_desk_handler:do_user_leave_desk(?CMD_USER_LEAVE_DESK, DeskUserId);
                _ ->
                    ignore
            end
        end,
        UserIdList
    ).