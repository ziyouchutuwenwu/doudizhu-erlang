-module(query_desk_jiao_di_zhu_finish_notification).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([notify/1]).

notify(UserId) ->
    DeskId = user_helper:get_user_deskid(UserId),
    DeskDiZhuId = desk_helper:get_desk_dizhu(DeskId),

    JsonBin = query_desk_jiao_di_zhu_finish_encoder:encode(DeskDiZhuId),
    UserPid = user_map:get_pid_by_userid(UserId),
    tcp_send:send_data(UserPid, ?CMD_QUERY_DESK_JIAO_DI_ZHU_FINISH, JsonBin).