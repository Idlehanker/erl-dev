-module(simple).
-export([start/0, alloc/0, free/1, init/0]).

%% spawn(Module, Function, Args) -> pid()
%% Types
%% Module = module()
%% Function = atom()
%% Args = [term()]
%% 
%% Returns the process identifier of a new process started by the application of Module:Function to Args.
%% error_handler:undefined_function(Module, Function, Args) is evaluated by the new process if
%% Module:Function/Arity does not exist (where Arity is the length of Args). 
%% 
%% The error handler can be redefined (see process_flag/2). If error_handler is undefined, 
%% or the user has redefined the default error_handler and its replacement is undefined, 
%% a failure with reason undef occurs.
%% 
%% return Process ID from this function
start() ->
    spawn(simple, init, []).


%% register(RegName, PidOrPort) -> true
%% Types
%% 
%% RegName = atom()
%% PidOrPort = port() | pid()

%% Associates the name RegName with a process identifier (pid) or a port identifier. 
%% RegName, which must be an atom, can be used instead of the pid or port identifier 
%% in send operator (RegName ! Message).
init()->
    register(simple, self()), % is't Link? Maybe
    Chs = channels(),
    loop(Chs).


loop(Chs) ->
    receive 
        {From, alloc} ->
            {Ch, Chs2} = alloc(Chs),
            From ! {simple, Ch},
            loop(Chs2);
        {free, Ch} ->
            Chs2 = free(Ch, Chs),
            loop(Chs2)
    end.


%% self() -> pid()
%% Returns the process identifier of the calling process, for example:
%% 
alloc() ->
    simple ! {self(), alloc},
    receive
        {simple, Res} ->
            Res
    end.

free(Ch) ->
    Ch ! {free, Ch},
    ok.


%%====================================
channels() ->
    {_Allocated  = [], _Free = lists:seq(1,100)}.

alloc({Allocated, [H|T] = _Free}) ->
    {H, {[H|Allocated], T}}.

free(Ch, {Alloc, Free}  = Channels) ->
    case lists:member(Ch, Alloc) of
        true ->
            {lists:delete(Ch, Alloc), [Ch|Free]};
        false ->
            Channels
    end.
