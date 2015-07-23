-module(user_cards_prompt_handler).

-include_lib("doudizhu_robot/src/const/socket_const.hrl").
-export([handle_response/3]).

handle_response(Pid, _Cmd, InfoBin) ->
    {OptionalCards} = user_cards_prompt_decoder:decode(InfoBin),

    Cards = (
            case length(OptionalCards) of
                0 ->
                    [];
                _ -> lists:nth(1, OptionalCards)
            end
    ),

    JsonBin = user_chu_pai_encoder:encode(Cards),
    tcp_send:send_data(Pid, ?CMD_DESK_CHU_PAI, JsonBin),
    ok.