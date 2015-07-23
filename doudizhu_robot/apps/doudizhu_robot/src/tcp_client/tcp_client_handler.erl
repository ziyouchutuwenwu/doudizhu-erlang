-module(tcp_client_handler).
-behaviour(gen_server).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(socket_info_record, {socket, ip, port, recv_timer_ref, recv_timeout_count}).

start_link({Ip, Port}) ->
    gen_server:start_link(?MODULE, [{Ip, Port}], []).

init([{Ip, Port}]) ->
    {ok, #socket_info_record{ip = Ip, port = Port}, 0}.

handle_call(Msg, _From, State) ->
    {reply, {ok, Msg}, State}.

%% 发数据包
handle_cast({send_socket_msg, Cmd, InfoBin}, State) ->
    send_socket_msg(Cmd, InfoBin, State);

handle_cast(stop, State) ->
    {stop, normal, State}.

handle_info({tcp, _Socket, Data}, #socket_info_record{recv_timer_ref = OldRecvTimerRef} = State) ->
    erlang:cancel_timer(OldRecvTimerRef),
    NewRecvTimerRef = erlang:send_after(tcp_client_options:get_tcp_recv_timeout(), self(), recv_time_out),

    CodecMod = behavior_config:get_codec_module(),
    DataBin = CodecMod:decode(Data),

    UnpackMod = behavior_config:get_packet_module(),
    {Cmd, InfoBin} = UnpackMod:unpack(DataBin),

    HandlerMod = behavior_config:get_socket_handler_module(),
    HandlerMod:on_client_data(Cmd, InfoBin),

    {noreply, State#socket_info_record{recv_timer_ref = NewRecvTimerRef}};

handle_info({tcp_passive, Socket}, State) ->
    inet:setopts(Socket, [{active, tcp_client_options:get_active_count()}]),
    {noreply, State};

handle_info({tcp_closed, _Socket}, #socket_info_record{ip = Ip} = State) ->
    HandlerMod = behavior_config:get_socket_handler_module(),
    HandlerMod:on_disconnected(Ip),

    {stop, normal, State};

handle_info({tcp_error, _Socket, Reason}, State) ->
    {stop, Reason, State};

handle_info(timeout, #socket_info_record{ip = Ip, port = Port} = State) ->
    Options = tcp_client_options:get_tcp_options(),
    case gen_tcp:connect(Ip, Port, Options, tcp_client_options:get_tcp_conn_timeout()) of
        {ok, Socket} ->
            RecvTimeoutCount = 0,
            RecvTimerRef = erlang:send_after(tcp_client_options:get_tcp_recv_timeout(), self(), recv_time_out),

            {ok, {IP, _Port}} = inet:peername(Socket),
            HandlerMod = behavior_config:get_socket_handler_module(),
            HandlerMod:on_client_connected(IP),

            {noreply, State#socket_info_record{
                socket = Socket, ip = Ip,
                recv_timer_ref = RecvTimerRef, recv_timeout_count = RecvTimeoutCount}
            };
        {error, Reason} ->
            {stop, Reason, State}

    end;

handle_info(recv_time_out, #socket_info_record{recv_timer_ref = RecvTimerRef, recv_timeout_count = RecvTimeoutCount} = State) ->
    NewRecvTimeoutCount = RecvTimeoutCount + 1,
    RecvTimeOutLimit = tcp_client_options:get_tcp_recv_timeout_count(),

    if
%%         超过最大限制
        NewRecvTimeoutCount >=  RecvTimeOutLimit->
            erlang:cancel_timer(RecvTimerRef),
            io:format("到达超时次数限制~n"),
            {stop, recv_timeout, State#socket_info_record{
                recv_timeout_count = NewRecvTimeoutCount}
            };
        true ->
            erlang:cancel_timer(RecvTimerRef),
            NewRecvTimerRef = erlang:send_after(tcp_client_options:get_tcp_recv_timeout(), self(), recv_time_out),
            {noreply, State#socket_info_record{
                recv_timeout_count = NewRecvTimeoutCount,
                recv_timer_ref = NewRecvTimerRef}
            }
    end;

handle_info({delay, Module, CallBack, Args}, State) ->
    Module:CallBack(Args),
    {noreply, State};

handle_info(_Info, StateData) ->
    {noreply, StateData}.

terminate(_Reason, #socket_info_record{socket = Socket}) ->
    io:format("socket process terminated~n"),
    (catch gen_tcp:close(Socket)),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

send_socket_msg(Cmd, InfoBin, #socket_info_record{socket = Socket} = State) ->
    PackMod = behavior_config:get_packet_module(),
    DataBin = PackMod:pack(Cmd, InfoBin),

    CodecMod = behavior_config:get_codec_module(),
    Data = CodecMod:encode(DataBin),

    ok = gen_tcp:send(Socket, Data),
    {noreply, State}.