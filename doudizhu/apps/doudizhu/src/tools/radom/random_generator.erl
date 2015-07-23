-module(random_generator).

-export([random_number/0]).

random_number() ->
    Min = round(math:pow(10, 15)),
    Max = round(math:pow(10, 16)) - 1,
    Delta = Min - 1,
    <<A:32, B:32, C:32>> = crypto:strong_rand_bytes(12),
    Seed = {A, B, C},
    random:seed(Seed),
    random:uniform(Max - Delta) + Delta.