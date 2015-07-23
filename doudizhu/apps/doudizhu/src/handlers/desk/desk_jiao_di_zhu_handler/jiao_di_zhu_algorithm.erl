-module(jiao_di_zhu_algorithm).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([do_desk_jiao_di_zhu/4]).

%% 先设置(before action)
%% 一共4次，当前是第几次
%% 当前叫了地主的人个数
%%
%% 后设置(after action)
%% 之前最后一次叫地主的人是谁，如果为空，则是第一次叫地主
%% 当前请求的用户id（叫不叫都可以）
%%
%% 桌子的地主id
%%
%%
%% 第三轮叫地主以后的逻辑可能比较复杂
%% 通过当前叫了地主的人数判断 ＝＝0判断，表示没人叫地主
%% if ＝＝ 1，最后叫地主的人是地主（结束叫地主）
%% 大于1的话，给下一个用户（第一个用户）发消息叫地主
%%
%% 第四轮
%% 直接把最后一次叫地主的人作为最终地主，通知别人

do_desk_jiao_di_zhu(DeskId, Cmd, UserId, JiaoDiZhu) ->

%%     before action，获取本轮的数据
    SecondPreviousUserId = desk_helper:get_desk_second_previous_jiao_di_zhu_userid(DeskId),
    SecondPreviousUserJiaoDiZhu = user_helper:get_user_has_jiao_di_zhu(SecondPreviousUserId),
    IsSecondPreviousUserFirstJiaoDiZhu = user_helper:get_user_is_first_jiao_di_zhu(SecondPreviousUserId),

    SavedFirstPreviousUserId = desk_helper:get_desk_first_previous_jiao_di_zhu_userid(DeskId),
    FirstPreviousUserId = UserId,
    FirstPreviousUserJiaoDiZhu = JiaoDiZhu,
    IsFirstPreviousUserFirstJiaoDiZhu = (
            case length(SavedFirstPreviousUserId) of
                0 ->
                    1;
                _ ->
                    0
            end
    ),

    IsNextUserFirstJiaoDiZhu = (
            if
                (IsFirstPreviousUserFirstJiaoDiZhu =:= 1) andalso (FirstPreviousUserJiaoDiZhu =/= 1) ->
                    1;
                true ->
                    0
            end
    ),
    case JiaoDiZhu of
        1 ->
            desk_helper:inc_desk_jiao_di_zhu_users_count(DeskId),
            desk_helper:set_desk_last_jiao_di_zhu_userid(DeskId, UserId);
        _ ->
            ok
    end,
    desk_helper:inc_desk_jiao_di_zhu_request_index(DeskId),

    JiaoDiZhuRequestIndex = desk_helper:get_desk_jiao_di_zhu_request_index(DeskId),

    UserIdList = desk_helper:get_desk_all_users(DeskId),
    SortedUserIdList = sort_helper:get_userlist_by_play_index(UserIdList),
    NextUserId = sort_helper:loop_get_next_userid(UserId, SortedUserIdList),

    DeskJiaoDiZhuUsersCount = desk_helper:get_desk_jiao_di_zhu_users_count(DeskId),

%%     after action，用来给下一轮做准备
    desk_helper:set_desk_current_userid(DeskId, NextUserId),

    desk_helper:set_desk_second_previous_jiao_di_zhu_userid(DeskId, FirstPreviousUserId),
    user_helper:set_user_has_jiao_di_zhu(FirstPreviousUserId, FirstPreviousUserJiaoDiZhu),
    user_helper:set_user_is_first_jiao_di_zhu(FirstPreviousUserId, IsFirstPreviousUserFirstJiaoDiZhu),

    case FirstPreviousUserJiaoDiZhu of
        1 ->
            desk_helper:set_desk_first_previous_jiao_di_zhu_userid(DeskId, UserId);
        _ ->
            ok
    end,

%%     小于三次，不管，直接通知别人叫地主
    if
        JiaoDiZhuRequestIndex < 3 ->
