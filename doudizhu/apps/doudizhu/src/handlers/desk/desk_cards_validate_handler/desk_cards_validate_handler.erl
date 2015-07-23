-module(desk_cards_validate_handler).

-include_lib("doudizhu/src/const/socket_const.hrl").
-export([handle_request/3]).

handle_request(_DeskId, _Cmd, Params) ->
    {DeskUserId, IsCardValid} = Params,

    JsonBin = desk_cards_validate_encoder:encode(IsCardValid),
    UserPid = user_map:get_pid_by_userid(DeskUserId),
    tcp_send:send_data(UserPid, ?CMD_DESK_CARDS_VALIDATE, JsonBin),

    ok.