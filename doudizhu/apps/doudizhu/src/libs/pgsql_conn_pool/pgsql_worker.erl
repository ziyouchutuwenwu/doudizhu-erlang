-module(pgsql_worker).

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
    Username = proplists:get_value(username, Args),
    Password = proplists:get_value(password, Args),
    Database = proplists:get_value(database, Args),

    case pgsql:connect(Ip, Username, Password, [{database, Database}]) of
        {ok, Conn} ->
            ConnRecord = #conn_record{conn = Conn},
            io:format("pgsql working thread init ~p,~p~n", [self(), ConnRecord]),
            {ok, ConnRecord};
        {error, _Reason} ->
            ConnRecord = #conn_record{conn = nil},
            io:format("pgsql working thread init fail ~p,~p~n", [self(), ConnRecord]),
            {ok, ConnRecord}
    end.


%pgsql的一些查询命令封装
handle_call({get_parameter, Name}, _From, #conn_record{conn = Conn} = State) ->
    {reply, pgsql:get_parameter(Conn, Name), State};

handle_call({squery, Sql}, _From, #conn_record{conn = Conn} = State) ->
    {reply, pgsql:squery(Conn, Sql), State};

handle_call({equery, Sql}, _From, #conn_record{conn = Conn} = State) ->
    {reply, pgsql:equery(Conn, Sql), State};

handle_call({equery, Sql, Parameters}, _From, #conn_record{conn = Conn} = State) ->
    {reply, pgsql:equery(Conn, Sql, Parameters), State};

handle_call({parse, Sql}, _From, #conn_record{conn = Conn} = State) ->
    {reply, pgsql:parse(Conn, Sql), State};

handle_call({parse, Sql, Types}, _From, #conn_record{conn = Conn} = State) ->
    {reply, pgsql:parse(Conn, Sql, Types), State};

handle_call({parse, Name, Sql, Types}, _From, #conn_record{conn = Conn} = State) ->
    {reply, pgsql:parse(Conn, Name, Sql, Types), State};

handle_call({bind, Statement, Parameters}, _From, #conn_record{conn = Conn} = State) ->
    {reply, pgsql:bind(Conn, Statement, Parameters), State};

handle_call({bind, Statement, PortalName, Parameters}, _From, #conn_record{conn = Conn} = State) ->
    {reply, pgsql:bind(Conn, Statement, PortalName, Parameters), State};

handle_call({execute, S}, _From, #conn_record{conn = Conn} = State) ->
    {reply, pgsql:execute(Conn, S), State};

handle_call({execute, S, N}, _From, #conn_record{conn = Conn} = State) ->
    {reply, pgsql:execute(Conn, S, N), State};

handle_call({execute, S, PortalName, N}, _From, #conn_record{conn = Conn} = State) ->
    {reply, pgsql:execute(Conn, S, PortalName, N), State};

handle_call({describe, X0}, _From, #conn_record{conn = Conn} = State) ->
    {reply, pgsql:describe(Conn, X0), State};

handle_call({describe, Type, Name}, _From, #conn_record{conn = Conn} = State) ->
    {reply, pgsql:describe(Conn, Type, Name), State};

handle_call({sync}, _From, #conn_record{conn = Conn} = State) ->
    {reply, pgsql:sync(Conn), State};

handle_call({with_transaction, F}, _From, #conn_record{conn = Conn} = State) ->
    {reply, pgsql:with_transaction(Conn, F), State};

handle_call(_Request, _From, State) ->
    {reply, _Reply = ok, State}.

handle_cast(stop, State) ->
    {stop, normal, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, #conn_record{conn = Conn} = State) ->
    pgsql:close(Conn),
    io:format("terminate ~p,~p,~p~n", [_Reason, State, self()]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.