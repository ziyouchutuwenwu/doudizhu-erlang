-module(user_edit_profile_handler).

-include_lib("doudizhu/src/const/sql_user_type_const.hrl").
-export([handle_response/3]).

handle_response(Pid, Cmd, InfoBin) ->
    {UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId} = user_edit_profile_decoder:decode(InfoBin),
    UserId = user_map:get_userid_by_pid(Pid),

    case user_helper:get_user_type(UserId) of
        {ok, ?GUEST_USER_TYPE} ->
            case user_helper:change_guest_to_registered_user(UserId, UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId) of
                {ok, UpdatedUserId} ->
                    %%更新成功
                    user_map:set(Pid, UpdatedUserId),
                    user_helper:set_user_online(UpdatedUserId, 1),
                    user_helper:set_user_gender(UpdatedUserId, Gender),
                    JsonBin = user_edit_profile_encoder:encode(UpdatedUserId, Gender, 0),
                    tcp_send:send_data(Pid, Cmd, JsonBin);
                _ ->
                    %%更新失败
                    JsonBin = user_edit_profile_encoder:encode("", "", 1),
                    tcp_send:send_data(Pid, Cmd, JsonBin)
            end;
        {ok, ?REGISTER_USER_TYPE} ->
            case user_helper:update_registered_user_info(UserId, UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId) of
                {ok, UpdatedUserId} ->
                    %%更新成功
                    user_map:set(Pid, UpdatedUserId),
                    user_helper:set_user_online(UpdatedUserId, 1),
                    user_helper:set_user_gender(UpdatedUserId, Gender),
                    JsonBin = user_edit_profile_encoder:encode(UpdatedUserId, Gender, 0),
                    tcp_send:send_data(Pid, Cmd, JsonBin);
                _ ->
                    %%更新失败
                    JsonBin = user_edit_profile_encoder:encode("", "", 1),
                    tcp_send:send_data(Pid, Cmd, JsonBin)
            end;
        _ ->
            %%更新失败
            JsonBin = user_edit_profile_encoder:encode("", "", 1),
            tcp_send:send_data(Pid, Cmd, JsonBin)
    end.