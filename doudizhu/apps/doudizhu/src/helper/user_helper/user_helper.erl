-module(user_helper).

-include_lib("doudizhu/src/const/sql_user_type_const.hrl").

-export([get_user_type/1]).
-export([get_guest_user_property/2, get_registered_user_property/2]).
-export([get_guest_user_by_deviceid/1, create_guest_user/6]).
-export([get_registered_user_by_username/1, get_registered_user_by_username_password/2, create_registered_user/7]).
-export([change_guest_to_registered_user/8, update_registered_user_info/8]).

-export([get_user_online/1, set_user_online/2, remove_user_online/1]).
-export([get_user_gender/1, set_user_gender/2, remove_user_gender/1]).
-export([get_user_deskid/1, set_user_deskid/2, remove_user_deskid/1]).
-export([get_user_roomid/1, set_user_roomid/2, remove_user_roomid/1]).

-export([get_user_ready/1, set_user_ready/2, remove_user_ready/1]).
-export([get_user_play_index/1, set_user_play_index/2, remove_user_play_index/1]).

%% 出牌
-export([get_cards_in_user_hand/1, set_cards_in_user_hand/2]).
-export([clear_cards_in_user_hand/1, add_cards_to_user_hand/2, remove_cards_from_user_hand/2]).

%% 断线重连获取用户是否叫地主
-export([get_user_has_jiao_di_zhu/1, set_user_has_jiao_di_zhu/2, remove_user_has_jiao_di_zhu/1]).
-export([get_user_is_first_jiao_di_zhu/1, set_user_is_first_jiao_di_zhu/2, remove_user_is_first_jiao_di_zhu/1]).

%% 断线重连获取用户出的牌
-export([get_user_previous_chu_pai_cards/1, set_user_previous_chu_pai_cards/2, remove_user_previous_chu_pai_cards/1]).

get_user_type(UserId) ->
    sql_helper:get_user_type(UserId).

get_guest_user_property(UserId, ColomnName) ->
    UserType = ?GUEST_USER_TYPE,
    sql_helper:get_user_property(UserId, ColomnName, UserType).

get_registered_user_property(UserId, ColomnName) ->
    UserType = ?REGISTER_USER_TYPE,
    sql_helper:get_user_property(UserId, ColomnName, UserType).

get_guest_user_by_deviceid(DeviceId) ->
    sql_helper:get_guest_user_by_deviceid(DeviceId).

create_guest_user(UserName, Gender, DeviceName, OsName, OsVersion, DeviceId) ->
    sql_helper:create_guest_user(UserName, Gender, DeviceName, OsName, OsVersion, DeviceId).

get_registered_user_by_username(UserName) ->
    sql_helper:get_registered_user_by_username(UserName).

get_registered_user_by_username_password(UserName, Password) ->
    sql_helper:get_registered_user_by_username_password(UserName, Password).

create_registered_user(UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId) ->
    sql_helper:create_registered_user(UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId).

change_guest_to_registered_user(UserId, UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId) ->
    sql_helper:change_guest_to_registered_user(UserId, UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId).

update_registered_user_info(UserId, UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId) ->
    sql_helper:update_registered_user_info(UserId, UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId).

%设置用户的一些属性
get_user_online(UserId) ->
    user_redis_wrapper:get_user_attr_int(UserId, "online").

set_user_online(UserId, Online) ->
    user_redis_wrapper:set_user_attr(UserId, "online", Online).

remove_user_online(UserId) ->
    user_redis_wrapper:remove_user_attr(UserId, "online").

get_user_gender(UserId) ->
    user_redis_wrapper:get_user_attr_string(UserId, "gender").

set_user_gender(UserId, Gender) ->
    user_redis_wrapper:set_user_attr(UserId, "gender", Gender).

remove_user_gender(UserId) ->
    user_redis_wrapper:remove_user_attr(UserId, "gender").

get_user_deskid(UserId) ->
    user_redis_wrapper:get_user_attr_string(UserId, "desk_id").

set_user_deskid(UserId, DeskId) ->
    user_redis_wrapper:set_user_attr(UserId, "desk_id", DeskId).

remove_user_deskid(UserId) ->
    user_redis_wrapper:remove_user_attr(UserId, "desk_id").

get_user_roomid(UserId) ->
    user_redis_wrapper:get_user_attr_string(UserId, "room_id").

set_user_roomid(UserId, RoomId) ->
    user_redis_wrapper:set_user_attr(UserId, "room_id", RoomId).

