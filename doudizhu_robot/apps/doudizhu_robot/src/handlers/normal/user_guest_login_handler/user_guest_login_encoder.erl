-module(user_guest_login_encoder).

-export([encode/6]).

encode(DeviceName, OsName, OsVersion, AppId, AppVersion, DeviceId) ->

    DeviceNameBin = utf8_list:list_to_binary(DeviceName),
    OsNameBin = utf8_list:list_to_binary(OsName),
    OsVersionBin = utf8_list:list_to_binary(OsVersion),
    AppIdBin = utf8_list:list_to_binary(AppId),
    AppVersionBin = utf8_list:list_to_binary(AppVersion),
    DeviceIdBin = utf8_list:list_to_binary(DeviceId),

    Response = #{
        <<"deviceName">> => DeviceNameBin,
        <<"osName">> => OsNameBin,
        <<"osVersion">> => OsVersionBin,
        <<"deviceId">> => DeviceIdBin,

        <<"appId">> => AppIdBin,
        <<"appVersion">> => AppVersionBin
    },
    JsonBin = json:to_binary(Response),
    JsonBin.