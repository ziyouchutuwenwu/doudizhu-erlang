-module(node_caller_pool_wrapper).

-export([call_remote_node/3]).

call_remote_node(Module, Function, Args) ->
    PoolName = node_caller_pool_config:get_pool_name(),
    Worker = poolboy:checkout(PoolName),
    Result = gen_server:call(Worker, {node_call, Module, Function, Args}),
    poolboy:checkin(PoolName, Worker),
    Result.