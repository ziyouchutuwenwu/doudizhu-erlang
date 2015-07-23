-module(redis_conn_pool_query_test).

-compile(export_all).

start_pool() ->
    redis_conn_pool_sup:start_link().

single_query(Cmd) ->
%%   Cmd = ["SET", "foo", "bar"],
    redis_conn_pool_query:single_query(Cmd).

pipeline_query(Cmds) ->
%%   Cmds = [
%%     ["SET", "foo", "bar"],
%%     ["SET", "bar", "baz"]
%%   ],
    redis_conn_pool_query:pipeline_query(Cmds).

transcation_query(Cmds) ->
%%   Cmds = [
%%     ["SET", a, "1"],
%%     ["LPUSH", b, "3"],
%%     ["LPUSH", b, "2"]
%%   ],
    redis_conn_pool_query:transcation_query(Cmds).

%%   Cmds = [["SET", a, "1"],["LPUSH", b, "3"],["LPUSH", b, "2"]].