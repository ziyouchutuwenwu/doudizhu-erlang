-module(gen_timer_sup).

-behaviour(supervisor).
-export([start_link/0, start_child/3]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_child(Duration, {Mod, CallBack}, Args) ->
    supervisor:start_child(?SERVER, [Duration, {Mod, CallBack}, Args]).

init([]) ->
    RestartMode = simple_one_for_one,
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,

    RestartStrategy = {RestartMode, MaxRestarts, MaxSecondsBetweenRestarts},

%%     permanent	遇到任何错误导致进程终止就重启
%%     temporary	进程永远都不重启
%%     transient	只有进程异常终止的时候会被重启
    Restart = temporary,
    Shutdown = 2000,
    Type = worker,

    Child = {
        gen_timer,
        {gen_timer, start_link, []},
        Restart, Shutdown, Type,
        [gen_timer]
    },

    Children = [Child],
    {ok, {RestartStrategy, Children}}.