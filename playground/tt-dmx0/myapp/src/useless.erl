-module(useless).%this line required

% -export([hello/0]). %This is optional
-export([add/2, greet/2, greet_and_add_two/1, hello/0,
	 oh_god/1, tail_fac/1, tail_fac/2, len/1, tail_len/1,tail_len/2]).

add(A, B) -> A + B.

hello() -> io:format("Hello World!~n").

greet_and_add_two(X) -> hello(), add(X, 2).

% greet_and_add_two(3).

% function greet ( Gender , Name )
%     if Gender == male then
%         print ( "Hello, Mr. %s!" , Name )
%     else if Gender == female then
%         print ( "Helo, Mrs. %s!" , Name )
%     else
%         print ( "Hello , %s!" , Name )
% end
greet(name, Name) ->
    io:format("Hello, Mr. ~s!", [Name]);
greet(female, Name) ->
    io:format("Hello, Mrs. ~s!", [Name]);
greet(_, Name) -> io:format("Hello, ~s!", [Name]).

% erlang if-else cause
oh_god(N) ->
    if N =:= 2 ->
	   might_sucessed; %io:format("~p is equal 2",N);
       true -> always_does %io:format("~p is not equal 2",N)
    end.

% tail-recursion
tail_fac(N) -> tail_fac(N, 1).

tail_fac(0, Acc) -> Acc;
tail_fac(N, Acc) -> tail_fac(N - 1, N * Acc).


% normal recursion/ culculate List len
len([]) -> 0;
len([_|T]) -> 1 + len(T).

% tail recursion
tail_len(L) -> tail_len(L,0).

tail_len([], Acc) -> Acc;
tail_len([_|T], Acc) -> tail_len(T, Acc+1).
