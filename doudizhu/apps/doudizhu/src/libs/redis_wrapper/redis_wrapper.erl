-module(redis_wrapper).

-export([get_map_value_string/2, get_map_value_int/2, set_map_value/3, remove_map_value/2]).
-export([sync_get_list_item/2, sync_add_to_list/2, sync_remove_from_list/2, sync_get_list_size/1, sync_get_list/1]).
-export([get_list_item/2, add_to_list/2, remove_from_list/2, get_list_size/1, get_list/1]).
%% -export([sync_add_to_zset/3, sync_remove_from_zset/2, sync_get_zset_size/1, sync_get_zset/1]).
%% -export([add_to_zset/3, remove_from_zset/2, get_zset_size/1, get_zset/1]).

get_map_value_string(MapName, Key) ->
    Cmd = ["hget", MapName, Key],
    Value = (
            case redis_conn_pool_query:single_query(Cmd) of
                {ok, undefined} ->
                    "";
                {ok, ValBin} ->
                    erlang:bitstring_to_list(ValBin)
            end
    ),
    Value.

get_map_value_int(MapName, Key) ->
    Cmd = ["hget", MapName, Key],
    Value = (
            case redis_conn_pool_query:single_query(Cmd) of
                {ok, undefined} ->
                    0;
                {ok, ValBin} ->
                    ValList = erlang:bitstring_to_list(ValBin),
                    data_convert:string_to_number(ValList)
            end
    ),
    Value.

set_map_value(MapName, Key, Value) ->
    Cmd = ["hset", MapName, Key, Value],
    redis_conn_pool_query:single_query(Cmd).

remove_map_value(MapName, Key) ->
    Cmd = ["hdel", MapName, Key],
    redis_conn_pool_query:single_query(Cmd).

%% 同步
sync_get_list_item(ListName, Index) ->
    Cmd = [["lindex", ListName, Index]],
    {ok, [ValBin]} = redis_conn_pool_query:transcation_query(Cmd),
    erlang:bitstring_to_list(ValBin).

sync_add_to_list(ListName, Item) ->
    Cmd = [["rpush", ListName, Item]],
    redis_conn_pool_query:transcation_query(Cmd).

sync_remove_from_list(ListName, Item) ->
    Cmd = [["lrem", ListName, "0", Item]],
    redis_conn_pool_query:transcation_query(Cmd).

sync_get_list_size(ListName) ->
    Cmd = [["llen", ListName]],
    {ok, [ValBin]} = redis_conn_pool_query:transcation_query(Cmd),
    data_convert:string_to_number(erlang:bitstring_to_list(ValBin)).

sync_get_list(ListName) ->
    Cmd = [["lrange", ListName, 0, get_list_size(ListName)]],
    {ok, [ValBinList]} = redis_conn_pool_query:transcation_query(Cmd),
    List = lists:map(
        fun(ItemBin) ->
            bitstring_to_list(ItemBin)
        end,
        ValBinList
    ),
    List.

%异步
get_list_item(ListName, Index) ->
    Cmd = ["lindex", ListName, Index],
    {ok, ValBin} = redis_conn_pool_query:single_query(Cmd),
    erlang:bitstring_to_list(ValBin).

add_to_list(ListName, Item) ->
    Cmd = ["rpush", ListName, Item],
    redis_conn_pool_query:single_query(Cmd).

remove_from_list(ListName, Item) ->
    Cmd = ["lrem", ListName, "0", Item],
    redis_conn_pool_query:single_query(Cmd).

get_list_size(ListName) ->
    Cmd = ["llen", ListName],
    {ok, ValBin} = redis_conn_pool_query:single_query(Cmd),
    data_convert:string_to_number(erlang:bitstring_to_list(ValBin)).

get_list(ListName) ->
    Cmd = ["lrange", ListName, 0, get_list_size(ListName)],
    {ok, ValBinList} = redis_conn_pool_query:single_query(Cmd),
    List = lists:map(
        fun(ItemBin) ->
            bitstring_to_list(ItemBin)
        end,
        ValBinList
    ),
    List.

% 同步处理zset
%% sync_add_to_zset(ZSetName, Score, Item) ->
%%     Cmd = [["zadd", ZSetName, Score, Item]],
%%     redis_conn_pool_query:transcation_query(Cmd).
%%
%% sync_remove_from_zset(ZSetName, Item) ->
%%     Cmd = [["zrem", ZSetName, Item]],
%%     redis_conn_pool_query:transcation_query(Cmd).
%%
%% sync_get_zset_size(ZSetName) ->
%%     Cmd = [["zcard", ZSetName]],
%%     {ok, [ValBin]} = redis_conn_pool_query:transcation_query(Cmd),
%%     data_convert:string_to_number(erlang:bitstring_to_list(ValBin)).
%%
%% sync_get_zset(ZSetName) ->
%%     Cmd = [["zrange", ZSetName, 0, -1]],
%%     {ok, [ValBinList]} = redis_conn_pool_query:transcation_query(Cmd),
%%     ZSet = lists:map(
%%         fun(ItemBin) ->
%%             bitstring_to_list(ItemBin)
%%         end,
%%         ValBinList
%%     ),
%%     ZSet.
%%
%% % 异步处理zset
%% add_to_zset(ZSetName, Score, Item) ->
%%     Cmd = ["zadd", ZSetName, Score, Item],
%%     redis_conn_pool_query:single_query(Cmd).
%%
%% remove_from_zset(ZSetName, Item) ->
%%     Cmd = ["zrem", ZSetName, Item],
%%     redis_conn_pool_query:single_query(Cmd).
%%
%% get_zset_size(ZSetName) ->
%%     Cmd = ["zcard", ZSetName],
%%     {ok, ValBin} = redis_conn_pool_query:single_query(Cmd),
%%     data_convert:string_to_number(erlang:bitstring_to_list(ValBin)).
%%
%% get_zset(ZSetName) ->
%%     Cmd = ["zrange", ZSetName, 0, -1],
%%     {ok, ValBinList} = redis_conn_pool_query:single_query(Cmd),
%%     ZSet = lists:map(
%%         fun(ItemBin) ->
%%             bitstring_to_list(ItemBin)
%%         end,
%%         ValBinList
%%     ),
%%     ZSet.