-module(node_caller_pool_wrapper_test).

-compile(export_all).

start_pool() ->
    node_caller_pool_sup:start_link().

call_test() ->
    Mod = test,
    Func = test_a,
    Arg = {1, 2, 3, 4},
    node_caller_pool_wrapper:call_remote_node(Mod, Func, Arg).