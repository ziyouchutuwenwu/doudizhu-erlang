-module(node_caller_worker).
-behaviour(gen_server).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state_record, {port_node_prefix, nodes}).

start_link([Args]) ->
    gen_server:start_link(?MODULE, [Args], []).

init([Args]) ->
    process_flag(trap_exit, true),

    PortNodePrefix = proplists:get_value(node_prefix, Args),
    Nodes = node_name_helper:get_port_worker_nodes(PortNodePrefix),

    net_kernel:monitor_nodes(true),
    {ok, #state_record{port_node_prefix = PortNodePrefix, nodes = Nodes}}.

handle_call({node_call, Module, Function, Args}, _From, #state_record{nodes = Nodes} = State) ->
    Result = (
            if
                length(Nodes) > 0 ->
                    RadomIndex = random:uniform(9) rem length(Nodes) + 1,
                    Node = lists:nth(RadomIndex, Nodes),
%%                 apply模式调用，需要在参数上加[]
                    RpcResult = rpc:call(Node, Module, Function, [Args]),
                    RpcResult;
                true ->
                    RpcResult = "no node to call",
                    RpcResult
            end
    ),
    {reply, Result, State};

handle_call(_Request, _From, State) ->
    {reply, _Reply = ok, State}.

handle_cast(stop, State) ->
    {stop, normal, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({nodeup, _Node}, #state_record{port_node_prefix = PortNodePrefix, nodes = _Nodes} = State) ->
    io:format("nodeup ~p~n", [_Node]),
    NewNodes = node_name_helper:get_port_worker_nodes(PortNodePrefix),
    NewState = State#state_record{nodes = NewNodes},
    io:format("nodeup NewState ~p~n", [NewState]),
    {noreply, NewState};

handle_info({nodedown, _Node}, #state_record{port_node_prefix = PortNodePrefix, nodes = _Nodes} = State) ->
    io:format("nodedown ~p~n", [_Node]),
    NewNodes = node_name_helper:get_port_worker_nodes(PortNodePrefix),
    NewState = State#state_record{nodes = NewNodes},
    io:format("nodedown NewState ~p~n", [NewState]),
    {noreply, NewState};

handle_info(Info, State) ->
    io:format("Info ~p,~p~n", [Info, State]),
    {noreply, State}.

terminate(_Reason, _State) ->
    net_kernel:monitor_nodes(false),
    io:format("terminate ~p,~p,~p~n", [_Reason, _State, self()]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.