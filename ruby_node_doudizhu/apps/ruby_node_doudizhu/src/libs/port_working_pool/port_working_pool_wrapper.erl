-module(port_working_pool_wrapper).

-export([do_port_work/2]).

do_port_work(Cmd, Args) ->
    PoolName = port_working_pool_config:get_pool_name(),
    Worker = poolboy:checkout(PoolName),
    Message = {Cmd, Args},
    Result = gen_server:call(Worker, {port_call, Message}),
    poolboy:checkin(PoolName, Worker),
    Result.