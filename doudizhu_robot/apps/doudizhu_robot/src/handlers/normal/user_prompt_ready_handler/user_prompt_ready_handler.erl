-module(user_prompt_ready_handler).

-include_lib("doudizhu_robot/src/const/socket_const.hrl").
-export([handle_response/3]).

handle_response(Pid, _Cmd, _InfoBin) ->
    JsonBin = user_ready_to_play_encoder:encode(),
    tcp_send:send_data(Pid, ?CMD_USER_READY_TO_PLAY, JsonBin),
    ok.