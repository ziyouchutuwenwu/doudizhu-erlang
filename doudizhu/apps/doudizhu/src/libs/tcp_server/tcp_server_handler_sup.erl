-module(tcp_server_handler_sup).
-behaviour(supervisor).

-export([start_link/1, start_child/0]).
-export([init/1]).

-define(SERVER, ?MODULE).

start_link(LSock) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, [LSock]).

start_child() ->
    supervisor:start_child(?SERVER, []).

init([LSock]) ->

    RestartMode = simple_one_for_one,
    MaxRestarts = 0,
    MaxSecondsBetweenRestarts = 1,

    RestartStrategy = {RestartMode, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = temporary,
    Shutdown = brutal_kill,
    Type = worker,

    Child = {
        tcp_server_handler,
        {tcp_server_handler, start_link, [LSock]},
        Restart, Shutdown, Type,
        [tcp_server_handler]
    },

    Children = [Child],
    {ok, {RestartStrategy, Children}}.