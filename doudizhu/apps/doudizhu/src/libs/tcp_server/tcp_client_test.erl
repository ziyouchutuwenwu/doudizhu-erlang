-module(tcp_client_test).

-compile(export_all).

test() ->
    {ok, Socket} = gen_tcp:connect("localhost", 9999, [{active, once}, {packet, 4}]),
    gen_tcp:send(Socket, "fuck data"),
    gen_tcp:close(Socket).