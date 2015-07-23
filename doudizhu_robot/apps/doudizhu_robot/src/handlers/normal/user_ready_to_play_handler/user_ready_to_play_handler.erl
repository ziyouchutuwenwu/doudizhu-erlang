-module(user_ready_to_play_handler).

-include_lib("doudizhu_robot/src/const/socket_const.hrl").
-export([handle_response/3]).

handle_response(_Pid, _Cmd, InfoBin) ->
    {_ReadyUserId} = user_ready_to_play_decoder:decode(InfoBin),
    ok.