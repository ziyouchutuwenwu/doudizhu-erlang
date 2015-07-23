-module(user_connect_handler).

-include_lib("doudizhu_robot/src/const/socket_const.hrl").
-export([handle_response/1]).

handle_response(Pid) ->
    io:format("server connected ~n"),

    RandomNumer = data_convert:number_to_string(random_generator:random_number()),
    DeviceName = "机器人",
    OsName = "机器人os",
    OsVersion = "1.0",
    AppId = "com.mmcshadow.doudizhu",
    AppVersion = "1.0",
    DeviceId = RandomNumer,

    JsonBin = user_guest_login_encoder:encode(DeviceName, OsName, OsVersion, AppId, AppVersion, DeviceId),
    tcp_send:send_data(Pid, ?CMD_USER_GUEST_LOGIN, JsonBin),
    ok.