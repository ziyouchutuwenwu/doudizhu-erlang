-module(user_login_handler).

-export([handle_response/3]).

handle_response(Pid, Cmd, InfoBin) ->
    {UserName, Password, DeviceName, OsName, OsVersion, DeviceId} = user_login_decoder:decode(InfoBin),

    case user_helper:get_registered_user_by_username_password(UserName, Password) of
        {ok, UserId} ->
            case user_helper:get_registered_user_property(UserId, "gender") of
                {ok, Gender} ->
                    case user_helper:update_registered_user_info(UserId, UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId) of
                        {ok, UpdatedUserId} ->
                            %%登陆成功
                            user_map:set(Pid, UpdatedUserId),
                            user_helper:set_user_online(UpdatedUserId, 1),
                            user_helper:set_user_gender(UpdatedUserId, Gender),
                            JsonBin = user_login_encoder:encode(UpdatedUserId, Gender, 0),
                            tcp_send:send_data(Pid, Cmd, JsonBin);
                        _ ->
                            %%登陆失败
                            JsonBin = user_login_encoder:encode("", "", 1),
                            tcp_send:send_data(Pid, Cmd, JsonBin)
                    end;
                _ ->
                    %%登陆失败
                    JsonBin = user_login_encoder:encode("", "", 1),
                    tcp_send:send_data(Pid, Cmd, JsonBin)
            end;
        _ ->
            %%登陆失败
            JsonBin = user_login_encoder:encode("", "", 1),
            tcp_send:send_data(Pid, Cmd, JsonBin)
    end.