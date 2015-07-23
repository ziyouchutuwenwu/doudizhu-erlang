-module(port_worker).

-behaviour(gen_server).
-behaviour(poolboy_worker).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state_record, {port, cmd}).

start_link([Args]) ->
    gen_server:start_link(?MODULE, [Args], []).

init([Args]) ->
    process_flag(trap_exit, true),

    io:format("~p~n", [Args]),
    Cmd = proplists:get_value(cmd, Args),
    Port = open_port({spawn, Cmd}, [{packet, 4}, nouse_stdio, exit_status, binary]),

    StateRecord = #state_record{port = Port, cmd = Cmd},
    io:format("port working thread init ~p,~p~n", [self(), StateRecord]),
    {ok, StateRecord}.

handle_call({port_call, Message}, _From, #state_record{port = Port} = State) ->
    port_command(Port, term_to_binary(Message)),
    Result = (
            receive
                {Port, {data, In}} ->
                    Data = binary_to_term(In),
                    Data
            end
    ),
    {reply, _Reply = Result, State};

handle_call(_Request, _From, State) ->
    {reply, _Reply = ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({'EXIT', _Pid, Reason}, State) ->
    io:format("exit reason ~p~n", [Reason]),
    case Reason of
        user ->
            io:format("exit reason user~n"),
            {stop, user, State};
        _ ->
            {noreply, State}
    end;
handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, #state_record{port = Port} = State) ->
    port_close(Port),
    io:format("terminate ~p,~p,~p~n", [_Reason, State, self()]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.