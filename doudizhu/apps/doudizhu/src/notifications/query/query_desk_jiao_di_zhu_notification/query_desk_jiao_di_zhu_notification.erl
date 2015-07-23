-module(query_desk_jiao_di_zhu_notification).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([notify/1]).

notify(UserId) ->
    DeskId = user_helper:get_user_deskid(UserId),
    CurrentUserId = desk_helper:get_desk_current_userid(DeskId),

    UserIdList = desk_helper:get_desk_all_users(DeskId),
    SortedUserIdList = sort_helper:get_userlist_by_play_index(UserIdList),

    FirstPreviousUserId = sort_helper:loop_get_previous_userid(CurrentUserId, SortedUserIdList),
    FirstPreviousUserJiaoDiZhu = user_helper:get_user_has_jiao_di_zhu(FirstPreviousUserId),
    IsFirstPreviousUserFirstJiaoDiZhu = (
            case length(desk_helper:get_desk_first_previous_jiao_di_zhu_userid(DeskId)) of
                0 ->
                    1;
                _ ->
                    0
            end
    ),

%%     用desk_helper:get_desk_second_previous_jiao_di_zhu_userid(DeskId)的话，获取出来的是不正确的
    SecondPreviousUserId = sort_helper:loop_get_previous_userid(FirstPreviousUserId, UserIdList),
    SecondPreviousUserJiaoDiZhu = user_helper:get_user_has_jiao_di_zhu(SecondPreviousUserId),
    IsSecondPreviousUserFirstJiaoDiZhu = user_helper:get_user_is_first_jiao_di_zhu(SecondPreviousUserId),

    IsNextUserFirstJiaoDiZhu = (
            if
                (IsFirstPreviousUserFirstJiaoDiZhu =:= 1) andalso (FirstPreviousUserJiaoDiZhu =/= 1) ->
                    1;
                true ->
                    0
            end
    ),

    JsonBin = query_desk_jiao_di_zhu_encoder:encode(
        SecondPreviousUserId, SecondPreviousUserJiaoDiZhu, IsSecondPreviousUserFirstJiaoDiZhu,
        FirstPreviousUserId, FirstPreviousUserJiaoDiZhu, IsFirstPreviousUserFirstJiaoDiZhu,
        CurrentUserId, IsNextUserFirstJiaoDiZhu),
    UserPid = user_map:get_pid_by_userid(UserId),
    tcp_send:send_data(UserPid, ?CMD_QUERY_DESK_JIAO_DI_ZHU, JsonBin).