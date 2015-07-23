-module(sql_helper).

-include_lib("doudizhu/src/const/sql_user_type_const.hrl").
-export([get_user_type/1]).
-export([get_user_property/3]).
-export([get_guest_user_by_deviceid/1, create_guest_user/6]).
-export([get_registered_user_by_username/1, get_registered_user_by_username_password/2, create_registered_user/7]).
-export([change_guest_to_registered_user/8, update_registered_user_info/8]).

-export([get_latested_version_info/2]).

get_user_type(UserId) ->
    Sql = data_format:format("select user_type from users where user_id='~s';", [UserId]),
    case pgsql_conn_pool_query:squery(Sql) of
        {ok, _, Rows} ->
            if
                length(Rows) > 0 ->
                    [Row | _] = Rows,
                    {UserTypeBin} = Row,
                    UserType = binary_to_list(UserTypeBin),
                    {ok, UserType};
                length(Rows) =:= 0 ->
                    {error, not_found}
            end;
        _ ->
            {error, pgsql_error}
    end.

%% 获取用户属性
get_user_property(UserId, ColomnName, UserType) ->
    Sql = data_format:format("select ~s from users where user_id='~s' and user_type='~s';",
        [ColomnName, UserId, UserType]),
    case pgsql_conn_pool_query:squery(Sql) of
        {ok, _, Rows} ->
            if
                length(Rows) > 0 ->
                    [Row | _] = Rows,
                    {PropertyBin} = Row,
                    Property = binary_to_list(PropertyBin),
                    {ok, Property};
                length(Rows) =:= 0 ->
                    {error, not_found}
            end;
        _ ->
            {error, pgsql_error}
    end.

%根据用户硬件id返回userid
get_guest_user_by_deviceid(DeviceId) ->
    UserType = ?GUEST_USER_TYPE,
    Sql = data_format:format("select user_id from users where device_id='~s' and user_type='~s';", [DeviceId, UserType]),
    case pgsql_conn_pool_query:squery(Sql) of
        {ok, _, Rows} ->
            if
                length(Rows) > 0 ->
                    [Row | _] = Rows,
                    {UserIdBin} = Row,
                    UserId = binary_to_list(UserIdBin),
                    {ok, UserId};
                length(Rows) =:= 0 ->
                    {error, not_found}
            end;
        _ ->
            {error, pgsql_error}
    end.

create_guest_user(UserName, Gender, DeviceName, OsName, OsVersion, DeviceId) ->
    UserId = data_convert:number_to_string(random_generator:random_number()),
    UserType = ?GUEST_USER_TYPE,
    Sql = data_format:format(
        "insert into users(
            user_id, user_name, gender,device_name,os_name,os_version,device_id,user_type
            )
        values (
            '~s','~s','~s','~s','~s','~s','~s','~s'
            );",
        [UserId, UserName, Gender, DeviceName, OsName, OsVersion, DeviceId, UserType]),
    case pgsql_conn_pool_query:squery(Sql) of
        {ok, _} ->
            {ok, UserId};
        _ ->
            {error, pgsql_error}
    end.

get_registered_user_by_username_password(UserName, Password) ->
    UserType = ?REGISTER_USER_TYPE,
    Sql = data_format:format("select user_id from users where user_name='~s' and password='~s' and user_type='~s';",
        [UserName, Password, UserType]),

    case pgsql_conn_pool_query:squery(Sql) of
        {ok, _, Rows} ->
            if
                length(Rows) > 0 ->
                    [Row | _] = Rows,
                    {UserIdBin} = Row,
                    UserId = binary_to_list(UserIdBin),
                    {ok, UserId};
                length(Rows) =:= 0 ->
                    {error, not_found}
            end;
        _ ->
            {error, pgsql_error}
    end.

get_registered_user_by_username(UserName) ->
    UserType = ?REGISTER_USER_TYPE,
    Sql = data_format:format("select user_id from users where user_name='~s' and user_type='~s';", [UserName, UserType]),
    case pgsql_conn_pool_query:squery(Sql) of
        {ok, _, Rows} ->
            if
                length(Rows) > 0 ->
                    [Row | _] = Rows,
                    {UserIdBin} = Row,
                    UserId = binary_to_list(UserIdBin),
                    {ok, UserId};
                length(Rows) =:= 0 ->
                    {error, not_found}
            end;
        _ ->
            {error, pgsql_error}
    end.

create_registered_user(UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId) ->
    UserId = data_convert:number_to_string(random_generator:random_number()),
    UserType = ?REGISTER_USER_TYPE,
    Sql = data_format:format(
        "insert into users(
            user_id, user_name, password, gender, device_name, os_name, os_version, device_id, user_type
            )
        values (
            '~s','~s','~s','~s','~s','~s','~s','~s','~s'
            );",
        [UserId, UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId, UserType]),
    case pgsql_conn_pool_query:squery(Sql) of
        {ok, _} ->
            {ok, UserId};
        _ ->
            {error, pgsql_error}
    end.

change_guest_to_registered_user(UserId, UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId) ->
    GuestUserType = ?GUEST_USER_TYPE,
    RegisteredUserType = ?REGISTER_USER_TYPE,
    Sql = data_format:format(
        "update users set
            user_name='~s',
            password='~s',
            gender='~s',
            device_name='~s',
            os_name='~s',
            os_version='~s',
            device_id='~s',
            user_type='~s'
        where user_id='~s' and user_type='~s';",
        [UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId, RegisteredUserType, UserId, GuestUserType]),
    case pgsql_conn_pool_query:squery(Sql) of
        {ok, _} ->
            {ok, UserId};
        _ ->
            {error, pgsql_error}
    end.

update_registered_user_info(UserId, UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId) ->
    UserType = ?REGISTER_USER_TYPE,
    Sql = data_format:format(
        "update users set
            user_name='~s',
            password='~s',
            gender='~s',
            device_name='~s',
            os_name='~s',
            os_version='~s',
            device_id='~s'
        where user_id='~s' and user_type='~s';",
        [UserName, Password, Gender, DeviceName, OsName, OsVersion, DeviceId,
            UserId, UserType]),
    case pgsql_conn_pool_query:squery(Sql) of
        {ok, _} ->
            {ok, UserId};
        _ ->
            {error, pgsql_error}
    end.

%% 版本信息帮助方法
get_latested_version_info(Platform, AppId) ->
    Cmd = data_format:format("select * from app_versions where platform='~s' and app_id='~s';", [Platform, AppId]),
    case pgsql_conn_pool_query:squery(Cmd) of
        {ok, _, Rows} ->
            if
                length(Rows) > 0 ->
                    [Row | _] = Rows,
                    {_, _PlatformBin, _AppIdBin, LatestedVersionBin, UrlBin} = Row,
                    LatestedVersion = data_convert:string_to_number(binary_to_list(LatestedVersionBin)),
                    Url = binary_to_list(UrlBin),
                    {ok, {LatestedVersion, Url}};
                length(Rows) =:= 0 ->
                    {error, not_found}
            end;
        _ ->
            {error, pgsql_error}
    end.