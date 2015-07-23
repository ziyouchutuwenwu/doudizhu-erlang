-module(ruby_node_doudizhu_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    port_working_pool_sup:start_link().

stop(_State) ->
    ok.
