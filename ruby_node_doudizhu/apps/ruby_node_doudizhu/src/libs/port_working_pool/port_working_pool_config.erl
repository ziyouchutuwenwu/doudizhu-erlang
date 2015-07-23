-module(port_working_pool_config).

-export([get_pool_name/0, get_pool_args/0, get_worker_args/0]).

get_pool_name() ->
    port_working_pool.

get_pool_args() ->
    PoolArgs = [{name, {local, get_pool_name()}},
        {worker_module, port_worker},
        {size, 5},
        {max_overflow, 10}],
    PoolArgs.

get_worker_args() ->
    RubyScriptPath = app_config:get_ruby_script_path(),
    Cmd = "ruby" ++ " " ++ RubyScriptPath,
    WorkerArgs = [
        {cmd, Cmd}
    ],
    WorkerArgs.