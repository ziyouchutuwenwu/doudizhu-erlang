-module(user_edit_profile_decoder).

-export([decode/1]).

%返回{UserName,Password,Gender,DeviceName,OsName,OsVersion,DeviceId}
decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),

    UserName = binary_to_list(json:get(<<"/userName">>, InfoRec)),
    Password = binary_to_list(json:get(<<"/password">>, InfoRec)),
    Gender = binary_to_list(json:get(<<"/gender">>, InfoRec)),

    DeviceName = binary_to_list(json:get(<<"/deviceName">>, InfoRec)),
    OsName = binary_to_list(json:get(<<"/osName">>, InfoRec)),
    OsVersion = binary_to_list(json:get(<<"/osVersion">>, InfoRec)),
    DeviceId = binary_to_list(json:get(<<"/deviceId">>, InfoRec)),

    {UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId}.