-module(desk_prompt_user_jiao_di_zhu_handler).

-include_lib("doudizhu/src/const/playing_status_const.hrl").
-export([handle_request/3]).

handle_request(DeskId, Cmd, _Params) ->
    desk_helper:set_desk_playing_status(DeskId, ?STATUS_PROMPT_USER_JIAO_DI_ZHU),

    UserIdList = desk_helper:get_desk_all_users(DeskId),
    sort_helper:random_set_userlist_play_index(UserIdList),
    SortedUserIdList = sort_helper:get_userlist_by_play_index(UserIdList),
    [FirstCanJiaoDiZhuUserId | _] = SortedUserIdList,

%%     清空上一次叫地主的信息
    lists:foreach(
        fun(DeskUserId) ->
            user_helper:remove_user_has_jiao_di_zhu(DeskUserId)
        end,
        UserIdList
    ),
    desk_helper:remove_desk_jiao_di_zhu_request_index(DeskId),
    desk_helper:set_desk_current_userid(DeskId, FirstCanJiaoDiZhuUserId),

%%     通知所有人，谁可以开始叫地主了
    lists:foreach(
        fun(DeskUserId) ->
            JsonBin = desk_prompt_user_jiao_di_zhu_encoder:encode(FirstCanJiaoDiZhuUserId),
            UserPid = user_map:get_pid_by_userid(DeskUserId),
            tcp_send:send_data(UserPid, Cmd, JsonBin)
        end,
        UserIdList
    ).