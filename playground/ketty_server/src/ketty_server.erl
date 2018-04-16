-module(ketty_server).
-export([start_link/0,order_cat/4, return_cat/2,close_shop/1]).

-record(cat, {name, color=green, description}).

% asynchronous calling
return_cat(Pid, Cat = #cat{})->
    Pid ! {return, Cat},
    ok.

% Synchronous calling
order_cat(Pid, Name, Color, Description) ->
    Ref = erlang:monitor(process, Pid),
    Pid ! {self(), Ref, {order, Name, Color, Description}},
    receive
        {Ref, Cat = #cat{}} ->
            erlang:demonitor(Ref,[flush]),
            Cat;
        {'DOWN', Ref, process, Pid, Reason} ->
            erlang:error(Reason)
    after 5000 ->
        erlang:error(timeout)
    end.

% Synchronous calling
close_shop(Pid) ->
    Ref = erlang:monitor(process, Pid),
    Pid ! {self(), Ref, terminate},
    receive 
        {Ref, ok} -> 
            erlang:demonitor(Ref, [flush]),
            ok;
        {'DOWN', Ref, process, Pid, Reason} ->
            erlang:error(Reason)
    after 5000 ->
        erlang:error(timeout)
    end.

% start-link
% ========================================================================================
% Client API
%% spawn_link(Fun) -> pid() Returns the process identifier of a new process started by the application of Fun to the empty list []. A link is created between the calling process and the new process, atomically. Otherwise works like spawn/3.
start_link()->spawn_link(fun init/0).

% Server function
init() -> loop([]).

loop(Cats) -> 
    receive 
        {Pid, Ref, {order, Name, Color, Description}} -> 
            if Cats =:= [] ->
                Pid ! {Ref, make_cat(Name, Color, Description)},
                loop(Cats);
                Cats =/= [] ->
                Pid ! hd(Cats),
                loop(tl(Cats))
            end;
        {return, Cat = #cat{}} ->
            loop([Cat|Cats]);
        {Pid, Ref, terminate} ->
            Pid ! {Ref, ok},
            terminate(Cats);
        Unknown ->
            io:format("Unknown message ~p~n", [Unknown]),
            loop(Cats)
    end.

% Private functions
% make_cat(Pid, Cat = #cat{}) -> 
%     Pid ! {return, Cat},
%     ok.
make_cat(Name, Color, Desc) -> 
    #cat{name=Name, color=Color, description=Desc}.

terminate(Cats) ->
    [io:format("~p was set free.~n",[C#cat.name]) || C <- Cats], % What about '[C#cat.name]' and 'C <- Cats' ? 
    ok.
