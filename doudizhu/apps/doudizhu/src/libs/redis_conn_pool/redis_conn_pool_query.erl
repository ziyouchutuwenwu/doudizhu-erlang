-module(redis_conn_pool_query).

%% API
-export([single_query/1, pipeline_query/1, transcation_query/1]).

single_query(Cmd) ->
    PoolName = redis_conn_pool_config:get_pool_name(),
    Worker = poolboy:checkout(PoolName),
    Result = gen_server:call(Worker, {single_query, Cmd}),
    poolboy:checkin(PoolName, Worker),
    Result.

pipeline_query(CmdList) ->
    PoolName = redis_conn_pool_config:get_pool_name(),
    Worker = poolboy:checkout(PoolName),
    Result = gen_server:call(Worker, {pipeline_query, CmdList}),
    poolboy:checkin(PoolName, Worker),
    Result.

transcation_query(CmdList) ->
    PoolName = redis_conn_pool_config:get_pool_name(),
    Worker = poolboy:checkout(PoolName),
    Result = gen_server:call(Worker, {transcation_query, CmdList}),
    poolboy:checkin(PoolName, Worker),
    Result.