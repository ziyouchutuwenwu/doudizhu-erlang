-module(user_check_resume_play_handler).

-include_lib("doudizhu_robot/src/const/socket_const.hrl").
-export([handle_response/3]).

handle_response(Pid, _Cmd, InfoBin) ->
    {ShouldResumePlay} = user_check_resume_play_decoder:decode(InfoBin),

%% 如果需要断线重连，则请求断线重连的数据
%% 否则进入房间
    case ShouldResumePlay of
        1 ->
            JsonBin = user_resume_play_encoder:encode(),
            tcp_send:send_data(Pid, ?CMD_USER_RESUME_PLAY, JsonBin);
        _ ->
            JsonBin = user_enter_room_encoder:encode(),
            tcp_send:send_data(Pid, ?CMD_USER_ENTER_ROOM, JsonBin)
    end,
    ok.