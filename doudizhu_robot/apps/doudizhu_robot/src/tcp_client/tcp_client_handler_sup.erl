-module(tcp_client_handler_sup).
-behaviour(supervisor).

-export([start_link/1, start_child/0]).
-export([init/1]).

-define(SERVER, ?MODULE).

start_link({Ip, Port}) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, [{Ip, Port}]).

start_child() ->
    supervisor:start_child(?SERVER, []).

init([{Ip, Port}]) ->

    RestartMode = simple_one_for_one,
    MaxRestarts = 0,
    MaxSecondsBetweenRestarts = 1,

    RestartStrategy = {RestartMode, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = temporary,
    Shutdown = brutal_kill,
    Type = worker,

    Child = {
        tcp_client_handler,
        {tcp_client_handler, start_link, [{Ip, Port}]},
        Restart, Shutdown, Type,
        [tcp_client_handler]
    },

    Children = [Child],
    {ok, {RestartStrategy, Children}}.