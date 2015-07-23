-module(user_prompt_jiao_di_zhu_handler).

-include_lib("doudizhu_robot/src/const/socket_const.hrl").
-export([handle_response/3]).
-export([delay_process/1]).

handle_response(Pid, Cmd, InfoBin) ->
    Num = random_generator:random_number() rem 15 + 1,
    delay_helper:delay_cast(Num * 1000, {?MODULE, delay_process}, {Pid, Cmd, InfoBin}),
    ok.

delay_process({Pid, _Cmd, InfoBin}) ->
    {CanJiaoDiZhuUserId} = user_prompt_jiao_di_zhu_decoder:decode(InfoBin),
    SelfUserId = user_map:get_userid_by_pid(Pid),

    case string:equal(SelfUserId, CanJiaoDiZhuUserId) of
        true ->
            JiaoDiZhu = random_generator:random_number() rem 2,
            JsonBin = user_jiao_di_zhu_encoder:encode(JiaoDiZhu),
            tcp_send:send_data(Pid, ?CMD_DESK_JIAO_DI_ZHU, JsonBin);
        _ ->
            ignore
    end,
    ok.