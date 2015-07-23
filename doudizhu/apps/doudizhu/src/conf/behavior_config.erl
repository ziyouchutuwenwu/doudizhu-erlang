-module(behavior_config).

-export([get_socket_handler_module/0, get_codec_module/0, get_packet_module/0]).

%返回实现socket_handler_behavior接口的模块名字
get_socket_handler_module() ->
    socket_handler_impl.

get_codec_module() ->
    codec_impl.

get_packet_module() ->
    packet_impl.