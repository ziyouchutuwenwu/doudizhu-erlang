-module(user_jiao_di_zhu_finish_handler).

-include_lib("doudizhu_robot/src/const/socket_const.hrl").
-export([handle_response/3]).
-export([delay_process/1]).

handle_response(Pid, Cmd, InfoBin) ->
    Num = random_generator:random_number() rem 15 + 1,
    delay_helper:delay_cast(Num * 1000, {?MODULE, delay_process}, {Pid, Cmd, InfoBin}),
    ok.

delay_process({Pid, _Cmd, InfoBin}) ->
    {DeskDiZhuId} = user_jiao_di_zhu_finish_decoder:decode(InfoBin),
    SelfUserId = user_map:get_userid_by_pid(Pid),

    case string:equal(SelfUserId, DeskDiZhuId) of
        true ->
%%             问服务器我有啥牌能出
            JsonBin = user_cards_prompt_encoder:encode(),
            tcp_send:send_data(Pid, ?CMD_DESK_CRADS_PROMPT, JsonBin);
        _ ->
            ignore
    end,
    ok.