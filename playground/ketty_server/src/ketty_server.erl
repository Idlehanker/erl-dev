-module(ketty_server).
-export([start_link/0]).

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
        {Ref, Cat=#cat{}} ->
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
