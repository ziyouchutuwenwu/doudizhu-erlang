-module(tcp_server_listener_sup).

-behaviour(supervisor).

-export([start_link/2]).
-export([init/1]).

start_link(Name, Port) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, [Name, Port]).

init([Name, Port]) ->

    RestartMode = one_for_one,
    MaxRestarts = 10,
    MaxSecondsBetweenRestarts = 1,

    RestartStrategy = {RestartMode, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = transient,
    Shutdown = brutal_kill,
    Type = worker,

    Child = {
        tcp_server_listener,
        {tcp_server_listener, start_link, [Name, Port]},
        Restart, Shutdown, Type,
        [tcp_server_listener]
    },

    Children = [Child],
    {ok, {RestartStrategy, Children}}.