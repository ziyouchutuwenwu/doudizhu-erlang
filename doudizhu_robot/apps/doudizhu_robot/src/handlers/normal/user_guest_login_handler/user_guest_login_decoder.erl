-module(user_guest_login_decoder).

-export([decode/1]).

%返回{UserId,Gender,Error}
decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),

    Gender = binary_to_list(json:get(<<"/gender">>, InfoRec)),
    UserId = binary_to_list(json:get(<<"/id">>, InfoRec)),
    Error = json:get(<<"/error">>, InfoRec),

    {UserId, Gender, Error}.