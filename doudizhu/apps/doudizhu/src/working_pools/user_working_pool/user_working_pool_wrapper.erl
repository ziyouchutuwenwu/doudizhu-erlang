-module(user_working_pool_wrapper).

-export([do_user_request/3, delay_cast/3]).

do_user_request(Pid, Cmd, InfoBin) ->
    PoolName = user_working_pool_config:get_pool_name(),
    Worker = poolboy:checkout(PoolName),
    Result = gen_server:cast(Worker, {socket, Pid, Cmd, InfoBin}),
    poolboy:checkin(PoolName, Worker),
    Result.

%% 延迟调用，进桌子的时候用
delay_cast(Duration, {Module, CallBack}, Args) ->
    PoolName = user_working_pool_config:get_pool_name(),
    Worker = poolboy:checkout(PoolName),
    Result = gen_server:cast(Worker, {delay, Duration, Module, CallBack, Args}),
    poolboy:checkin(PoolName, Worker),
    Result.