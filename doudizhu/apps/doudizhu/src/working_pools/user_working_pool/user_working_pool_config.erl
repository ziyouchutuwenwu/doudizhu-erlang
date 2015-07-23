-module(user_working_pool_config).

-export([get_pool_name/0, get_pool_args/0, get_worker_args/0]).

get_pool_name() ->
    user_working_pool.

get_pool_args() ->
    PoolArgs = [
        {name, {local, get_pool_name()}},
        {worker_module, user_worker},
        {size, 3},
        {max_overflow, 2}
    ],
    PoolArgs.

get_worker_args() ->
    WorkerArgs = [{arg1, ""}, {arg2, ""}],
    WorkerArgs.