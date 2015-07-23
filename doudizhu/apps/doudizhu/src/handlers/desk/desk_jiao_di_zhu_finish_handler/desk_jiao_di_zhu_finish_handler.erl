-module(desk_jiao_di_zhu_finish_handler).

-include_lib("doudizhu/src/const/playing_status_const.hrl").
-export([handle_request/3]).

handle_request(DeskId, Cmd, _Params) ->
    desk_helper:set_desk_playing_status(DeskId, ?STATUS_JIAO_DI_ZHU_FINISH),

    DeskDiZhuId = desk_helper:get_desk_dizhu(DeskId),
    UserIdList = desk_helper:get_desk_all_users(DeskId),

    desk_helper:set_desk_current_userid(DeskId, DeskDiZhuId),

    lists:foreach(
        fun(DeskUserId) ->
            JsonBin = desk_jiao_di_zhu_finish_encoder:encode(DeskDiZhuId),
            UserPid = user_map:get_pid_by_userid(DeskUserId),
            tcp_send:send_data(UserPid, Cmd, JsonBin)
        end,
        UserIdList
    ).