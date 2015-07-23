-module(user_enter_room_handler).

-export([handle_request/3]).

handle_request(Pid, Cmd, _InfoBin) ->
    RoomList = room_helper:get_roomids_by_level(1),

    JsonBin = user_enter_room_encoder:encode(RoomList),
    tcp_send:send_data(Pid, Cmd, JsonBin),
    ok.