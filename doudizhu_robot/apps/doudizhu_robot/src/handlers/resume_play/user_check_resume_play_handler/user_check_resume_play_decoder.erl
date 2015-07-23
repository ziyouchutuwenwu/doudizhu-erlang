-module(user_check_resume_play_decoder).

-export([decode/1]).

%返回{ShouldResumePlay}
decode(InfoBin) ->
    InfoRec = json:from_binary(InfoBin),

    ShouldResumePlay = json:get(<<"/shouldResumePlay">>, InfoRec),

    {ShouldResumePlay}.