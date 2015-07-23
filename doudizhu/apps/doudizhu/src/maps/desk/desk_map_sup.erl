-module(desk_map_sup).

-behaviour(supervisor).
-export([start_link/0, init/1]).

start_link() ->
    io:format("desk_map_sup start link~n"),
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->

    RestartMode = one_for_one,
    MaxRestarts = 0,
    MaxSecondsBetweenRestarts = 1,

    RestartStrategy = {RestartMode, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = temporary,
    Shutdown = brutal_kill,
    Type = worker,

    Child = {
        deskid_timerpid_map,
        {deskid_timerpid_map, start_link, []},
        Restart, Shutdown, Type,
        [deskid_timerpid_map]
    },

    Children = [Child],
    {ok, {RestartStrategy, Children}}.