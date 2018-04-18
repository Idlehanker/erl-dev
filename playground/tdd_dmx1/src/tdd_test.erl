-include_lib("eunit/include/eunit.hrl").

reverse_test()-> lists:reverse([1,2,3]).

% test
reverse_nil_test() -> [] == lists:reverse([]).
reverse_one_test() -> [1] == lists:reverse([1]).
reverse_two_test() -> [2,1] == lists:reverse([1,2]).


% 
length_test() -> ?assert(length([1,2,3]) =:= 3).

% 
basic_test() -> 
    fun() -> ?assert( 1 + 1 =:= 2) end.

simple_test() -> 
    ?assert( 1+1 =:= 2).

% print row-number
basic_test() -> 
    ?_test(?assert(1+1 =:= 2)).

basic_test() ->
    ?_assert(1+1 =:= 2).
    