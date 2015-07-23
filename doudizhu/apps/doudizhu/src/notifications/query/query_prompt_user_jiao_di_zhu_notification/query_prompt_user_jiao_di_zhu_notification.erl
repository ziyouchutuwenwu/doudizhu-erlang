-module(query_prompt_user_jiao_di_zhu_notification).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([notify/1]).

notify(UserId) ->
    DeskId = user_helper:get_user_deskid(UserId),
    UserIdPromptToJiaoDiZhu = desk_helper:get_desk_current_userid(DeskId),

    JsonBin = query_prompt_user_jiao_di_zhu_encoder:encode(UserIdPromptToJiaoDiZhu),
    UserPid = user_map:get_pid_by_userid(UserId),
    tcp_send:send_data(UserPid, ?CMD_QUERY_DESK_PROMPT_USER_JIAO_DI_ZHU, JsonBin).