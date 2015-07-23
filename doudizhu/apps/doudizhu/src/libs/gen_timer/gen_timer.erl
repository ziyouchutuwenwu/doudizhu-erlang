-module(gen_timer).

-behaviour(gen_server).
-record(timer_record, {timer_ref, duration, args, mod, callback}).

-export([start_link/3]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link(Duration, {Mod, CallBack}, Args) ->
    gen_server:start_link(?MODULE, [Duration, {Mod, CallBack}, Args], []).

init([Duration, {Mod, CallBack}, Args]) ->
    process_flag(trap_exit, true),

    TimeInterval = round(Duration),
    TimerRef = erlang:send_after(TimeInterval, self(), timer_msg),
    TimerRecord = #timer_record{timer_ref = TimerRef, duration = TimeInterval, args = Args, mod = Mod, callback = CallBack},
    {ok, TimerRecord}.

handle_call({timer_elapse}, _From, #timer_record{timer_ref = TimerRef} = State) ->
    Elapse = erlang:read_timer(TimerRef),
    {reply, Elapse, State};

handle_call(Msg, _From, State) ->
    {reply, {ok, Msg}, State}.

handle_cast({timer_restart}, #timer_record{duration = TimeInterval, timer_ref = OldTimerRef} = TimerRecord) ->
    erlang:cancel_timer(OldTimerRef),
    NewTimerRef = erlang:send_after(TimeInterval, self(), timer_msg),

    NewTimerRecord = TimerRecord#timer_record{timer_ref = NewTimerRef},
    {noreply, NewTimerRecord};

handle_cast(stop, State) ->
    {stop, normal, State};

handle_cast(_Request, State) ->
    {noreply, normal, State}.

handle_info(timer_msg, #timer_record{args = Args, mod = Mod, callback = CallBack, duration = TimeInterval, timer_ref = OldTimerRef} = TimerRecord) ->
    Mod:CallBack(Args),

    erlang:cancel_timer(OldTimerRef),
    NewTimerRef = erlang:send_after(TimeInterval, self(), timer_msg),

    NewTimerRecord = TimerRecord#timer_record{timer_ref = NewTimerRef},
    {noreply, NewTimerRecord};

handle_info(_Info, StateData) ->
    {noreply, StateData}.

terminate(_Reason, #timer_record{timer_ref = TimerRef} = _TimerRecord) ->
    erlang:cancel_timer(TimerRef),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.