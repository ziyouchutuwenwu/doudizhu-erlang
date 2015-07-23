-module(redis_worker_sup).

-behaviour(supervisor).
-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% {ok,{{one_for_one,1000,3600},
%% [{test_pool,{poolboy,start_link,
%% [[{name,{local,test_pool}},
%% {worker_module,test_worker},
%% {size,5},
%% {max_overflow,10}],
%% [test_work_args]]},
%% permanent,5000,worker,
%% [poolboy]}]}}

%init返回的策略里面的回调函数是poolboy,start_link,所以,不需要手工去启动poolboy
init([]) ->
    Name = redis_conn_pool_config:get_pool_name(),
    PoolArgs = redis_conn_pool_config:get_pool_args(),
    WorkerArgs = redis_conn_pool_config:get_worker_args(),

    PoolSpec = poolboy:child_spec(Name, PoolArgs, [WorkerArgs]),

    ChildSpecs = [PoolSpec],
    {ok, {{one_for_one, 1000, 3600}, ChildSpecs}}.