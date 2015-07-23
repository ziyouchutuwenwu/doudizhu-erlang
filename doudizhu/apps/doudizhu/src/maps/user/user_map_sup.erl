-module(user_map_sup).

-behaviour(supervisor).
-export([start_link/0, init/1]).

start_link() ->
    io:format("user_map_sup start link~n"),
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    RestartMode = one_for_one,
    MaxRestarts = 0,
    MaxSecondsBetweenRestarts = 1,

    RestartStrategy = {RestartMode, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = temporary,
    Shutdown = brutal_kill,
    Type = worker,

    ChildUserIdSocketPidMap = {
        userid_socketpid_map,
        {userid_socketpid_map, start_link, []},
        Restart, Shutdown, Type,
        [userid_socketpid_map]
    },

    ChildSocketPidUserIdMap = {
        socketpid_userid_map,
        {socketpid_userid_map, start_link, []},
        Restart, Shutdown, Type,
        [socketpid_userid_map]
    },

    Children = [ChildUserIdSocketPidMap, ChildSocketPidUserIdMap],
    {ok, {RestartStrategy, Children}}.