remove_user_roomid(UserId) ->
    user_redis_wrapper:remove_user_attr(UserId, "room_id").

get_user_ready(UserId) ->
    user_redis_wrapper:get_user_attr_int(UserId, "ready").

set_user_ready(UserId, Ready) ->
    user_redis_wrapper:set_user_attr(UserId, "ready", Ready).

remove_user_ready(UserId) ->
    user_redis_wrapper:remove_user_attr(UserId, "ready").

%% 从1开始
get_user_play_index(UserId) ->
    user_redis_wrapper:get_user_attr_int(UserId, "play_index").

set_user_play_index(UserId, PlayIndex) ->
    user_redis_wrapper:set_user_attr(UserId, "play_index", PlayIndex).

remove_user_play_index(UserId) ->
    user_redis_wrapper:remove_user_attr(UserId, "play_index").

%% 设置用户手里的牌
get_cards_in_user_hand(UserId) ->
    ListName = "cards_in_user_hand_" ++ UserId,
    CardList = redis_wrapper:get_list(ListName),
    lists:map(
        fun(CardString) ->
            data_convert:string_to_number(CardString)
        end,
        CardList
    ).

add_cards_to_user_hand(UserId, CardsToAdd) ->
    CardsInHand = get_cards_in_user_hand(UserId),
    NewCards = lists:append(CardsInHand, CardsToAdd),
    set_cards_in_user_hand(UserId, NewCards).

remove_cards_from_user_hand(UserId, CardsToRemove) ->
    CardsInHand = get_cards_in_user_hand(UserId),
    NewCards = lists:subtract(CardsInHand, CardsToRemove),
    set_cards_in_user_hand(UserId, NewCards).

set_cards_in_user_hand(UserId, Cards) ->
    clear_cards_in_user_hand(UserId),
    ListName = "cards_in_user_hand_" ++ UserId,

    lists:foreach(
        fun(Card) ->
            redis_wrapper:add_to_list(ListName, Card)
        end,
        Cards
    ).

clear_cards_in_user_hand(UserId) ->
    Cards = get_cards_in_user_hand(UserId),
    ListName = "cards_in_user_hand_" ++ UserId,

    lists:foreach(
        fun(Card) ->
            redis_wrapper:remove_from_list(ListName, Card)
        end,
        Cards
    ).

%% 断线重连的时候，获取用户是否叫地主的状态
get_user_has_jiao_di_zhu(UserId) ->
    user_redis_wrapper:get_user_attr_int(UserId, "has_jiao_di_zhu").

set_user_has_jiao_di_zhu(UserId, JiaoDiZhu) ->
    user_redis_wrapper:set_user_attr(UserId, "has_jiao_di_zhu", JiaoDiZhu).

remove_user_has_jiao_di_zhu(UserId) ->
    user_redis_wrapper:remove_user_attr(UserId, "has_jiao_di_zhu").

get_user_is_first_jiao_di_zhu(UserId) ->
    user_redis_wrapper:get_user_attr_int(UserId, "is_first_jiao_di_zhu").

set_user_is_first_jiao_di_zhu(UserId, IsFirstJiaoDiZhu) ->
    user_redis_wrapper:set_user_attr(UserId, "is_first_jiao_di_zhu", IsFirstJiaoDiZhu).

remove_user_is_first_jiao_di_zhu(UserId) ->
    user_redis_wrapper:remove_user_attr(UserId, "is_first_jiao_di_zhu").

%% 设置用户上一次出的牌，只是用来显示给用户
get_user_previous_chu_pai_cards(UserId) ->
    ListName = "previous_chu_pai_cards_" ++ UserId,
    CardList = redis_wrapper:get_list(ListName),
    lists:map(
        fun(CardString) ->
            data_convert:string_to_number(CardString)
        end,
        CardList
    ).

set_user_previous_chu_pai_cards(UserId, Cards) ->
    remove_user_previous_chu_pai_cards(UserId),
    ListName = "previous_chu_pai_cards_" ++ UserId,

    lists:foreach(
        fun(Card) ->
            redis_wrapper:add_to_list(ListName, Card)
        end,
        Cards
    ).

remove_user_previous_chu_pai_cards(UserId) ->
    Cards = get_user_previous_chu_pai_cards(UserId),
    ListName = "previous_chu_pai_cards_" ++ UserId,

    lists:foreach(
        fun(Card) ->
            redis_wrapper:remove_from_list(ListName, Card)
        end,
        Cards
    ).