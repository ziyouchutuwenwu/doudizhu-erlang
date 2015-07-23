-module(node_caller_pool_config).

-export([get_pool_name/0, get_pool_args/0, get_worker_args/0]).

get_pool_name() ->
    node_caller_pool.

get_pool_args() ->
    PoolArgs = [
        {name, {local, get_pool_name()}},
        {worker_module, node_caller_worker},
        {size, 5},
        {max_overflow, 10}
    ],
    PoolArgs.

get_worker_args() ->
    NodePrefix = app_config:get_node_caller_prefix(),
    WorkerArgs = [
        {node_prefix, NodePrefix}
    ],
    WorkerArgs.