-module(socket_handler_impl).

-include_lib("doudizhu/src/const/socket_const.hrl").
-behaviour(socket_handler_behavior).

-export([on_client_connected/1, on_client_data/2, on_disconnected/1]).

on_client_connected(_IP) ->
    Cmd = ?CMD_CLIENT_CONNECTED,
    InfoBin = <<>>,
    user_working_pool_wrapper:do_user_request(self(), Cmd, InfoBin),
    noreplay.

on_client_data(Cmd, InfoBin) ->
    user_working_pool_wrapper:do_user_request(self(), Cmd, InfoBin),
    noreplay.

on_disconnected(_IP) ->
    Cmd = ?CMD_CLIENT_DISCONNECTED,
    InfoBin = <<>>,
    user_working_pool_wrapper:do_user_request(self(), Cmd, InfoBin),
    noreplay.