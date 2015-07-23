-module(user_storage).

-export([init/1, destroy/1]).
-export([get/2, set/3, remove/2]).

init(UserId) ->
    Name = safe_atom:list_to_atom(data_format:format('user_~s', [UserId])),
    TableName = ets:new(Name, [named_table]),
    {ok, TableName}.

destroy(UserId) ->
    TableName = safe_atom:list_to_atom(data_format:format('user_~s', [UserId])),

    try ets:delete(TableName) of
        true ->
            true
    catch
        _:_ ->
            true
    end.

get(UserId, Key) ->
    TableName = safe_atom:list_to_atom(data_format:format('user_~s', [UserId])),
    ets:lookup(TableName, Key).

set(UserId, Key, Value) ->
    TableName = safe_atom:list_to_atom(data_format:format('user_~s', [UserId])),
    ets:insert(TableName, {Key, Value}).

remove(UserId, Key) ->
    TableName = safe_atom:list_to_atom(data_format:format('user_~s', [UserId])),
    ets:delete(TableName, Key).