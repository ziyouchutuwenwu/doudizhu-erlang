-module(desk_working_pool_wrapper).

-export([do_desk_request/3]).

do_desk_request(DeskId, Cmd, Params) ->
    PoolName = desk_working_pool_config:get_pool_name(),
    Worker = poolboy:checkout(PoolName),
    Result = gen_server:cast(Worker, {desk, DeskId, Cmd, Params}),
    poolboy:checkin(PoolName, Worker),
    Result.