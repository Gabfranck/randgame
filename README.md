# Randgame

## Installation

 $ git clone git@github.com:Gabfranck/randgame.git

 install rebar https://github.com/basho/rebar

## Usage 

 $ rebar compile
 $ rebar shell

real play :

```erlang
randgame_app:new_game(int).
randgame_app:play(int).
```

auto resolve :

```erlang
randgame_app:play_resolve().
```
