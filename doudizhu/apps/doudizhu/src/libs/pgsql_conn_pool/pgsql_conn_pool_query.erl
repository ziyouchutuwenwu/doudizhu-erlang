-module(pgsql_conn_pool_query).

-export([get_parameter/1, squery/1, equery/1, equery/2, parse/1, parse/2, parse/3]).
-export([bind/2, bind/3, execute/1, execute/2, execute/3, describe/2, sync/0, with_transaction/1]).

get_parameter(Name) ->
    PoolName = pgsql_conn_pool_config:get_pool_name(),
    poolboy:transaction(PoolName,
        fun(W) ->
            gen_server:call(W, {get_parameter, Name})
        end).

squery(Sql) ->
    PoolName = pgsql_conn_pool_config:get_pool_name(),
    poolboy:transaction(PoolName,
        fun(W) ->
            gen_server:call(W, {squery, Sql})
        end).

equery(Sql) ->
    PoolName = pgsql_conn_pool_config:get_pool_name(),
    poolboy:transaction(PoolName,
        fun(W) ->
            gen_server:call(W, {equery, Sql})
        end).

equery(Sql, Parameters) ->
    PoolName = pgsql_conn_pool_config:get_pool_name(),
    poolboy:transaction(PoolName,
        fun(W) ->
            gen_server:call(W, {equery, Sql, Parameters})
        end).

parse(Sql) ->
    PoolName = pgsql_conn_pool_config:get_pool_name(),
    poolboy:transaction(PoolName,
        fun(W) ->
            gen_server:call(W, {parse, Sql})
        end).

parse(Sql, Types) ->
    PoolName = pgsql_conn_pool_config:get_pool_name(),
    poolboy:transaction(PoolName,
        fun(W) ->
            gen_server:call(W, {parse, Sql, Types})
        end).

parse(Name, Sql, Types) ->
    PoolName = pgsql_conn_pool_config:get_pool_name(),
    poolboy:transaction(PoolName,
        fun(W) ->
            gen_server:call(W, {parse, Name, Sql, Types})
        end).

bind(Statement, Parameters) ->
    PoolName = pgsql_conn_pool_config:get_pool_name(),
    poolboy:transaction(PoolName,
        fun(W) ->
            gen_server:call(W, {bind, Statement, Parameters})
        end).

bind(Statement, PortalName, Parameters) ->
    PoolName = pgsql_conn_pool_config:get_pool_name(),
    poolboy:transaction(PoolName,
        fun(W) ->
            gen_server:call(W, {bind, Statement, PortalName, Parameters})
        end).

execute(S) ->
    PoolName = pgsql_conn_pool_config:get_pool_name(),
    poolboy:transaction(PoolName,
        fun(W) ->
            gen_server:call(W, {execute, S})
        end).

execute(S, N) ->
    PoolName = pgsql_conn_pool_config:get_pool_name(),
    poolboy:transaction(PoolName,
        fun(W) ->
            gen_server:call(W, {execute, S, N})
        end).

execute(S, PortalName, N) ->
    PoolName = pgsql_conn_pool_config:get_pool_name(),
    poolboy:transaction(PoolName,
        fun(W) ->
            gen_server:call(W, {execute, S, PortalName, N})
        end).

describe(Type, Name) ->
    PoolName = pgsql_conn_pool_config:get_pool_name(),
    poolboy:transaction(PoolName,
        fun(W) ->
            gen_server:call(W, {describe, Type, Name})
        end).

sync() ->
    PoolName = pgsql_conn_pool_config:get_pool_name(),
    poolboy:transaction(PoolName,
        fun(W) ->
            gen_server:call(W, {sync})
        end).

with_transaction(F) ->
    PoolName = pgsql_conn_pool_config:get_pool_name(),
    poolboy:transaction(PoolName,
        fun(W) ->
            gen_server:call(W, {with_transaction, F})
        end).