-module(desk_timer).

-include_lib("doudizhu/src/const/timer_const.hrl").
-export([init_timers/0, start_timer/1, stop_timer/1, restart_timer/1]).

init_timers() ->
    gen_timer_sup:start_link().

start_timer(DeskId) ->
    case gen_timer_sup:start_child(?TIMER_DURATION, {desk_timer_callback, on_desk_timer}, {DeskId}) of
        {ok, Pid} ->
            desk_map:set(DeskId, Pid);
        _ ->
            ok
    end.

stop_timer(DeskId) ->
    Pid = desk_map:get_pid_by_deskid(DeskId),
    case erlang:is_pid(Pid) of
        true ->
            gen_server:cast(Pid, stop);
        _ ->
            ignore
    end,
    desk_map:remove_by_deskid(DeskId).

restart_timer(DeskId) ->
    Pid = desk_map:get_pid_by_deskid(DeskId),
    case erlang:is_pid(Pid) of
        true ->
            gen_server:cast(Pid, {timer_restart});
        _ ->
            ignore
    end.