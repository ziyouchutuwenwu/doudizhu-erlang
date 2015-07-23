-module(user_sit_on_desk_handler).

-include_lib("doudizhu_robot/src/const/socket_const.hrl").
-export([handle_response/3]).

handle_response(_Pid, _Cmd, InfoBin) ->
    {_DeskId} = user_sit_on_desk_decoder:decode(InfoBin),
    ok.