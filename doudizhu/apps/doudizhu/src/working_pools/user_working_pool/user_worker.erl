-module(user_worker).

-behaviour(gen_server).
-behaviour(poolboy_worker).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(arg_record, {arg}).

start_link([Args]) ->
    gen_server:start_link(?MODULE, [Args], []).

init([Args]) ->
    process_flag(trap_exit, true),

    ArgRecord = #arg_record{arg = Args},
    io:format("user working thread init ~p,~p~n", [self(), ArgRecord]),
    {ok, ArgRecord}.

handle_call(_Request, _From, State) ->
    {reply, _Reply = ok, State}.

handle_cast({delay, Duration, Module, CallBack, Args}, State) ->
    erlang:send_after(Duration, self(), {delay, Module, CallBack, Args}),
    {noreply, State};

handle_cast({socket, Pid, Cmd, InfoBin}, State) ->
    handler_dispatcher:dispatch_user_request(Pid, Cmd, InfoBin),
    {noreply, State};

handle_cast(stop, State) ->
    {stop, normal, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({delay, Module, CallBack, Args}, State) ->
    Module:CallBack(Args),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    io:format("terminate ~p,~p,~p~n", [_Reason, State, self()]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.