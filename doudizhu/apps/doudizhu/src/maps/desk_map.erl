-module(desk_map).

-export([start/0, stop/0, get_pid_by_deskid/1, set/2, remove_by_deskid/1]).

start() ->
    desk_map_sup:start_link(),
    ok.

stop() ->
%%     gen_server:cast(socketPid_userId_map, stop),
%%     gen_server:cast(userId_socketPid_map, stop),
    ok.

get_pid_by_deskid(DeskId) ->
    gen_server:call(deskid_timerpid_map, {get, DeskId}).

set(DeskId, Pid) ->
    gen_server:call(deskid_timerpid_map, {set, DeskId, Pid}).

remove_by_deskid(DeskId) ->
    gen_server:call(deskid_timerpid_map, {remove, DeskId}).