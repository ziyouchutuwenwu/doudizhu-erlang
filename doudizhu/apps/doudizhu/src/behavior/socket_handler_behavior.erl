-module(socket_handler_behavior).

-callback on_client_connected(IP :: atom()) ->
    noreplay.

-callback on_client_data(Cmd :: integer(), InfoBin :: any()) ->
    noreplay.

-callback on_disconnected(IP :: atom()) ->
    noreplay.