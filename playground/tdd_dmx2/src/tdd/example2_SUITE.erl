-module(example2_SUITE).
-compile(export_all).
-include("common_test/include/ct.hrl").

suite() ->
    [{timetrap, {seconds, 30}}].

init_per_suite(Config) ->
    Config.

end_per_suite(_Config) ->
    ok.



init_per_group(_GroupName, Config) ->
    Config.

end_per_group(_GroupName, _Config) ->
    ok.


init_per_testcase(_TestCase, Config) ->
    Config.
end_per_testcase(_TestCase, _Config) ->
    ok.

groups() ->
    [].

all() ->
    [my_test_case].
my_test_case() ->
    [].
my_test_case(_Config) ->
    ok.
    