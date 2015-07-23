-module(user_register_handler).

-export([handle_response/3]).

handle_response(Pid, Cmd, InfoBin) ->
    {UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId} = user_register_decoder:decode(InfoBin),

    case user_helper:get_registered_user_by_username(UserName) of
        {error, not_found} ->
            case user_helper:create_registered_user(UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId) of
                {ok, CreatedUserId} ->
                    %%创建成功
                    user_map:set(Pid, CreatedUserId),
                    user_helper:set_user_online(CreatedUserId, 1),
                    user_helper:set_user_gender(CreatedUserId, Gender),
                    JsonBin = user_register_encoder:encode(CreatedUserId, Gender, 0),
                    tcp_send:send_data(Pid, Cmd, JsonBin);
                _ ->
                    %%创建失败
                    JsonBin = user_register_encoder:encode("", "", 1),
                    tcp_send:send_data(Pid, Cmd, JsonBin)
            end;
        _ ->
%%                     创建失败
            JsonBin = user_register_encoder:encode("", "", 1),
            tcp_send:send_data(Pid, Cmd, JsonBin)
    end.