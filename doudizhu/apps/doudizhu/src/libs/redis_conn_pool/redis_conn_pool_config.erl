-module(redis_conn_pool_config).

-export([get_pool_name/0, get_pool_args/0, get_worker_args/0]).

get_pool_name() ->
    redis_conn_pool.

get_pool_args() ->
    PoolArgs = [
        {name, {local, get_pool_name()}},
        {worker_module, redis_worker},
        {size, 5},
        {max_overflow, 10}
    ],
    PoolArgs.

get_worker_args() ->
    Ip = app_config:get_redis_ip(),
    Port = app_config:get_redis_port(),

    WorkerArgs = [
        {ip, Ip},
        {port, Port}
    ],
    WorkerArgs.