-module(user_working_pool_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    RestartMode = one_for_one,
    MaxRestarts = 100,
    MaxSecondsBetweenRestarts = 10,

    RestartStrategy = {RestartMode, MaxRestarts, MaxSecondsBetweenRestarts},

%%   Restart = permanent,
    Restart = transient,
    Shutdown = 5000,
    Type = supervisor,

    Child = {
        user_worker_sup,
        {user_worker_sup, start_link, []},
        Restart, Shutdown, Type,
        [user_worker_sup]
    },

    Children = [Child],
    {ok, {RestartStrategy, Children}}.