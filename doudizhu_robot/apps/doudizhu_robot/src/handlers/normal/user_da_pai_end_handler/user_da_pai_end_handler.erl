-module(user_da_pai_end_handler).

-include_lib("doudizhu_robot/src/const/socket_const.hrl").
-export([handle_response/3]).
-export([handle_delay_cast/1]).

handle_response(Pid, _Cmd, _InfoBin) ->
    Num = random_generator:random_number() rem 3 + 1,
    delay_helper:delay_cast(Num * 1000, {?MODULE, handle_delay_cast}, {Pid}).


handle_delay_cast({Pid}) ->
    JsonBin = user_ready_to_play_encoder:encode(),
    tcp_send:send_data(Pid, ?CMD_USER_READY_TO_PLAY, JsonBin),
    ok.