-module(redis_worker).

-behaviour(gen_server).
-behaviour(poolboy_worker).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(conn_record, {conn}).

start_link([Args]) ->
    gen_server:start_link(?MODULE, [Args], []).

init([Args]) ->
    process_flag(trap_exit, true),

    Ip = proplists:get_value(ip, Args),
    Port = proplists:get_value(port, Args),

    case eredis:start_link(Ip, Port) of
        {ok, Conn} ->
            ConnRecord = #conn_record{conn = Conn},
            io:format("redis working thread init ~p,~p~n", [self(), ConnRecord]),
            {ok, ConnRecord};
        {error, _Reason} ->
            ConnRecord = #conn_record{conn = nil},
            io:format("redis working thread init fail ~p,~p~n", [self(), ConnRecord]),
            {ok, ConnRecord}
    end.

%redis的一些查询命令封装
handle_call({single_query, Cmd}, _From, #conn_record{conn = Conn} = State) ->
    Result = eredis:q(Conn, Cmd),
    {reply, Result, State};

handle_call({pipeline_query, CmdList}, _From, #conn_record{conn = Conn} = State) ->
    Result = eredis:qp(Conn, CmdList),
    {reply, Result, State};

handle_call({transcation_query, CmdList}, _From, #conn_record{conn = Conn} = State) ->
    {ok, <<"OK">>} = eredis:q(Conn, ["MULTI"]),
    lists:foreach(
        fun(Cmd) ->
            {ok, <<"QUEUED">>} = eredis:q(Conn, Cmd)
        end,
        CmdList),
    Result = eredis:q(Conn, ["EXEC"]),
    {reply, Result, State};

handle_call(_Request, _From, State) ->
    {reply, _Reply = ok, State}.

handle_cast(stop, State) ->
    {stop, normal, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, #conn_record{conn = Conn} = State) ->
    eredis:stop(Conn),
    io:format("terminate ~p,~p,~p~n", [_Reason, State, self()]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.