-module(db_data_type_SUITE).
-include_lib("common_test/include/ct.hrl").

-export([suite/0,all/0,
        init_per_suite/1, end_per_suite/1,
        init_per_testcase/2, end_per_testcase/2]).

-export([string/1, integer/1]).
-define(CONNECT_STR, "DSN=sqlserver;UID=alladin;PWD=sesame").


suite() ->
    [{timetrap, {minutes, 1}}].

init_per_suite(Config) ->
    {ok, Ref} = db:connect(?CONNECT_STR, []),
    TableName =  db_lib:unique_table_name(),
    [{con_ref, Ref}, {table_name, TableName} | Config].


end_per_suite(Config) -> 
    Ref = ?config(con_ref, Config),
    db:disconnect(Ref),
    ok.

init_per_testcase(Case, Config) ->
    Ref = ?config(config_ref, Config),
    TableName = ?config(table_name, Config),
    ok = db:create_table(Ref, TableName, table_type(Case)),
    Config.

end_per_testcase(_Case, Config) -> 
    Ref = ?config(conf_ref, Config),
    TableName = ?config(table_name, Config),
    ok = db:delete_table(Ref, TableName),
    ok.

all()->
    [string, integer].

string(Config) ->
    insert_and_lookup(dummy_key, "Dummy string", Config).
integer(Config) ->
    insert_and_lookup(dummy_key, 42, Config).

insert_and_lookup(Key, Value, Config) ->
    Ref = ?config(con_ref, Config),
    TableName = ?config(table_name, Config),
    ok = db:insert(Ref, TableName, Key, Value),
    [Value] = db:lookup(Ref, TableName, Key),
    ok = db:delete(Ref, TableName, Key),
    [] = db:lookup(Ref, TableName, Key),
    ok.
