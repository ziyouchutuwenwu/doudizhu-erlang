-module(user_map).

-export([start/0, stop/0, get_userid_by_pid/1, get_pid_by_userid/1, set/2, remove_by_pid/1]).

start() ->
    user_map_sup:start_link(),
    ok.

stop() ->
%%     gen_server:cast(socketPid_userId_map, stop),
%%     gen_server:cast(userId_socketPid_map, stop),
    ok.

get_userid_by_pid(Pid) ->
    gen_server:call(socketpid_userid_map, {get, Pid}).

get_pid_by_userid(UserId) ->
    gen_server:call(userid_socketpid_map, {get, UserId}).

set(Pid, UserId) ->
    gen_server:call(socketpid_userid_map, {set, Pid, UserId}),
    gen_server:call(userid_socketpid_map, {set, UserId, Pid}).

remove_by_pid(Pid) ->
    UserId = get_userid_by_pid(Pid),
    gen_server:call(userid_socketpid_map, {remove, UserId}),
    gen_server:call(socketpid_userid_map, {remove, Pid}).