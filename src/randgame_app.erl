-module(randgame_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).
-export([play/1
	,new_game/1
	,play_resolve/0
	,play_resolve/1
				]).

new_game(Num) ->
	ets:new(numbers, [set,public,named_table]),
	ets:new(max_num,[set,public,named_table]),
	ets:new(min_num,[set,public,named_table]),
	ets:new(scores, [set,public,named_table]),
	Rand = random:uniform(Num),
	ets:insert(max_num,{Num}),
	ets:insert(min_num,{0}),
	ets:insert(numbers,{Rand}),
	ets:insert(scores, {0}).

play(Numero) ->
	Rand = ets:last(numbers),
	Score = ets:last(scores),
	ets:delete(scores,Score),
	ets:insert(scores, {Score+1}),
	if
		Numero > Rand ->
			io:format("retry : ~p is too high ~n",[Numero]);
		Numero < Rand ->
			io:format("retry : ~p is too low ~n",[Numero]);
		Numero == Rand ->
			io:format("#############################~n#          YOU WIN          #~n#    The Number was ~p   #~n#         Score = ~p        #~n#############################~n",[Rand,Score+1]),
			ets:delete(numbers),
			ets:delete(max_num),
			ets:delete(min_num),
			ets:delete(scores)
	end.

play_resolve() ->
	Rand = ets:last(numbers),
	Score = ets:last(scores),
	Max = ets:last(max_num),
	Min = ets:last(min_num),
	ets:delete(scores,Score),
	ets:insert(scores, {Score+1}),
	Temp = Max - Min,
	Numero = Temp div 2,
	if
		Numero > Rand ->
			io:format("retry : ~p is too high ~n",[Numero]),
			ets:delete(max_num,Max),
			ets:insert(max_num,{Numero}),
			play_resolve(Numero);
		Numero < Rand ->
			io:format("retry : ~p is too low ~n",[Numero]),
			ets:delete(min_num,Min),
			ets:insert(min_num,{Numero}),
			play_resolve(Numero);
		Numero == Rand ->
			io:format("#############################~n#          YOU WIN          #~n#    The Number was ~p   #~n#         Score = ~p        #~n#############################~n",[Rand,Score+1]),
			ets:delete(numbers),
			ets:delete(max_num),
			ets:delete(min_num),
			ets:delete(scores)
	end.
	

play_resolve(Numero) ->
	Rand = ets:last(numbers),
	Score = ets:last(scores),
	Max = ets:last(max_num),
	Min = ets:last(min_num),
	ets:delete(scores,Score),
	ets:insert(scores, {Score+1}),
	Temp = Max - Min,
	Num = Temp div 2,
	Numero2 = Min + Num,
	if
		Numero > Rand ->
			io:format("retry : ~p is too high ~n",[Numero]),
			ets:delete(max_num,Max),
			ets:insert(max_num,{Numero}),
			play_resolve(Numero2);
		Numero < Rand ->
			io:format("retry : ~p is too low ~n",[Numero]),
			ets:delete(min_num,Min),
			ets:insert(min_num,{Numero}),
			play_resolve(Numero2);
		Numero == Rand ->
			io:format("#############################~n#          YOU WIN          #~n#    The Number was ~p   #~n#         Score = ~p        #~n#############################~n",[Rand,Score div 2]),
			ets:delete(numbers),
			ets:delete(max_num),
			ets:delete(min_num),
			ets:delete(scores)
	end.



start(_StartType, _StartArgs) ->
    randgame_sup:start_link().

stop(_State) ->
    ok.
