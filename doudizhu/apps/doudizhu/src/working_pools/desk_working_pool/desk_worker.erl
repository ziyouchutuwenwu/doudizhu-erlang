-module(desk_worker).

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
    io:format("desk working thread init ~p,~p~n", [self(), ArgRecord]),
    {ok, ArgRecord}.

handle_call(_Request, _From, State) ->
    {reply, _Reply = ok, State}.

handle_cast({desk, DeskId, Cmd, Params}, State) ->
    handler_dispatcher:dispatch_desk_request(DeskId, Cmd, Params),
    {noreply, State};

handle_cast(stop, State) ->
    {stop, normal, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    io:format("terminate ~p,~p,~p~n", [_Reason, State, self()]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.