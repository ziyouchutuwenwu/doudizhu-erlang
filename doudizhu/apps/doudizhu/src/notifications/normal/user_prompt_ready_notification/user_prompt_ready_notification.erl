-module(user_prompt_ready_notification).

-export([send_notitication/1]).
-include_lib("doudizhu/src/const/socket_const.hrl").

%% 当用户在桌子并且不是ready状态，就发
send_notitication(UserId) ->
    case length(user_helper:get_user_deskid(UserId)) of
        0 ->
            ignore;
        _ ->
            case user_helper:get_user_ready(UserId) of
                0 ->
                    JsonBin = user_prompt_ready_encoder:encode(),
                    UserPid = user_map:get_pid_by_userid(UserId),
                    tcp_send:send_data(UserPid, ?CMD_USER_PROMPT_READY, JsonBin);
                _ ->
                    ignore
            end
    end.