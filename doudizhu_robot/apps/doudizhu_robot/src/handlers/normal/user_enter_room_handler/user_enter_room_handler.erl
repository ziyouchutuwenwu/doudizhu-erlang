-module(user_enter_room_handler).

-include_lib("doudizhu_robot/src/const/socket_const.hrl").
-export([handle_response/3]).

handle_response(Pid, _Cmd, InfoBin) ->
    {RoomIds} = user_enter_room_decoder:decode(InfoBin),
    RoomId = lists:nth(1, RoomIds),

    JsonBin = user_sit_on_desk_encoder:encode(RoomId),
    tcp_send:send_data(Pid, ?CMD_USER_SIT_ON_DESK, JsonBin),
    ok.