%%             用来给断线重连准备的
            user_helper:set_user_has_jiao_di_zhu(UserId, FirstPreviousUserJiaoDiZhu),
            lists:foreach(
                fun(DeskUserId) ->
                    JsonBin = desk_jiao_di_zhu_encoder:encode(
                        SecondPreviousUserId, SecondPreviousUserJiaoDiZhu, IsSecondPreviousUserFirstJiaoDiZhu,
                        FirstPreviousUserId, FirstPreviousUserJiaoDiZhu, IsFirstPreviousUserFirstJiaoDiZhu,
                        NextUserId, IsNextUserFirstJiaoDiZhu),
                    UserPid = user_map:get_pid_by_userid(DeskUserId),
                    tcp_send:send_data(UserPid, Cmd, JsonBin)
                end,
                UserIdList
            );
        JiaoDiZhuRequestIndex == 3 ->
            if
                DeskJiaoDiZhuUsersCount == 0 ->
%%                     重新叫地主
                    reset_helper:reset_desk_jiao_di_zhu_status(DeskId),
                    handler_dispatcher:dispatch_desk_request(DeskId, ?CMD_DESK_FA_PAI, []),
                    handler_dispatcher:dispatch_desk_request(DeskId, ?CMD_DESK_PROMPT_USER_JIAO_DI_ZHU, []);
                DeskJiaoDiZhuUsersCount == 1 ->
%%                     先告诉所有人叫地主的信息
                    lists:foreach(
                        fun(DeskUserId) ->
                            JsonBin = desk_jiao_di_zhu_encoder:encode(
                                SecondPreviousUserId, SecondPreviousUserJiaoDiZhu, IsSecondPreviousUserFirstJiaoDiZhu,
                                FirstPreviousUserId, FirstPreviousUserJiaoDiZhu, IsFirstPreviousUserFirstJiaoDiZhu,
                                "", 0),
                            UserPid = user_map:get_pid_by_userid(DeskUserId),
                            tcp_send:send_data(UserPid, Cmd, JsonBin)
                        end,
                        UserIdList
                    ),
%%                     结束叫地主
                    LastDiZhuUserId = desk_helper:get_desk_last_jiao_di_zhu_userid(DeskId),
                    desk_helper:set_desk_dizhu(DeskId, LastDiZhuUserId),
                    handler_dispatcher:dispatch_desk_request(DeskId, ?CMD_DESK_JIAO_DI_ZHU_FINISH, []),
                    handler_dispatcher:dispatch_desk_request(DeskId, ?CMD_DESK_FA_DI_PAI, []);
                DeskJiaoDiZhuUsersCount > 1 ->
%%                     继续叫地主
                    user_helper:set_user_has_jiao_di_zhu(UserId, FirstPreviousUserJiaoDiZhu),
                    lists:foreach(
                        fun(DeskUserId) ->
                            JsonBin = desk_jiao_di_zhu_encoder:encode(
                                SecondPreviousUserId, SecondPreviousUserJiaoDiZhu, IsSecondPreviousUserFirstJiaoDiZhu,
                                FirstPreviousUserId, FirstPreviousUserJiaoDiZhu, IsFirstPreviousUserFirstJiaoDiZhu,
                                NextUserId, IsNextUserFirstJiaoDiZhu),
                            UserPid = user_map:get_pid_by_userid(DeskUserId),
                            tcp_send:send_data(UserPid, Cmd, JsonBin)
                        end,
                        UserIdList
                    );
                true ->
                    ok
            end,
            ok;
        JiaoDiZhuRequestIndex == 4 ->
%%                     先告诉所有人叫地主的信息
            lists:foreach(
                fun(DeskUserId) ->
                    JsonBin = desk_jiao_di_zhu_encoder:encode(
                        SecondPreviousUserId, SecondPreviousUserJiaoDiZhu, IsSecondPreviousUserFirstJiaoDiZhu,
                        FirstPreviousUserId, FirstPreviousUserJiaoDiZhu, IsFirstPreviousUserFirstJiaoDiZhu,
                        "", 0),
                    UserPid = user_map:get_pid_by_userid(DeskUserId),
                    tcp_send:send_data(UserPid, Cmd, JsonBin)
                end,
                UserIdList
            ),
%%                     结束叫地主
            LastDiZhuUserId = desk_helper:get_desk_last_jiao_di_zhu_userid(DeskId),
            desk_helper:set_desk_dizhu(DeskId, LastDiZhuUserId),
            handler_dispatcher:dispatch_desk_request(DeskId, ?CMD_DESK_JIAO_DI_ZHU_FINISH, []),
            handler_dispatcher:dispatch_desk_request(DeskId, ?CMD_DESK_FA_DI_PAI, []);
        true ->
            ok
    end,
    ok.