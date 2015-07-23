-module(user_guest_login_handler).

-include_lib("doudizhu_robot/src/const/socket_const.hrl").
-export([handle_response/3]).

handle_response(Pid, _Cmd, InfoBin) ->
    {UserId, _Gender, _Error} = user_guest_login_decoder:decode(InfoBin),

    case length(UserId) of
        0 ->
            ignore;
        _ ->
            user_map:set(Pid, UserId),
            user_storage:init(UserId),

%%             用户登陆成功，检查断线重连
            JsonBin = user_check_resume_play_encoder:encode(),
            tcp_send:send_data(Pid, ?CMD_USER_CHECK_RESUME_PLAY, JsonBin)
    end,
    ok.