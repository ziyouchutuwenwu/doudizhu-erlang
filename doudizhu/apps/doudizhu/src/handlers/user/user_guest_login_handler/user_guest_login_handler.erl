-module(user_guest_login_handler).

-export([handle_request/3]).

handle_request(Pid, Cmd, InfoBin) ->
    {DeviceName, OsName, OsVersion, DeviceId} = user_guest_login_decoder:decode(InfoBin),
    Gender = (
            case random_generator:random_number() rem 2 of
                0 ->
                    "male";
                _ ->
                    "female"
            end
    ),

    UserId = (
            case user_helper:get_guest_user_by_deviceid(DeviceId) of
                {ok, ExistedUserId} ->
                    io:format("get existed userid ~p~n", [ExistedUserId]),
                    ExistedUserId;
                {error, not_found} ->
                    case user_helper:create_guest_user("", Gender, DeviceName, OsName, OsVersion, DeviceId) of
                        {ok, CreatedUserId} ->
                            io:format("create new userid ~p~n", [CreatedUserId]),
                            CreatedUserId;
                        _ ->
                            io:format("创建游客用户失败sql失败~n"),
                            ""
                    end;
                _ ->
                    io:format("查询游客用户失败sql失败~n"),
                    ""
            end
    ),

%%     用户登陆需要设置user_map:set(Pid, ExistedUserId),redis的online，redis的gender
    if
        length(UserId) > 0 ->
            user_map:set(Pid, UserId),
            user_helper:set_user_online(UserId, 1),
            user_helper:set_user_gender(UserId, Gender),
            JsonBin = user_guest_login_encoder:encode(UserId, Gender, 0),
            tcp_send:send_data(Pid, Cmd, JsonBin);
        true ->
            JsonBin = user_guest_login_encoder:encode("", "", 1),
            tcp_send:send_data(Pid, Cmd, JsonBin)
    end.