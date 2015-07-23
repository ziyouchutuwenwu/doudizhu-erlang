-module(timer_test).

-compile(export_all).

callback(Args) ->
    io:format("callback ~p~n", [Args]).

init() ->
    gen_timer_sup:start_link().

start() ->
    {ok, Pid} = gen_timer_sup:start_child(20 * 1000, {timer_test, callback}, {arg1, arg2}),
    io:format("timer_test start~n"),
    Pid.

get_elapse(Pid) ->
    gen_server:call(Pid, {timer_elapse}).

stop(Pid) ->
    gen_server:cast(Pid, stop).

restart(Pid) ->
    gen_server:cast(Pid, {timer_restart}).