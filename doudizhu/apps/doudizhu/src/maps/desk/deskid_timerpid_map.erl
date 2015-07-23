-module(deskid_timerpid_map).

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% callbacks of gen_server
init([]) ->
    TableName = ets:new(?MODULE, [named_table]),
    {ok, TableName}.

handle_call({set, Key, Value}, _From, TableName) ->
    ets:insert(TableName, [{Key, Value}]),
    {reply, ok, TableName};

handle_call({get, Key}, _From, TableName) ->
    Result = (
            try ets:lookup_element(TableName, Key, 2) of
                Value ->
                    Value
            catch
                _:_ ->
                    ""
            end
    ),
    {reply, Result, TableName};

handle_call({remove, Key}, _From, TableName) ->
    try ets:delete(TableName, Key)
    catch
        _:_ ->
            ok
    end,
    {reply, ok, TableName}.

handle_cast(stop, State) ->
    {stop, normal, State};
handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    io:format("terminate trapped~n"),
    ok.

code_change(_OldVsb, State, _Extra) ->
    {ok, State}.