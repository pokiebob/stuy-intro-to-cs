globals [
  computer-score player-score wins losses
  warm-up? playing? serving? ball-moving? game-over? setup?
  pswinging? cswinging?
  pleft? pmiddle? pright?
  cleft? cmiddle? cright?
  serving-x ball-x
  pmove-counter cmove-counter
  pswing-counter cswing-counter
  intro-counter
  cmove creturn?
]
breed [computers computer]
breed [tables table]
breed [balls ball]
breed [players player]

to setup1
  ct cp cd
  set intro-counter 0
  ittf-logo
  wait 1
  setup-mat
  surprise-loop
  set setup? 1
end

to setup2
  ct cp cd
  setup-mat
  setup-table
  readyplayer
  readycomputer
  setup-ball
  set pmove-counter -10 set cmove-counter -10
  set player-score 0 set computer-score 0
  set pswinging? 0 set cswinging? 0
  set pleft? 0 set cleft? 0
  set pmiddle? 0 set cmiddle? 0
  set pright? 0 set cright? 0
  set pswing-counter 0 set cswing-counter 0
  set serving-x -14
  set ball-x -5
  set cmove 3
  set warm-up? -1
  set playing? 0
  set serving? 0
  set ball-moving? 0
  set game-over? 0
  set creturn? 0
  set setup? 0
end

to go
  if setup? = 1 [
    setup2
    set setup? 0
  ]
  if warm-up? = 1 [
    set computer-consistency 100
  ]
  if (player-score >= 11 or computer-score >= 11)
  and (abs (player-score - computer-score) >= 2)
  and warm-up? = 0
  [set game-over? 1]
  if playing? = 0 and not (warm-up? = -1) [
    set serving-x -14
    if warm-up? = 0 [score]
    ifelse player-score <= 10 and computer-score <= 10 [
      ifelse (player-score + computer-score) mod 4 < 2 [
        pserve-ready
      ]
      [
        cserve-ready
        wait 2
        set serving? 1
      ]
    ]
    [ifelse (player-score + computer-score) mod 2 = 0 [
      pserve-ready
      ]
      [
        cserve-ready
        wait 2
        set serving? 1
      ]
    ]
  ]
  if serving? = 1 [
    set cmove 3
    set cright? 0
    set cmiddle? 0
    set cleft? 0
    set cswing-counter 0
    set cmove-counter -10
    set pswinging? 0 set cswinging? 0
    ifelse player-score <= 10 and computer-score <= 10 [
      ifelse (player-score + computer-score) mod 4 < 2
      [pserve]
      [cserve]
    ]
    [ifelse (player-score + computer-score) mod 2 = 0
      [pserve]
      [cserve]
    ]
  ]
  if playing? = 1 [
    if serving? = 0 [
      pmove-left cmove-left
      pmove-middle cmove-middle
      pmove-right cmove-right
      pforehand cforehand
      wheeeee
      if creturn? = 1
      [
        if cmove = 0 and not ([xcor] of computer 2 = 5) [print "left" set cleft? 1 set cmiddle? 0 set cright? 0]
        if cmove = 1 and not ([xcor] of computer 2 = 0) [print "middle" set cleft? 0 set cmiddle? 1 set cright? 0]
        if cmove = 2 and not ([xcor] of computer 2 = -5) [print "right" set cleft? 0 set cmiddle? 0 set cright? 1]
        set cmove 3
        if ball-x > 5 - .1 * slow-motion-goggles
        and ([ycor] of ball 3 > 5)
        and (random 100 < computer-consistency)
        [
          ifelse warm-up? = 0
          [
            ifelse random 3 = 0
            [caim-left]
            [ifelse random 2 = 0
              [caim-middle]
              [caim-right]
            ]
          ]
          [if [xcor] of player 1 = -5 [caim-left]
            if [xcor] of player 1 = 0 [caim-middle]
            if [xcor] of player 1 = 5 [caim-right]
          ]
          set cswinging? 1
          set creturn? 0
        ]
      ]
    ]
  ]
  if game-over? = 1 [
    set playing? 0
    set serving? 0
    ask players [die]
    ask computers [die]
    ask tables [set size 30]
    ask balls [set size 2]
    un-score
    ask patch 8 14 [
      set plabel-color black
      ifelse player-score > computer-score
      [set wins wins + 1 set plabel "YOU WIN"]
      [set losses losses + 1 set plabel "YOU LOSE"]
    ]
    stop
  ]
  wait .025
end

to wheeeee
  if ball-moving? = 1 [
    ask balls [
      fd ball-velocity (10 + abs (.025 * (.8 * slow-motion-goggles))) * (50 - (.8 * slow-motion-goggles)) * 3 / 20000
      set ball-x ball-x + (.015 * (50 - (.8 * slow-motion-goggles)))
    ]
  ]
  ask balls [
    if (ball-x > -.25 and ball-x < .25 and ycor > -.25 and ycor < .25) [
      ifelse (heading > 90 and heading < 270)
      [set player-score player-score + 1]
      [set computer-score computer-score + 1]
      wait 1
      set playing? 0
      set ball-moving? 0
    ]
    if abs ycor > 10 [
      ifelse (heading > 90 and heading < 270)
      [set computer-score computer-score + 1]
      [set player-score player-score + 1]
      wait 1
      set playing? 0
      set ball-moving? 0
    ]
  ]
end

to paim-left
  if  (pswinging? = 0)
  and (ball-x > 0)
  and ([ycor] of ball 3 < -4)
  and ([xcor] of ball 3 > [xcor] of player 1 - 3)
  and ([xcor] of ball 3 < [xcor] of player 1 + 3)
  [
    set ball-x -5
    ask balls [
      facexy -4 6
    ]
  ]
  set cmove 2
end

to paim-middle
  if  (pswinging? = 0)
  and (ball-x > 0)
  and ([ycor] of ball 3 < -4)
  and ([xcor] of ball 3 > [xcor] of player 1 - 3)
  and ([xcor] of ball 3 < [xcor] of player 1 + 3)
  [
    set ball-x -5
    ask balls [
      facexy 0 6
    ]
  ]
  set cmove 1
end

to paim-right
  if  (pswinging? = 0)
  and (ball-x > 0)
  and ([ycor] of ball 3 < -4)
  and ([xcor] of ball 3 > [xcor] of player 1 - 3)
  and ([xcor] of ball 3 < [xcor] of player 1 + 3)
  [
    set ball-x -5
    ask balls [
      facexy 4 6
    ]
  ]
  set cmove 0
end

to caim-left
  if  (cswinging? = 0)
  and ([ycor] of ball 3 > 0)
  [
    set ball-x -5
    ask balls [
      facexy -4 -6
    ]
  ]
end

to caim-middle
  if  (cswinging? = 0)
  and ([ycor] of ball 3 > 0)
  [
    set ball-x -5
    ask balls [
      facexy 0 -6
    ]
  ]
end

to caim-right
  if  (cswinging? = 0)
  and ([ycor] of ball 3 > 0)
  [
    set ball-x -5
    ask balls [
      facexy 4 -6
    ]
  ]
end

to-report ball-velocity [h]
  report (ball-x - h) ^ 2
end

to pforehand
  if pswinging? = 1 [
    ask players [
      if pswing-counter = 0 [set xcor xcor - 5]
      ifelse pswing-counter <= 9
      [set shape insert-item 9 "forehand0" (word pswing-counter)
        set pswing-counter pswing-counter + 1]
      [set pswinging? 0 set pswing-counter 0 set shape "waiting0" set xcor xcor + 5]
    ]
  ]
end

to cforehand
  if cswinging? = 1 [
    ask computers [
      if cswing-counter = 0 [set xcor xcor + 5]
      ifelse cswing-counter <= 9
      [set shape insert-item 9 "forehand1" (word cswing-counter)
        set cswing-counter cswing-counter + 1]
      [set cswinging? 0 set cswing-counter 0 set shape "waiting1" set xcor xcor - 5]
    ]
  ]
end

to pserve
  set serving-x serving-x + 1
  ask balls [
    ifelse serving-x < 0 [
      set ycor ycor + serving-velocity (0) / 50
    ]
    [set ycor ycor - serving-velocity (0) / 50]
    if (serving-x = 14) [
      set serving-x -14
      setxy -.5 -5
      set serving? 0
      set ball-moving? 1
      set ball-x -5
    ]
  ]
  ask players [
    if serving-x < -8 [
      set shape "sparkle"
      set size size - 2
    ]
    if serving-x > 8 [
      set shape "sparkle"
      set size size + 2
    ]
    if serving-x = -14
    [
      set shape "waiting0"
      set size 10
    ]
  ]
end

to cserve
  un-score
  set playing? 1
  set serving-x serving-x + 1
  ask balls [
    ifelse serving-x < 0 [
      set ycor ycor + serving-velocity (0) / 100
    ]
    [set ycor ycor - serving-velocity (0) / 100]
    if (serving-x = 14) [
      set serving-x -14
      setxy -.5 7
      set serving? 0
      set ball-moving? 1
      set ball-x -5
    ]
  ]
  ask computers [
    if serving-x < -8 [
      set shape "sparkle"
      set size size - 2
    ]
    if serving-x > 8 [
      set shape "sparkle"
      set size size + 2
    ]
    if serving-x = -14
    [
      set shape "waiting1"
      set size 10
    ]
  ]
end

to-report serving-velocity [h]
  report (serving-x - h ) ^ 2
end

to pserve-ready
  ask players [
    set shape "serving0"
    set xcor -5
    set color black
    set size 10
  ]
  ask computers [
    set shape "waiting1"
    set xcor 5
    set size 10
  ]
  ask balls [
    setxy -.5 -5
  ]
end

to cserve-ready
  ask computers [
    set shape "serving1"
    set xcor 5
    set color black
    set size 10
  ]
  ask players [
    set shape "waiting0"
    set xcor -5
    set size 10
  ]
  ask balls [
    setxy .5 7
    ifelse warm-up? = 0 [
      ifelse random 3 = 0
      [caim-left]
      [ifelse random 2 = 0
        [caim-middle]
        [caim-right]
      ]
    ]
    [if [xcor] of player 1 = -5 [caim-left]
      if [xcor] of player 1 = 0 [caim-middle]
      if [xcor] of player 1 = 5 [caim-right]
    ]
  ]
  set ball-x -5
end

to pmove-left
  if pleft? = 1 [
    ask players [
      if pmove-counter = -10 [set size 10]
      set shape "sparkle"
      set pmove-counter pmove-counter + 2
      ifelse pmove-counter <= 0 [ask players [set size size - 2]] [ask players [set size size + 2]]
      if pmove-counter = 10 [ask players [set size 10 set shape "waiting0" set pmove-counter -10 set pleft? 0]]
      if pmove-counter = 0 [
        set xcor -5
      ]
    ]
  ]
end

to pmove-middle
  if pmiddle? = 1 [
    ask players [
      if pmove-counter = -10 [set size 10]
      set shape "sparkle"
      set pmove-counter pmove-counter + 2
      ifelse pmove-counter <= 0 [ask players [set size size - 2]] [ask players [set size size + 2]]
      if pmove-counter = 10 [ask players [set size 10 set shape "waiting0" set pmove-counter -10 set pmiddle? 0]]
      if pmove-counter = 0 [
        set xcor 0
      ]
    ]
  ]
end

to pmove-right
  if pright? = 1 [
    ask players [
      if pmove-counter = -10 [set size 10]
      set shape "sparkle"
      set pmove-counter pmove-counter + 2
      ifelse pmove-counter <= 0 [ask players [set size size - 2]] [ask players [set size size + 2]]
      if pmove-counter = 10 [ask players [set size 10 set shape "waiting0" set pmove-counter -10 set pright? 0]]
      if pmove-counter = 0 [
        set xcor 5
      ]
    ]
  ]
end

to cmove-left
  if cleft? = 1 [
    ask computers [
      if cmove-counter = -10 [set size 10]
      set shape "sparkle"
      set cmove-counter cmove-counter + 2
      ifelse cmove-counter <= 0 [ask computers [set size size - 2]] [ask computers [set size size + 2]]
      if cmove-counter = 10 [ask computers [set size 10 set shape "waiting1" set cmove-counter -10 set cleft? 0]]
      if cmove-counter = 0 [
        set xcor 5
      ]
    ]
  ]
end

to cmove-middle
  if cmiddle? = 1 [
    ask computers [
      if cmove-counter = -10 [set size 10]
      set shape "sparkle"
      set cmove-counter cmove-counter + 2
      ifelse cmove-counter <= 0 [ask computers [set size size - 2]] [ask computers [set size size + 2]]
      if cmove-counter = 10 [ask computers [set size 10 set shape "waiting1" set cmove-counter -10 set cmiddle? 0]]
      if cmove-counter = 0 [
        set xcor 0
      ]
    ]
  ]
end

to cmove-right
  if cright? = 1 [
    ask computers [
      if cmove-counter = -10 [set size 10]
      set shape "sparkle"
      set cmove-counter cmove-counter + 2
      ifelse cmove-counter <= 0 [ask computers [set size size - 2]] [ask computers [set size size + 2]]
      if cmove-counter = 10 [ask computers [set size 10 set shape "waiting1" set cmove-counter -10 set cright? 0]]
      if cmove-counter = 0 [
        set xcor -5
      ]
    ]
  ]
end

to laimstuff
  ifelse playing? = 0 [
    ifelse player-score <= 10 and computer-score <= 10 [
      if (player-score + computer-score) mod 4 < 2 [
        set playing? 1 set serving? 1 set cmove 2 pserve-ready
        un-score set ball-x -5
        ask balls [
          facexy -4 6
        ]
        ifelse random 100 < computer-consistency
        [set creturn? 1]
        [set creturn? 0]
      ]
    ]
    [if (player-score + computer-score) mod 2 = 0 [
      set playing? 1 set serving? 1 set cmove 2 pserve-ready
      un-score set ball-x -5
      ask balls [
        facexy -4 6
      ]
      ifelse random 100 < computer-consistency
      [set creturn? 1]
      [set creturn? 0]
      ]
    ]
  ]
  [
    paim-left
    set pswinging? 1
    ifelse random 100 < computer-consistency
    [set creturn? 1]
    [set creturn? 0]
  ]
end

to maimstuff
  ifelse playing? = 0 [
    ifelse player-score <= 10 and computer-score <= 10 [
      if (player-score + computer-score) mod 4 < 2 [
        set playing? 1 set serving? 1 set cmove 2 pserve-ready
        un-score set ball-x -5
        ask balls [
          facexy 0 6
        ]
        ifelse random 100 < computer-consistency
        [set creturn? 1]
        [set creturn? 0]
      ]
    ]
    [if (player-score + computer-score) mod 2 = 0 [
      set playing? 1 set serving? 1 set cmove 2 pserve-ready
      un-score set ball-x -5
      ask balls [
        facexy 0 6
      ]
      ifelse random 100 < computer-consistency
      [set creturn? 1]
      [set creturn? 0]
      ]
    ]
  ]
  [
    paim-middle
    set pswinging? 1
    ifelse random 100 < computer-consistency
    [set creturn? 1]
    [set creturn? 0]
  ]
end

to raimstuff
  ifelse playing? = 0 [
    ifelse player-score <= 10 and computer-score <= 10 [
      if (player-score + computer-score) mod 4 < 2 [
        set playing? 1 set serving? 1 set cmove 2 pserve-ready
        un-score set ball-x -5
        ask balls [
          facexy 4 6
        ]
        ifelse random 100 < computer-consistency
        [set creturn? 1]
        [set creturn? 0]
      ]
    ]
    [if (player-score + computer-score) mod 2 = 0 [
      set playing? 1 set serving? 1 set cmove 2 pserve-ready
      un-score set ball-x -5
      ask balls [
        facexy 4 6
      ]
      ifelse random 100 < computer-consistency
      [set creturn? 1]
      [set creturn? 0]
      ]
    ]
  ]
  [
    paim-right
    set pswinging? 1
    ifelse random 100 < computer-consistency
    [set creturn? 1]
    [set creturn? 0]
  ]
end

to score
  ask patch 0 12 [set plabel-color black set plabel (word computer-score)]
  ask patch 0 -12 [set plabel-color black set plabel (word player-score)]
end

to un-score
  ask patch 0 12 [set plabel-color black set plabel ""]
  ask patch 0 -12 [set plabel-color black set plabel ""]
end

to setup-table
  create-tables 1 [
    set heading 0
    set shape "table"
    set size 16
    set color 107
  ]
end

to setup-ball
  create-balls 1 [
    set shape "ball"
    setxy -.5 -5
  ]
end

to setup-mat
  ask patches [
    set pcolor 18 - (.1 * distancexy 0 0)
  ]
end

to readyplayer
  create-players 1 [
    set heading 0
    set shape "waiting0"
    set size 10
    set color black
    setxy -5 -6
  ]
end

to readycomputer
  create-computers 1 [
    set heading 0
    set shape "waiting1"
    set size 10
    set color black
    setxy 5 6
  ]
end

to ittf-logo
  cro 1 [
    set size 32
    repeat 10 [
      set shape insert-item 17 "ittf world tour 0" (word intro-counter)
      set intro-counter intro-counter + 1
      wait .1
    ]
    set shape "ittf world tour 10"
    set color black
    wait 1
    repeat 10 [
      set intro-counter intro-counter - 1
      set shape insert-item 17 "ittf world tour 0" (word intro-counter)
      set size size - 4
      wait .1
    ]
    die
  ]
end

to surprise-loop
  set intro-counter 0
  create-computers 1 [
    set heading 0
    set color black
    set size 0
    set shape "sparkle"
    repeat 10 [set size size + 3 wait .025]
    set shape "waiting1"
  ]
  wait .5
  create-balls 1 [
    set xcor -10
    set shape "ball"
    hide-turtle
  ]
  repeat 10 [
    ask computers [
      set shape insert-item 9 "forehand1" (word intro-counter)
      set intro-counter intro-counter + 1
    ]
    ask balls [
      if intro-counter >= 3 [
        show-turtle
        set size size + 1
        set xcor xcor + .2
      ]
    ]
    wait .05
  ]
  ask computers [set shape "waiting1"]
  ask balls [
    repeat 24 [set size size + 1 set xcor xcor + .35 wait .01]
  ]
  cro 1 [
    set color white
    set xcor 8
    set label-color black
    set label "PRESS GO"
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
50
1
1
1
0
0
0
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
15
10
96
100
SETUP
setup1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
108
10
196
100
GO
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
13
332
68
365
LEFT
ask players [if not (xcor = -5) [set pleft? 1]]
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
74
332
129
365
MIDDLE
ask players [if not (xcor = 0) [set pmiddle? 1]]
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
135
333
190
366
RIGHT
ask players [if not (xcor = 5) [set pright? 1]]
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

TEXTBOX
19
307
169
325
MOVING KEYS
11
0.0
1

TEXTBOX
22
386
172
404
AIMING KEYS
11
0.0
1

BUTTON
16
411
71
444
LEFT
if setup? = 0 [set pswing-counter 0 laimstuff]
NIL
1
T
OBSERVER
NIL
J
NIL
NIL
1

BUTTON
76
411
131
444
MIDDLE
if setup? = 0 [set pswing-counter 0 maimstuff]
NIL
1
T
OBSERVER
NIL
K
NIL
NIL
1

BUTTON
135
411
190
444
RIGHT
if setup? = 0 [set pswing-counter 0 raimstuff]
NIL
1
T
OBSERVER
NIL
L
NIL
NIL
1

SLIDER
16
223
188
256
computer-consistency
computer-consistency
0
100
75.0
1
1
NIL
HORIZONTAL

SLIDER
15
265
187
298
slow-motion-goggles
slow-motion-goggles
-50
50
50.0
1
1
NIL
HORIZONTAL

BUTTON
15
150
95
215
WARM UP
if (computer-score + player-score) = 0\n[set warm-up? 1]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
103
150
189
216
START GAME
set warm-up? 0\nset computer-score 0\nset player-score 0\nset computer-consistency 75
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
682
14
791
115
WINS
wins
17
1
25

MONITOR
683
131
791
232
LOSSES
losses
17
1
25

@#$#@#$#@
## DESCRIPTION

If you don't know how ping pong works, try to hit the ball onto the other side of the table!

Computer-consistency determines the likelyhood that the computer will hit the ball.
Slow-motion-goggles allow you to adjust the speed at which the ball moves (greater value equals slower speed).

To start, press setup, and then go.
If you want to get used to hitting the ball, press warm up. During the warm up, the computer will have 100 consistency and it will always return the ball to where you are.
Press Start Game whenever you are ready. Now the computer will hit the ball randomly!

Alter the consistency and slow-motion goggles as you improve... Challenge yourself!

## RULES

Serves alternate by two per person. If you hit the ball too late, you may hit the net and you will lose the point.

First to 11 points wins! If the score is tied at 10-10, the game will be based on the deuce system (win-by-two).

## KEYS

Moving:
"A" moves you to the left
"S" moves you to the middle
"D" moves you to the right

Aiming (Hitting the ball):
"J" aims the ball to the left
"K" aims the ball to the middle
"L" aims the ball to the right

## TIPS

Get into the habit of moving and then hitting the ball... you will be more consistent.
If you vary where you hit the ball, it is more likely that the computer will miss.

## NETLOGO FEATURES

Please notice my ITTF World Tour Logo in the beginning :(


## INSPIRATION

Inspiration form the game "Ping Pong King," and Nehemiah Yu for making me co-captain. :D

## CREDITS

Me... I'm lonely
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

ball
true
0
Circle -16777216 true false 0 0 300
Circle -1 true false 30 30 240

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

celebrate00
true
0
Polygon -2674135 true false 164 196
Circle -7500403 true true 137 193 60
Circle -7500403 true true 165 60 120
Circle -1 true false 175 70 100
Polygon -7500403 true true 38 169 135 270 191 200 90 150
Circle -7500403 true true 30 120 60
Circle -1 true false 38 128 44
Polygon -7500403 true true 30 150 60 15 90 30 90 150
Circle -7500403 true true 45 0 60
Circle -1 true false 52 7 46
Circle -7500403 true true 135 195 150
Rectangle -7500403 true true 135 255 255 300
Rectangle -1 true false 146 256 267 300
Polygon -7500403 true true 283 230 245 206 180 225 255 240
Polygon -1 true false 48 167 150 270 185 208 75 150
Polygon -1 true false 38 152 67 17 84 29 81 154
Circle -7500403 true true 240 225 60
Circle -1 true false 247 232 46
Circle -1 true false 144 204 132
Polygon -1 true false 250 218 281 236 235 323 175 218
Rectangle -7500403 true true 255 300 300 255
Rectangle -7500403 true true 255 255 300 300
Polygon -1 true false 255 257
Polygon -1 true false 255 255 293 252 300 300 255 300

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

forehand00
true
0
Polygon -7500403 true true 60 225 45 270 75 270 90 225
Circle -7500403 true true 60 210 30
Polygon -7500403 true true 105 150 60 225 75 240 120 210
Circle -7500403 true true 180 255 30
Circle -7500403 true true 165 195 30
Polygon -7500403 true true 120 210 180 225 180 195 150 180
Polygon -7500403 true true 195 210 210 270 180 270 165 210
Polygon -1 true false 191 208 207 271 185 272 171 218
Circle -1 true false 169 199 22
Circle -7500403 true true 90 150 60
Polygon -7500403 true true 105 116 90 176 150 176 165 116
Circle -7500403 true true 105 90 60
Circle -1 true false 110 95 50
Circle -7500403 true true 45 255 30
Circle -7500403 true true 165 165 30
Circle -2674135 true false 222 207 42
Circle -2674135 true false 229 210 42
Circle -7500403 true true 120 30 60
Circle -1 true false 125 35 50
Circle -7500403 true true 180 105 30
Circle -1 true false 184 259 22
Circle -1 true false 49 259 22
Circle -7500403 true true 207 203 30
Circle -1 true false 64 214 22
Polygon -7500403 true true 195 105 150 135 165 150 195 135
Polygon -1 true false 195 109 153 137 162 146 195 130
Circle -1 true false 184 109 22
Polygon -7500403 true true 165 120 191 170 167 187 115 142
Polygon -1 true false 158 118 189 175 170 185 119 138
Polygon -7500403 true true 180 198 227 230 227 204 191 170
Polygon -1 true false 175 190 227 224 227 209 187 170
Circle -1 true false 169 169 22
Circle -1 true false 211 207 22
Polygon -1 true false 110 120 95 180 145 182 160 120
Polygon -1 true false 121 205 181 221 181 200 144 183
Circle -1 true false 95 155 50
Polygon -1 true false 65 224 49 270 70 271 87 224
Polygon -1 true false 103 163 64 223 81 232 124 201

forehand01
true
0
Circle -7500403 true true 165 105 30
Polygon -7500403 true true 180 105 135 135 150 150 180 135
Polygon -1 true false 180 109 138 137 147 146 180 130
Polygon -7500403 true true 60 225 45 270 75 270 90 225
Circle -7500403 true true 60 210 30
Polygon -7500403 true true 105 150 60 225 75 240 120 210
Circle -7500403 true true 180 255 30
Circle -7500403 true true 165 195 30
Polygon -7500403 true true 120 210 180 225 180 195 150 180
Polygon -7500403 true true 195 210 210 270 180 270 165 210
Polygon -1 true false 191 208 207 271 185 272 171 218
Circle -1 true false 169 199 22
Circle -7500403 true true 90 150 60
Polygon -7500403 true true 105 116 90 176 150 176 165 116
Circle -7500403 true true 105 90 60
Circle -1 true false 110 95 50
Circle -7500403 true true 45 255 30
Circle -7500403 true true 165 165 30
Circle -2674135 true false 235 189 42
Circle -2674135 true false 244 191 42
Circle -7500403 true true 120 30 60
Circle -1 true false 125 35 50
Circle -1 true false 184 259 22
Circle -1 true false 49 259 22
Circle -7500403 true true 216 192 30
Circle -1 true false 64 214 22
Polygon -7500403 true true 165 120 191 170 167 187 115 142
Polygon -1 true false 158 118 189 175 170 185 119 138
Polygon -7500403 true true 180 198 228 215 227 191 190 167
Polygon -1 true false 175 190 231 211 228 196 187 170
Circle -1 true false 169 169 22
Circle -1 true false 220 196 22
Polygon -1 true false 110 120 95 180 145 182 160 120
Polygon -1 true false 121 205 181 221 181 200 144 183
Circle -1 true false 95 155 50
Polygon -1 true false 65 224 49 270 70 271 87 224
Polygon -1 true false 103 163 64 223 81 232 124 201
Circle -1 true false 169 109 22

forehand02
true
0
Circle -7500403 true true 150 105 30
Circle -1 true false 154 109 22
Polygon -7500403 true true 165 105 120 135 135 150 165 135
Polygon -1 true false 165 109 123 137 132 146 165 130
Polygon -7500403 true true 60 225 45 270 75 270 90 225
Circle -7500403 true true 60 210 30
Polygon -7500403 true true 105 150 60 225 75 240 120 210
Circle -7500403 true true 180 255 30
Circle -7500403 true true 165 195 30
Polygon -7500403 true true 120 210 180 225 180 195 150 180
Polygon -7500403 true true 195 210 210 270 180 270 165 210
Polygon -1 true false 191 208 207 271 185 272 171 218
Circle -1 true false 169 199 22
Circle -7500403 true true 90 150 60
Polygon -7500403 true true 105 116 90 176 150 176 165 116
Circle -7500403 true true 105 90 60
Circle -1 true false 110 95 50
Circle -7500403 true true 45 255 30
Circle -7500403 true true 165 165 30
Circle -2674135 true false 235 174 42
Circle -2674135 true false 244 176 42
Circle -7500403 true true 120 30 60
Circle -1 true false 125 35 50
Circle -1 true false 184 259 22
Circle -1 true false 49 259 22
Circle -7500403 true true 216 177 30
Circle -1 true false 64 214 22
Polygon -7500403 true true 165 120 191 170 167 187 115 142
Polygon -1 true false 158 118 189 175 170 185 119 138
Polygon -7500403 true true 180 198 225 203 225 180 190 167
Polygon -1 true false 175 190 227 201 223 185 187 170
Circle -1 true false 169 169 22
Circle -1 true false 220 181 22
Polygon -1 true false 110 120 95 180 145 182 160 120
Polygon -1 true false 121 205 181 221 181 200 144 183
Circle -1 true false 95 155 50
Polygon -1 true false 65 224 49 270 70 271 87 224
Polygon -1 true false 103 163 64 223 81 232 124 201

forehand03
true
0
Polygon -7500403 true true 90 150 120 180 120 150 90 120
Polygon -1 true false 89 145 116 173 120 155 89 124
Circle -7500403 true true 75 120 30
Polygon -7500403 true true 118 96 86 121 90 150 128 140
Circle -7500403 true true 105 150 30
Circle -1 true false 109 154 22
Polygon -7500403 true true 60 225 45 270 75 270 90 225
Circle -7500403 true true 60 210 30
Polygon -7500403 true true 105 150 60 225 75 240 120 210
Circle -7500403 true true 180 255 30
Circle -7500403 true true 165 195 30
Polygon -7500403 true true 120 210 180 225 180 195 150 180
Polygon -7500403 true true 195 210 210 270 180 270 165 210
Polygon -1 true false 191 208 207 271 185 272 171 218
Circle -1 true false 169 199 22
Circle -7500403 true true 90 150 60
Polygon -7500403 true true 105 116 90 176 150 176 165 116
Circle -7500403 true true 105 90 60
Circle -1 true false 110 95 50
Circle -7500403 true true 45 255 30
Circle -7500403 true true 165 150 30
Circle -2674135 true false 231 138 42
Circle -2674135 true false 239 136 42
Circle -7500403 true true 120 30 60
Circle -1 true false 125 35 50
Circle -1 true false 184 259 22
Circle -1 true false 49 259 22
Circle -7500403 true true 213 148 30
Circle -1 true false 64 214 22
Polygon -7500403 true true 165 120 182 150 175 178 115 142
Polygon -1 true false 158 118 180 155 176 175 119 138
Polygon -7500403 true true 179 180 227 174 225 150 182 152
Polygon -1 true false 179 176 227 170 226 154 182 157
Circle -1 true false 169 154 22
Circle -1 true false 217 153 22
Polygon -1 true false 110 120 95 180 145 182 160 120
Polygon -1 true false 121 205 181 221 181 200 144 183
Circle -1 true false 95 155 50
Polygon -1 true false 65 224 49 270 70 271 87 224
Polygon -1 true false 103 163 64 223 81 232 124 201
Polygon -1 true false 124 98 89 124 90 145 124 135
Circle -1 true false 79 123 22

forehand04
true
0
Circle -1 true false 124 153 22
Polygon -7500403 true true 75 150 135 180 135 150 75 120
Polygon -1 true false 74 145 120 165 120 150 74 124
Circle -7500403 true true 120 150 30
Polygon -7500403 true true 100 98 75 120 75 150 111 139
Circle -7500403 true true 60 120 30
Circle -1 true false 64 124 22
Polygon -7500403 true true 60 225 45 270 75 270 90 225
Circle -7500403 true true 60 210 30
Polygon -7500403 true true 105 150 60 225 75 240 120 210
Circle -7500403 true true 180 255 30
Circle -7500403 true true 165 195 30
Polygon -7500403 true true 120 210 180 225 180 195 150 180
Polygon -7500403 true true 195 210 210 270 180 270 165 210
Polygon -1 true false 191 208 207 271 185 272 171 218
Circle -1 true false 169 199 22
Circle -7500403 true true 90 150 60
Polygon -7500403 true true 90 120 90 176 150 176 150 120
Circle -7500403 true true 90 90 60
Circle -7500403 true true 45 255 30
Circle -7500403 true true 165 120 30
Circle -2674135 true false 247 84 42
Circle -2674135 true false 252 83 42
Circle -7500403 true true 90 30 60
Circle -1 true false 95 35 50
Circle -1 true false 184 259 22
Circle -1 true false 49 259 22
Circle -7500403 true true 230 104 30
Circle -1 true false 64 214 22
Polygon -7500403 true true 141 99 180 120 180 150 115 142
Polygon -1 true false 128 97 181 125 181 147 119 138
Polygon -7500403 true true 188 147 239 132 236 108 183 122
Polygon -1 true false 182 146 239 128 239 112 173 127
Circle -1 true false 169 125 22
Circle -1 true false 234 109 22
Polygon -1 true false 96 118 95 180 145 182 144 116
Polygon -1 true false 121 205 181 221 181 200 144 183
Circle -1 true false 95 155 50
Polygon -1 true false 65 224 49 270 70 271 87 224
Polygon -1 true false 103 163 64 223 81 232 124 201
Polygon -1 true false 101 104 73 125 83 144 105 135
Circle -1 true false 95 95 50

forehand05
true
0
Polygon -7500403 true true 60 150 120 150 120 120 60 120
Polygon -1 true false 59 145 120 145 120 133 59 124
Circle -7500403 true true 45 120 30
Polygon -7500403 true true 85 98 60 120 60 150 96 139
Circle -7500403 true true 90 135 30
Circle -1 true false 94 139 22
Polygon -7500403 true true 60 225 45 270 75 270 90 225
Circle -7500403 true true 60 210 30
Polygon -7500403 true true 105 150 60 225 75 240 120 210
Circle -7500403 true true 180 255 30
Circle -7500403 true true 165 195 30
Polygon -7500403 true true 120 210 180 225 180 195 144 169
Polygon -7500403 true true 195 210 210 270 180 270 165 210
Polygon -1 true false 191 208 207 271 185 272 171 218
Circle -1 true false 169 199 22
Circle -7500403 true true 90 150 60
Polygon -7500403 true true 75 120 90 191 149 177 135 120
Circle -7500403 true true 75 90 60
Circle -7500403 true true 45 255 30
Circle -7500403 true true 150 105 30
Circle -2674135 true false 216 46 42
Circle -2674135 true false 209 50 42
Circle -7500403 true true 75 30 60
Circle -1 true false 80 35 50
Circle -1 true false 184 259 22
Circle -1 true false 49 259 22
Circle -7500403 true true 200 74 30
Circle -1 true false 64 214 22
Polygon -7500403 true true 113 92 165 105 165 135 115 142
Polygon -1 true false 103 98 166 109 165 131 119 138
Polygon -7500403 true true 173 131 214 102 203 84 159 105
Polygon -1 true false 173 128 212 98 207 86 157 110
Circle -1 true false 154 110 22
Circle -1 true false 204 79 22
Polygon -1 true false 81 118 94 182 144 175 129 116
Polygon -1 true false 121 205 181 221 181 200 133 170
Circle -1 true false 95 155 50
Polygon -1 true false 65 224 49 270 70 271 87 224
Polygon -1 true false 103 163 64 223 81 232 124 201
Polygon -1 true false 86 104 51 131 64 144 90 135
Circle -1 true false 80 95 50
Circle -1 true false 49 123 22

forehand06
true
0
Polygon -7500403 true true 60 165 120 165 120 135 60 135
Polygon -1 true false 59 160 120 160 120 148 59 139
Circle -7500403 true true 45 135 30
Polygon -7500403 true true 65 104 45 150 60 165 96 139
Circle -7500403 true true 90 135 30
Circle -1 true false 94 139 22
Polygon -7500403 true true 60 225 45 270 75 270 90 225
Circle -7500403 true true 60 210 30
Polygon -7500403 true true 105 150 60 225 75 240 120 210
Circle -7500403 true true 180 255 30
Circle -7500403 true true 165 195 30
Polygon -7500403 true true 120 210 180 225 180 195 144 169
Polygon -7500403 true true 195 210 210 270 180 270 165 210
Polygon -1 true false 191 208 207 271 185 272 171 218
Circle -1 true false 169 199 22
Circle -7500403 true true 90 150 60
Polygon -7500403 true true 60 120 90 191 149 177 120 120
Circle -7500403 true true 60 90 60
Circle -7500403 true true 45 255 30
Circle -7500403 true true 150 90 30
Circle -2674135 true false 201 16 42
Circle -2674135 true false 194 20 42
Circle -7500403 true true 60 30 60
Circle -1 true false 65 35 50
Circle -1 true false 184 259 22
Circle -1 true false 49 259 22
Circle -7500403 true true 185 44 30
Circle -1 true false 64 214 22
Polygon -7500403 true true 98 92 165 90 165 120 100 142
Polygon -1 true false 93 97 163 95 167 116 103 135
Polygon -7500403 true true 173 116 210 60 195 45 159 90
Polygon -1 true false 173 113 202 65 191 59 161 95
Circle -1 true false 154 95 22
Circle -1 true false 189 49 22
Polygon -1 true false 66 122 94 182 144 175 116 122
Polygon -1 true false 121 205 181 221 181 200 133 170
Circle -1 true false 95 155 50
Polygon -1 true false 65 224 49 270 70 271 87 224
Polygon -1 true false 103 163 64 223 81 232 124 201
Polygon -1 true false 67 110 52 142 65 158 90 135
Circle -1 true false 65 95 50
Circle -1 true false 49 139 22

forehand07
true
0
Polygon -7500403 true true 60 165 120 165 120 135 60 135
Polygon -1 true false 59 160 120 160 120 148 59 139
Circle -7500403 true true 45 135 30
Polygon -7500403 true true 65 104 45 150 60 165 96 139
Circle -7500403 true true 90 135 30
Circle -1 true false 94 139 22
Polygon -7500403 true true 60 225 45 270 75 270 90 225
Circle -7500403 true true 60 210 30
Polygon -7500403 true true 105 150 60 225 75 240 120 210
Circle -7500403 true true 180 255 30
Circle -7500403 true true 165 195 30
Polygon -7500403 true true 120 210 180 225 180 195 144 169
Polygon -7500403 true true 195 210 210 270 180 270 165 210
Polygon -1 true false 191 208 207 271 185 272 171 218
Circle -1 true false 169 199 22
Circle -7500403 true true 90 150 60
Polygon -7500403 true true 60 120 90 191 149 177 120 120
Circle -7500403 true true 60 90 60
Circle -7500403 true true 45 255 30
Circle -7500403 true true 150 75 30
Circle -2674135 true false 186 1 42
Circle -2674135 true false 179 5 42
Circle -7500403 true true 60 30 60
Circle -1 true false 65 35 50
Circle -1 true false 184 259 22
Circle -1 true false 49 259 22
Circle -7500403 true true 170 29 30
Circle -1 true false 64 214 22
Polygon -7500403 true true 98 92 165 75 165 105 100 142
Polygon -1 true false 93 97 159 82 168 100 103 135
Polygon -7500403 true true 180 90 195 45 180 30 159 75
Polygon -1 true false 173 98 191 48 176 46 161 80
Circle -1 true false 154 80 22
Circle -1 true false 174 34 22
Polygon -1 true false 66 122 94 182 144 175 116 122
Polygon -1 true false 121 205 181 221 181 200 133 170
Circle -1 true false 95 155 50
Polygon -1 true false 65 224 49 270 70 271 87 224
Polygon -1 true false 103 163 64 223 81 232 124 201
Polygon -1 true false 67 110 52 142 65 158 90 135
Circle -1 true false 65 95 50
Circle -1 true false 49 139 22

forehand08
true
0
Polygon -7500403 true true 162 98 180 45 165 30 135 90
Polygon -7500403 true true 60 165 120 165 120 135 60 135
Polygon -1 true false 59 160 120 160 120 148 59 139
Circle -7500403 true true 45 135 30
Polygon -7500403 true true 65 104 45 150 60 165 96 139
Circle -7500403 true true 90 135 30
Circle -1 true false 94 139 22
Polygon -7500403 true true 60 225 45 270 75 270 90 225
Circle -7500403 true true 60 210 30
Polygon -7500403 true true 105 150 60 225 75 240 120 210
Circle -7500403 true true 180 255 30
Circle -7500403 true true 165 195 30
Polygon -7500403 true true 120 210 180 225 180 195 144 169
Polygon -7500403 true true 195 210 210 270 180 270 165 210
Polygon -1 true false 191 208 207 271 185 272 171 218
Circle -1 true false 169 199 22
Circle -7500403 true true 90 150 60
Polygon -7500403 true true 60 120 90 191 149 177 120 120
Circle -7500403 true true 60 90 60
Circle -7500403 true true 45 255 30
Circle -7500403 true true 135 75 30
Circle -2674135 true false 171 1 42
Circle -2674135 true false 164 5 42
Circle -7500403 true true 60 30 60
Circle -1 true false 65 35 50
Circle -1 true false 184 259 22
Circle -1 true false 49 259 22
Circle -7500403 true true 155 29 30
Circle -1 true false 64 214 22
Polygon -7500403 true true 89 92 150 75 150 105 100 142
Polygon -1 true false 84 97 146 81 150 99 103 135
Polygon -1 true false 160 95 175 47 166 39 144 83
Circle -1 true false 139 80 22
Circle -1 true false 159 34 22
Polygon -1 true false 66 122 94 182 144 175 116 122
Polygon -1 true false 121 205 181 221 181 200 133 170
Circle -1 true false 95 155 50
Polygon -1 true false 65 224 49 270 70 271 87 224
Polygon -1 true false 103 163 64 223 81 232 124 201
Polygon -1 true false 67 110 52 142 65 158 90 135
Circle -1 true false 65 95 50
Circle -1 true false 49 139 22

forehand09
true
0
Polygon -7500403 true true 164 74 155 29 126 30 135 75
Polygon -7500403 true true 60 165 120 165 120 135 60 135
Polygon -1 true false 59 160 120 160 120 148 59 139
Circle -7500403 true true 45 135 30
Polygon -7500403 true true 65 104 45 150 60 165 96 139
Circle -7500403 true true 90 135 30
Circle -1 true false 94 139 22
Polygon -7500403 true true 60 225 45 270 75 270 90 225
Circle -7500403 true true 60 210 30
Polygon -7500403 true true 105 150 60 225 75 240 120 210
Circle -7500403 true true 180 255 30
Circle -7500403 true true 165 195 30
Polygon -7500403 true true 120 210 180 225 180 195 144 169
Polygon -7500403 true true 195 210 210 270 180 270 165 210
Polygon -1 true false 191 208 207 271 185 272 171 218
Circle -1 true false 169 199 22
Circle -7500403 true true 90 150 60
Polygon -7500403 true true 60 120 90 191 149 177 120 120
Circle -7500403 true true 60 90 60
Circle -7500403 true true 45 255 30
Circle -7500403 true true 135 60 30
Circle -2674135 true false 122 -17 42
Circle -2674135 true false 119 -10 42
Circle -7500403 true true 60 30 60
Circle -1 true false 65 35 50
Circle -1 true false 184 259 22
Circle -1 true false 49 259 22
Circle -7500403 true true 125 14 30
Circle -1 true false 64 214 22
Polygon -7500403 true true 89 92 150 60 162 84 120 120
Polygon -1 true false 84 97 144 70 158 84 111 122
Polygon -1 true false 160 75 150 28 130 29 140 76
Circle -1 true false 139 65 22
Circle -1 true false 129 19 22
Polygon -1 true false 66 122 94 182 144 175 116 122
Polygon -1 true false 121 205 181 221 181 200 133 170
Circle -1 true false 95 155 50
Polygon -1 true false 65 224 49 270 70 271 87 224
Polygon -1 true false 103 163 64 223 81 232 124 201
Polygon -1 true false 67 110 52 142 65 158 90 135
Circle -1 true false 65 95 50
Circle -1 true false 49 139 22

forehand10
true
0
Circle -7500403 true true 165 105 30
Circle -7500403 true true 135 90 60
Polygon -7500403 true true 135 120 109 170 133 187 185 142
Circle -7500403 true true 150 150 60
Circle -7500403 true true 210 210 30
Polygon -7500403 true true 195 150 240 225 225 240 180 210
Circle -1 true false 155 155 50
Polygon -7500403 true true 195 116 210 176 150 176 135 116
Polygon -1 true false 190 120 205 180 155 182 140 120
Circle -1 true false 140 95 50
Circle -7500403 true true 105 165 30
Polygon -1 true false 142 118 111 175 130 185 181 138
Polygon -7500403 true true 240 225 255 270 225 270 210 225
Circle -7500403 true true 90 255 30
Circle -7500403 true true 105 195 30
Polygon -7500403 true true 180 210 120 225 120 195 150 180
Polygon -7500403 true true 105 210 90 270 120 270 135 210
Polygon -1 true false 109 208 93 271 115 272 129 218
Circle -1 true false 109 199 22
Circle -7500403 true true 225 255 30
Circle -16777216 true false 36 207 42
Circle -16777216 true false 29 210 42
Circle -7500403 true true 120 30 60
Circle -1 true false 125 35 50
Circle -7500403 true true 90 105 30
Circle -1 true false 94 259 22
Circle -1 true false 229 259 22
Circle -7500403 true true 63 203 30
Circle -1 true false 214 214 22
Polygon -7500403 true true 105 105 150 135 144 163 105 135
Circle -1 true false 94 109 22
Polygon -7500403 true true 120 198 73 230 73 204 109 170
Polygon -1 true false 125 190 73 224 73 209 113 170
Circle -1 true false 67 207 22
Polygon -1 true false 179 205 119 221 119 200 156 183
Polygon -1 true false 235 224 251 270 230 271 213 224
Circle -1 true false 109 169 22
Circle -7500403 true true 135 135 30
Polygon -1 true false 197 163 236 223 219 232 176 201
Polygon -7500403 true true 172 107 141 138 159 160 190 129
Polygon -1 true false 175 110 143 141 156 158 187 127
Circle -1 true false 139 139 22
Circle -1 true false 169 109 22
Polygon -1 true false 105 109 154 142 146 160 105 130

forehand11
true
0
Circle -7500403 true true 165 105 30
Polygon -7500403 true true 240 225 255 270 225 270 210 225
Circle -7500403 true true 210 210 30
Polygon -7500403 true true 195 150 240 225 225 240 180 210
Circle -7500403 true true 90 255 30
Circle -7500403 true true 105 195 30
Polygon -7500403 true true 180 210 120 225 120 195 150 180
Polygon -7500403 true true 105 210 90 270 120 270 135 210
Polygon -1 true false 109 208 93 271 115 272 129 218
Circle -1 true false 109 199 22
Circle -7500403 true true 150 150 60
Polygon -7500403 true true 195 116 210 176 150 176 135 116
Circle -7500403 true true 135 90 60
Circle -1 true false 140 95 50
Circle -7500403 true true 225 255 30
Circle -7500403 true true 105 165 30
Circle -16777216 true false 23 189 42
Circle -16777216 true false 14 191 42
Circle -7500403 true true 120 30 60
Circle -1 true false 125 35 50
Circle -1 true false 94 259 22
Circle -1 true false 229 259 22
Circle -7500403 true true 54 192 30
Circle -1 true false 214 214 22
Polygon -7500403 true true 135 120 109 170 133 187 185 142
Polygon -1 true false 142 118 111 175 130 185 181 138
Polygon -7500403 true true 120 198 72 215 73 191 110 167
Polygon -1 true false 125 190 69 211 72 196 113 170
Circle -1 true false 109 169 22
Circle -1 true false 58 196 22
Polygon -1 true false 190 120 205 180 155 182 140 120
Polygon -1 true false 179 205 119 221 119 200 156 183
Circle -1 true false 155 155 50
Polygon -1 true false 235 224 251 270 230 271 213 224
Polygon -1 true false 197 163 236 223 219 232 176 201
Polygon -7500403 true true 120 105 165 135 165 164 120 135
Circle -7500403 true true 105 105 30
Circle -1 true false 109 109 22
Circle -7500403 true true 150 135 30
Polygon -7500403 true true 165 120 150 150 180 150 195 120
Polygon -1 true false 169 119 155 150 175 152 191 119
Circle -1 true false 154 139 22
Circle -1 true false 169 109 22
Polygon -1 true false 120 109 167 140 167 161 120 130

forehand12
true
0
Circle -7500403 true true 165 105 30
Polygon -7500403 true true 240 225 255 270 225 270 210 225
Circle -7500403 true true 210 210 30
Polygon -7500403 true true 195 150 240 225 225 240 180 210
Circle -7500403 true true 90 255 30
Circle -7500403 true true 105 195 30
Polygon -7500403 true true 180 210 120 225 120 195 150 180
Polygon -7500403 true true 105 210 90 270 120 270 135 210
Polygon -1 true false 109 208 93 271 115 272 129 218
Circle -1 true false 109 199 22
Circle -7500403 true true 150 150 60
Polygon -7500403 true true 195 116 210 176 150 176 135 116
Circle -7500403 true true 135 90 60
Circle -1 true false 140 95 50
Circle -7500403 true true 225 255 30
Circle -7500403 true true 105 165 30
Circle -16777216 true false 23 174 42
Circle -7500403 true true 120 30 60
Circle -1 true false 125 35 50
Circle -1 true false 94 259 22
Circle -1 true false 229 259 22
Circle -7500403 true true 54 177 30
Circle -1 true false 214 214 22
Polygon -7500403 true true 135 120 109 170 133 187 185 142
Polygon -1 true false 142 118 111 175 130 185 181 138
Polygon -7500403 true true 120 198 75 203 75 180 110 167
Polygon -1 true false 125 190 73 201 77 185 113 170
Circle -1 true false 109 169 22
Circle -1 true false 58 181 22
Polygon -1 true false 190 120 205 180 155 182 140 120
Polygon -1 true false 179 205 119 221 119 200 156 183
Circle -1 true false 155 155 50
Polygon -1 true false 235 224 251 270 230 271 213 224
Polygon -1 true false 197 163 236 223 219 232 176 201
Circle -16777216 true false 14 176 42
Circle -7500403 true true 105 105 30
Polygon -7500403 true true 120 105 165 135 159 156 120 135
Circle -1 true false 109 109 22
Circle -7500403 true true 150 132 30
Polygon -7500403 true true 165 120 150 149 180 150 195 120
Polygon -1 true false 169 117 154 147 176 149 190 124
Circle -1 true false 154 136 22
Circle -1 true false 169 109 22
Polygon -1 true false 120 109 162 137 158 152 120 130

forehand13
true
0
Polygon -7500403 true true 195 150 240 225 225 240 180 210
Circle -7500403 true true 150 150 60
Polygon -7500403 true true 182 96 214 121 210 150 172 140
Polygon -7500403 true true 135 120 118 150 125 178 185 142
Polygon -7500403 true true 195 116 210 176 150 176 135 116
Polygon -1 true false 190 120 205 180 155 182 140 120
Circle -7500403 true true 135 90 60
Circle -1 true false 140 95 50
Polygon -7500403 true true 121 180 73 174 75 150 118 152
Circle -7500403 true true 105 150 30
Polygon -1 true false 142 118 120 155 124 175 181 138
Circle -7500403 true true 195 120 30
Polygon -7500403 true true 240 225 255 270 225 270 210 225
Circle -7500403 true true 210 210 30
Circle -7500403 true true 90 255 30
Circle -7500403 true true 105 195 30
Polygon -7500403 true true 180 210 120 225 120 195 150 180
Polygon -7500403 true true 105 210 90 270 120 270 135 210
Polygon -1 true false 109 208 93 271 115 272 129 218
Circle -1 true false 109 199 22
Circle -7500403 true true 225 255 30
Circle -7500403 true true 165 150 30
Circle -16777216 true false 27 138 42
Circle -16777216 true false 19 136 42
Circle -7500403 true true 120 30 60
Circle -1 true false 125 35 50
Circle -1 true false 94 259 22
Circle -1 true false 229 259 22
Circle -7500403 true true 57 148 30
Circle -1 true false 214 214 22
Circle -1 true false 169 154 22
Circle -1 true false 61 153 22
Polygon -1 true false 179 205 119 221 119 200 156 183
Circle -1 true false 155 155 50
Polygon -1 true false 235 224 251 270 230 271 213 224
Polygon -1 true false 197 163 236 223 219 232 176 201
Circle -7500403 true true 165 135 30
Polygon -1 true false 176 98 211 124 210 145 176 135
Circle -1 true false 199 123 22
Polygon -1 true false 121 176 73 170 74 154 118 157
Circle -1 true false 109 154 22
Polygon -7500403 true true 210 150 180 165 177 137 203 124
Polygon -1 true false 211 145 182 160 182 138 211 124
Circle -1 true false 169 139 22

forehand14
true
0
Circle -7500403 true true 150 90 60
Polygon -7500403 true true 210 120 210 176 150 176 150 120
Circle -7500403 true true 105 120 30
Polygon -7500403 true true 159 99 120 120 120 150 185 142
Polygon -1 true false 172 97 119 125 119 147 181 138
Circle -1 true false 155 95 50
Circle -7500403 true true 210 210 30
Circle -7500403 true true 150 150 60
Polygon -7500403 true true 195 150 240 225 225 240 180 210
Circle -1 true false 155 155 50
Polygon -1 true false 204 118 205 180 155 182 156 116
Circle -7500403 true true 165 120 30
Polygon -7500403 true true 200 98 225 120 225 150 201 145
Circle -7500403 true true 210 120 30
Polygon -7500403 true true 240 225 255 270 225 270 210 225
Circle -7500403 true true 90 255 30
Circle -7500403 true true 105 195 30
Polygon -7500403 true true 180 210 120 225 120 195 150 180
Polygon -7500403 true true 105 210 90 270 120 270 135 210
Polygon -1 true false 109 208 93 271 115 272 129 218
Circle -1 true false 109 199 22
Circle -7500403 true true 225 255 30
Circle -16777216 true false 6 83 42
Circle -7500403 true true 150 30 60
Circle -1 true false 155 35 50
Circle -1 true false 94 259 22
Circle -1 true false 229 259 22
Circle -7500403 true true 40 104 30
Circle -1 true false 214 214 22
Polygon -7500403 true true 112 147 61 132 64 108 117 122
Polygon -1 true false 118 146 61 128 61 112 127 127
Circle -1 true false 109 125 22
Circle -1 true false 44 109 22
Polygon -1 true false 179 205 119 221 119 200 156 183
Polygon -1 true false 235 224 251 270 230 271 213 224
Polygon -1 true false 199 104 227 125 217 144 195 135
Circle -16777216 true false 11 84 42
Polygon -7500403 true true 225 150 180 150 181 123 225 120
Circle -1 true false 169 123 22
Polygon -1 true false 226 145 180 145 181 127 226 124
Circle -1 true false 214 124 22
Polygon -1 true false 197 163 236 223 219 232 176 201

forehand15
true
0
Circle -7500403 true true 225 120 30
Polygon -7500403 true true 215 98 240 120 240 150 204 139
Polygon -7500403 true true 240 225 255 270 225 270 210 225
Circle -7500403 true true 210 210 30
Polygon -7500403 true true 195 150 240 225 225 240 180 210
Circle -7500403 true true 90 255 30
Circle -7500403 true true 105 195 30
Polygon -7500403 true true 180 210 120 225 120 195 156 169
Polygon -7500403 true true 105 210 90 270 120 270 135 210
Polygon -1 true false 109 208 93 271 115 272 129 218
Circle -1 true false 109 199 22
Circle -7500403 true true 150 150 60
Polygon -7500403 true true 225 120 210 191 151 177 165 120
Circle -7500403 true true 165 90 60
Circle -7500403 true true 225 255 30
Circle -7500403 true true 120 105 30
Circle -16777216 true false 42 46 42
Circle -16777216 true false 49 50 42
Circle -7500403 true true 165 30 60
Circle -1 true false 170 35 50
Circle -1 true false 94 259 22
Circle -1 true false 229 259 22
Circle -7500403 true true 70 74 30
Circle -1 true false 214 214 22
Polygon -7500403 true true 187 92 135 105 135 135 185 142
Polygon -1 true false 197 98 134 109 135 131 181 138
Polygon -7500403 true true 127 131 86 102 97 84 141 105
Polygon -1 true false 127 128 88 98 93 86 143 110
Circle -1 true false 124 110 22
Circle -1 true false 74 79 22
Polygon -1 true false 219 118 206 182 156 175 171 116
Polygon -1 true false 179 205 119 221 119 200 167 170
Circle -1 true false 155 155 50
Polygon -1 true false 235 224 251 270 230 271 213 224
Polygon -1 true false 197 163 236 223 219 232 176 201
Polygon -1 true false 214 104 249 131 236 144 210 135
Circle -1 true false 170 95 50
Circle -1 true false 229 123 22
Polygon -7500403 true true 240 150 195 150 203 127 240 120
Circle -7500403 true true 180 120 30
Circle -1 true false 184 124 22
Polygon -1 true false 241 145 196 146 193 133 241 124

forehand16
true
0
Circle -7500403 true true 225 135 30
Polygon -7500403 true true 235 104 255 150 240 165 204 139
Polygon -7500403 true true 240 225 255 270 225 270 210 225
Circle -7500403 true true 210 210 30
Polygon -7500403 true true 195 150 240 225 225 240 180 210
Circle -7500403 true true 90 255 30
Circle -7500403 true true 105 195 30
Polygon -7500403 true true 180 210 120 225 120 195 156 169
Polygon -7500403 true true 105 210 90 270 120 270 135 210
Polygon -1 true false 109 208 93 271 115 272 129 218
Circle -1 true false 109 199 22
Circle -7500403 true true 150 150 60
Polygon -7500403 true true 240 120 210 191 151 177 180 120
Circle -7500403 true true 180 90 60
Circle -7500403 true true 225 255 30
Circle -7500403 true true 120 90 30
Circle -16777216 true false 57 16 42
Circle -16777216 true false 64 20 42
Circle -7500403 true true 180 30 60
Circle -1 true false 185 35 50
Circle -1 true false 94 259 22
Circle -1 true false 229 259 22
Circle -7500403 true true 85 44 30
Circle -1 true false 214 214 22
Polygon -7500403 true true 202 92 135 90 135 120 200 142
Polygon -1 true false 207 97 137 95 133 116 197 135
Polygon -7500403 true true 127 116 90 60 105 45 141 90
Polygon -1 true false 127 113 98 65 109 59 139 95
Circle -1 true false 124 95 22
Circle -1 true false 89 49 22
Polygon -1 true false 234 122 206 182 156 175 184 122
Polygon -1 true false 179 205 119 221 119 200 167 170
Circle -1 true false 155 155 50
Polygon -1 true false 235 224 251 270 230 271 213 224
Polygon -1 true false 197 163 236 223 219 232 176 201
Polygon -1 true false 233 110 248 142 235 158 210 135
Circle -1 true false 185 95 50
Polygon -7500403 true true 240 165 210 150 214 126 240 135
Circle -7500403 true true 195 120 30
Circle -1 true false 199 124 22
Circle -1 true false 229 139 22
Polygon -1 true false 241 160 204 141 206 130 241 139

forehand17
true
0
Circle -7500403 true true 225 135 30
Polygon -7500403 true true 235 104 255 150 240 165 204 139
Polygon -7500403 true true 240 225 255 270 225 270 210 225
Circle -7500403 true true 210 210 30
Polygon -7500403 true true 195 150 240 225 225 240 180 210
Circle -7500403 true true 90 255 30
Circle -7500403 true true 105 195 30
Polygon -7500403 true true 180 210 120 225 120 195 156 169
Polygon -7500403 true true 105 210 90 270 120 270 135 210
Polygon -1 true false 109 208 93 271 115 272 129 218
Circle -1 true false 109 199 22
Circle -7500403 true true 150 150 60
Polygon -7500403 true true 240 120 210 191 151 177 180 120
Circle -7500403 true true 180 90 60
Circle -7500403 true true 225 255 30
Circle -7500403 true true 120 75 30
Circle -16777216 true false 72 1 42
Circle -16777216 true false 79 5 42
Circle -7500403 true true 180 30 60
Circle -1 true false 185 35 50
Circle -1 true false 94 259 22
Circle -1 true false 229 259 22
Circle -7500403 true true 100 29 30
Circle -1 true false 214 214 22
Polygon -7500403 true true 202 92 135 75 135 105 200 142
Polygon -1 true false 207 97 141 82 132 100 197 135
Polygon -7500403 true true 120 90 105 45 120 30 141 75
Polygon -1 true false 127 98 109 48 124 46 139 80
Circle -1 true false 124 80 22
Circle -1 true false 104 34 22
Polygon -1 true false 234 122 206 182 156 175 184 122
Polygon -1 true false 179 205 119 221 119 200 167 170
Circle -1 true false 155 155 50
Polygon -1 true false 235 224 251 270 230 271 213 224
Polygon -1 true false 197 163 236 223 219 232 176 201
Polygon -1 true false 233 110 248 142 235 158 210 135
Circle -1 true false 185 95 50
Circle -7500403 true true 180 120 30
Polygon -7500403 true true 240 165 195 150 203 127 240 135
Polygon -1 true false 241 160 195 145 193 129 241 139
Circle -1 true false 184 124 22
Circle -1 true false 229 139 22

forehand18
true
0
Polygon -7500403 true true 138 98 120 45 135 30 165 90
Circle -7500403 true true 225 135 30
Polygon -7500403 true true 235 104 255 150 240 165 204 139
Polygon -7500403 true true 240 225 255 270 225 270 210 225
Circle -7500403 true true 210 210 30
Polygon -7500403 true true 195 150 240 225 225 240 180 210
Circle -7500403 true true 90 255 30
Circle -7500403 true true 105 195 30
Polygon -7500403 true true 180 210 120 225 120 195 156 169
Polygon -7500403 true true 105 210 90 270 120 270 135 210
Polygon -1 true false 109 208 93 271 115 272 129 218
Circle -1 true false 109 199 22
Circle -7500403 true true 150 150 60
Polygon -7500403 true true 240 120 210 191 151 177 180 120
Circle -7500403 true true 180 90 60
Circle -7500403 true true 225 255 30
Circle -7500403 true true 135 75 30
Circle -16777216 true false 87 1 42
Circle -16777216 true false 94 5 42
Circle -7500403 true true 180 30 60
Circle -1 true false 185 35 50
Circle -1 true false 94 259 22
Circle -1 true false 229 259 22
Circle -7500403 true true 115 29 30
Circle -1 true false 214 214 22
Polygon -7500403 true true 211 92 150 75 150 105 200 142
Polygon -1 true false 216 97 154 81 150 99 197 135
Polygon -1 true false 140 95 125 47 134 39 156 83
Circle -1 true false 139 80 22
Circle -1 true false 119 34 22
Polygon -1 true false 234 122 206 182 156 175 184 122
Polygon -1 true false 179 205 119 221 119 200 167 170
Circle -1 true false 155 155 50
Polygon -1 true false 235 224 251 270 230 271 213 224
Polygon -1 true false 197 163 236 223 219 232 176 201
Polygon -1 true false 233 110 248 142 235 158 210 135
Circle -1 true false 185 95 50
Polygon -7500403 true true 240 165 195 120 225 120 240 135
Circle -1 true false 229 139 22
Circle -7500403 true true 195 105 30
Circle -1 true false 199 109 22
Polygon -1 true false 237 156 199 119 215 117 242 140

forehand19
true
0
Polygon -7500403 true true 136 74 145 29 174 30 165 75
Circle -7500403 true true 225 135 30
Polygon -7500403 true true 235 104 255 150 240 165 204 139
Polygon -7500403 true true 240 225 255 270 225 270 210 225
Circle -7500403 true true 210 210 30
Polygon -7500403 true true 195 150 240 225 225 240 180 210
Circle -7500403 true true 90 255 30
Circle -7500403 true true 105 195 30
Polygon -7500403 true true 180 210 120 225 120 195 156 169
Polygon -7500403 true true 105 210 90 270 120 270 135 210
Polygon -1 true false 109 208 93 271 115 272 129 218
Circle -1 true false 109 199 22
Circle -7500403 true true 150 150 60
Polygon -7500403 true true 240 120 210 191 151 177 180 120
Circle -7500403 true true 180 90 60
Circle -7500403 true true 225 255 30
Circle -7500403 true true 135 60 30
Circle -16777216 true false 136 -17 42
Circle -16777216 true false 139 -10 42
Circle -7500403 true true 180 30 60
Circle -1 true false 185 35 50
Circle -1 true false 94 259 22
Circle -1 true false 229 259 22
Circle -7500403 true true 145 14 30
Circle -1 true false 214 214 22
Polygon -7500403 true true 211 92 150 60 138 84 180 120
Polygon -1 true false 216 97 156 70 142 84 189 122
Polygon -1 true false 140 75 150 28 170 29 160 76
Circle -1 true false 139 65 22
Circle -1 true false 149 19 22
Polygon -1 true false 234 122 206 182 156 175 184 122
Polygon -1 true false 179 205 119 221 119 200 167 170
Circle -1 true false 155 155 50
Polygon -1 true false 235 224 251 270 230 271 213 224
Polygon -1 true false 197 163 236 223 219 232 176 201
Polygon -1 true false 233 110 248 142 235 158 210 135
Circle -1 true false 185 95 50
Polygon -7500403 true true 234 163 195 120 210 105 240 135
Circle -7500403 true true 195 105 30
Circle -1 true false 199 109 22
Circle -1 true false 229 139 22
Polygon -1 true false 241 160 200 124 210 110 242 142

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

ittf world tour 00
true
0
Circle -2674135 true false 193 118 6
Circle -2674135 true false 206 114 6
Circle -2674135 true false 133 63 4
Circle -2674135 true false 214 118 4
Circle -2674135 true false 235 107 2
Circle -2674135 true false 134 115 10
Circle -2674135 true false 244 93 4
Circle -2674135 true false 161 131 10
Circle -2674135 true false 155 113 8
Circle -2674135 true false 146 107 6
Circle -2674135 true false 139 53 4
Circle -2674135 true false 149 123 10
Circle -2674135 true false 195 137 6
Circle -2674135 true false 200 128 8
Circle -2674135 true false 180 121 8
Circle -2674135 true false 228 104 4
Circle -2674135 true false 168 122 8
Circle -2674135 true false 188 150 6
Circle -2674135 true false 184 131 8
Circle -2674135 true false 167 112 6
Circle -2674135 true false 203 113 2
Circle -2674135 true false 236 97 2
Circle -2674135 true false 213 105 4
Circle -2674135 true false 142 136 10
Circle -2674135 true false 156 99 6
Circle -2674135 true false 166 100 6
Circle -2674135 true false 147 93 6
Circle -2674135 true false 157 91 8
Circle -2674135 true false 158 79 8
Circle -2674135 true false 153 75 6
Circle -2674135 true false 127 79 6
Circle -2674135 true false 144 71 4
Circle -2674135 true false 151 60 4
Circle -2674135 true false 126 128 6
Circle -2674135 true false 173 141 10
Circle -2674135 true false 220 110 4
Circle -2674135 true false 160 149 6
Circle -2674135 true false 178 156 10
Circle -2674135 true false 162 161 6
Circle -2674135 true false 172 168 6
Circle -2674135 true false 186 172 8
Circle -2674135 true false 197 177 6
Circle -2674135 true false 187 183 6
Circle -2674135 true false 185 141 6
Circle -2674135 true false 114 136 6
Circle -2674135 true false 121 119 4
Circle -2674135 true false 139 82 8
Circle -2674135 true false 141 63 6
Circle -2674135 true false 104 118 4
Circle -2674135 true false 135 99 10
Circle -7500403 true true 146 154 8
Circle -7500403 true true 142 158 2
Circle -7500403 true true 148 167 8
Circle -7500403 true true 132 177 8
Circle -7500403 true true 145 182 8
Circle -7500403 true true 127 186 6
Circle -7500403 true true 108 152 8
Circle -7500403 true true 135 165 8
Circle -7500403 true true 116 175 4
Circle -7500403 true true 107 191 6
Circle -7500403 true true 123 160 4
Circle -7500403 true true 131 147 6
Circle -7500403 true true 99 173 6

ittf world tour 01
true
0
Circle -2674135 true false 193 118 6
Circle -2674135 true false 182 97 6
Circle -2674135 true false 133 63 4
Circle -2674135 true false 214 118 4
Circle -2674135 true false 213 139 2
Circle -2674135 true false 139 79 10
Circle -2674135 true false 210 149 4
Circle -2674135 true false 161 131 10
Circle -2674135 true false 155 113 8
Circle -2674135 true false 128 77 6
Circle -2674135 true false 124 55 4
Circle -2674135 true false 171 87 10
Circle -2674135 true false 195 137 6
Circle -2674135 true false 182 108 8
Circle -2674135 true false 180 121 8
Circle -2674135 true false 222 109 4
Circle -2674135 true false 168 122 8
Circle -2674135 true false 188 150 6
Circle -2674135 true false 184 131 8
Circle -2674135 true false 167 112 6
Circle -2674135 true false 202 128 2
Circle -2674135 true false 209 121 2
Circle -2674135 true false 203 115 4
Circle -2674135 true false 148 129 6
Circle -2674135 true false 150 84 6
Circle -2674135 true false 166 100 6
Circle -2674135 true false 147 93 6
Circle -2674135 true false 157 91 8
Circle -2674135 true false 158 79 8
Circle -2674135 true false 153 75 6
Circle -2674135 true false 123 70 6
Circle -2674135 true false 144 71 4
Circle -2674135 true false 151 60 4
Circle -2674135 true false 133 72 6
Circle -2674135 true false 173 141 10
Circle -2674135 true false 214 109 4
Circle -2674135 true false 155 125 6
Circle -2674135 true false 178 156 10
Circle -2674135 true false 146 141 6
Circle -2674135 true false 154 135 6
Circle -2674135 true false 189 156 8
Circle -2674135 true false 197 149 6
Circle -2674135 true false 200 166 6
Circle -2674135 true false 185 141 6
Circle -2674135 true false 112 69 6
Circle -2674135 true false 110 60 4
Circle -2674135 true false 155 105 8
Circle -2674135 true false 141 63 6
Circle -2674135 true false 104 58 4
Circle -2674135 true false 172 103 10
Circle -7500403 true true 158 150 8
Circle -7500403 true true 149 157 4
Circle -7500403 true true 155 165 8
Circle -7500403 true true 139 167 8
Circle -7500403 true true 166 166 8
Circle -7500403 true true 141 180 6
Circle -7500403 true true 133 158 8
Circle -7500403 true true 133 174 8
Circle -7500403 true true 158 180 6
Circle -7500403 true true 151 174 6
Circle -7500403 true true 124 156 4
Circle -7500403 true true 167 156 6
Circle -7500403 true true 126 163 6

ittf world tour 02
true
0
Circle -2674135 true false 193 118 6
Circle -2674135 true false 173 97 6
Circle -2674135 true false 133 63 4
Circle -2674135 true false 204 119 4
Circle -2674135 true false 141 107 2
Circle -2674135 true false 139 79 10
Circle -2674135 true false 202 137 4
Circle -2674135 true false 161 131 10
Circle -2674135 true false 148 115 8
Circle -2674135 true false 128 77 6
Circle -2674135 true false 124 55 4
Circle -2674135 true false 157 102 6
Circle -2674135 true false 195 137 6
Circle -2674135 true false 172 106 8
Circle -2674135 true false 180 121 8
Circle -2674135 true false 208 111 4
Circle -2674135 true false 168 122 8
Circle -2674135 true false 188 150 6
Circle -2674135 true false 184 131 8
Circle -2674135 true false 167 112 6
Circle -2674135 true false 202 128 2
Circle -2674135 true false 209 121 2
Circle -2674135 true false 183 115 4
Circle -2674135 true false 148 129 6
Circle -2674135 true false 150 84 6
Circle -2674135 true false 166 100 6
Circle -2674135 true false 147 93 6
Circle -2674135 true false 157 91 8
Circle -2674135 true false 169 85 6
Circle -2674135 true false 153 75 6
Circle -2674135 true false 123 70 6
Circle -2674135 true false 144 71 4
Circle -2674135 true false 162 79 4
Circle -2674135 true false 133 72 6
Circle -2674135 true false 173 141 10
Circle -2674135 true false 201 113 4
Circle -2674135 true false 155 125 6
Circle -2674135 true false 175 133 4
Circle -2674135 true false 155 141 6
Circle -2674135 true false 154 135 6
Circle -2674135 true false 138 94 4
Circle -2674135 true false 197 149 6
Circle -2674135 true false 195 128 6
Circle -2674135 true false 185 141 6
Circle -2674135 true false 124 63 6
Circle -2674135 true false 117 60 4
Circle -2674135 true false 148 103 8
Circle -2674135 true false 141 63 6
Circle -2674135 true false 112 55 4
Circle -2674135 true false 161 110 4
Circle -7500403 true true 183 160 6
Circle -7500403 true true 138 186 2
Circle -7500403 true true 171 187 8
Circle -7500403 true true 170 176 8
Circle -7500403 true true 162 160 8
Circle -7500403 true true 151 178 6
Circle -7500403 true true 172 165 8
Circle -7500403 true true 157 188 6
Circle -7500403 true true 161 173 6
Circle -7500403 true true 144 173 6
Circle -7500403 true true 135 157 6
Circle -7500403 true true 174 154 6
Circle -7500403 true true 152 166 6
Circle -7500403 true true 184 169 4
Circle -7500403 true true 197 161 2
Circle -7500403 true true 197 161 2
Circle -7500403 true true 191 170 4
Circle -7500403 true true 205 171 4
Circle -7500403 true true 204 157 6
Circle -7500403 true true 220 166 2
Circle -7500403 true true 143 164 4
Circle -7500403 true true 136 192 4
Circle -7500403 true true 133 175 4
Circle -7500403 true true 136 166 4
Circle -7500403 true true 161 194 8
Circle -7500403 true true 171 198 10
Circle -7500403 true true 150 191 2
Circle -7500403 true true 145 198 2
Circle -7500403 true true 145 186 2

ittf world tour 03
true
0
Circle -2674135 true false 130 58 8
Circle -2674135 true false 173 97 6
Circle -2674135 true false 133 63 4
Circle -2674135 true false 192 120 4
Circle -2674135 true false 141 107 2
Circle -2674135 true false 139 79 10
Circle -2674135 true false 202 137 4
Circle -2674135 true false 159 127 10
Circle -2674135 true false 120 61 2
Circle -2674135 true false 128 77 6
Circle -2674135 true false 149 65 4
Circle -2674135 true false 157 102 6
Circle -2674135 true false 195 137 6
Circle -2674135 true false 172 106 8
Circle -2674135 true false 180 121 8
Circle -2674135 true false 183 108 4
Circle -2674135 true false 168 122 8
Circle -2674135 true false 184 136 6
Circle -2674135 true false 163 70 8
Circle -2674135 true false 167 112 6
Circle -2674135 true false 202 128 2
Circle -2674135 true false 209 121 2
Circle -2674135 true false 183 115 4
Circle -2674135 true false 142 126 6
Circle -2674135 true false 150 84 6
Circle -2674135 true false 166 100 6
Circle -2674135 true false 147 93 6
Circle -2674135 true false 157 91 8
Circle -2674135 true false 169 85 6
Circle -2674135 true false 153 75 6
Circle -2674135 true false 123 70 6
Circle -2674135 true false 144 71 4
Circle -2674135 true false 162 79 4
Circle -2674135 true false 133 72 6
Circle -2674135 true false 152 59 6
Circle -2674135 true false 191 112 4
Circle -2674135 true false 156 117 6
Circle -2674135 true false 175 133 4
Circle -2674135 true false 148 116 6
Circle -2674135 true false 150 126 8
Circle -2674135 true false 138 94 4
Circle -2674135 true false 140 55 6
Circle -2674135 true false 195 128 6
Circle -2674135 true false 145 132 6
Circle -2674135 true false 124 63 6
Circle -2674135 true false 111 62 4
Circle -2674135 true false 148 103 8
Circle -2674135 true false 141 63 6
Circle -2674135 true false 157 69 4
Circle -2674135 true false 161 110 4
Circle -7500403 true true 152 166 6
Circle -7500403 true true 138 186 2
Circle -7500403 true true 136 179 8
Circle -7500403 true true 129 185 8
Circle -7500403 true true 151 194 8
Circle -7500403 true true 151 178 6
Circle -7500403 true true 133 197 8
Circle -7500403 true true 140 189 8
Circle -7500403 true true 161 173 6
Circle -7500403 true true 144 173 6
Circle -7500403 true true 142 159 6
Circle -7500403 true true 159 151 6
Circle -7500403 true true 159 154 6
Circle -7500403 true true 151 152 4
Circle -7500403 true true 174 154 2
Circle -7500403 true true 176 145 2
Circle -7500403 true true 166 146 4
Circle -7500403 true true 153 142 4
Circle -7500403 true true 153 159 6
Circle -7500403 true true 167 164 2
Circle -7500403 true true 143 164 4
Circle -7500403 true true 126 182 4
Circle -7500403 true true 133 175 4
Circle -7500403 true true 136 166 4
Circle -7500403 true true 152 184 8
Circle -7500403 true true 141 198 10
Circle -7500403 true true 162 190 4
Circle -7500403 true true 145 198 2
Circle -7500403 true true 145 186 2

ittf world tour 04
true
0
Circle -2674135 true false 174 75 8
Circle -2674135 true false 177 84 6
Circle -2674135 true false 133 63 4
Circle -2674135 true false 192 120 4
Circle -2674135 true false 141 107 2
Circle -2674135 true false 139 79 10
Circle -2674135 true false 202 137 4
Circle -2674135 true false 159 127 10
Circle -2674135 true false 124 65 2
Circle -2674135 true false 128 77 6
Circle -2674135 true false 149 65 4
Circle -2674135 true false 157 102 6
Circle -2674135 true false 177 121 6
Circle -2674135 true false 172 106 8
Circle -2674135 true false 176 96 8
Circle -2674135 true false 183 108 4
Circle -2674135 true false 168 122 8
Circle -2674135 true false 184 136 6
Circle -2674135 true false 167 68 8
Circle -2674135 true false 167 112 6
Circle -2674135 true false 202 128 2
Circle -2674135 true false 209 121 2
Circle -2674135 true false 183 115 4
Circle -2674135 true false 142 126 6
Circle -2674135 true false 150 84 6
Circle -2674135 true false 166 100 6
Circle -2674135 true false 147 93 6
Circle -2674135 true false 159 89 8
Circle -2674135 true false 166 87 6
Circle -2674135 true false 153 75 6
Circle -2674135 true false 123 70 6
Circle -2674135 true false 144 71 4
Circle -2674135 true false 162 79 4
Circle -2674135 true false 133 72 6
Circle -2674135 true false 152 59 6
Circle -2674135 true false 191 112 4
Circle -2674135 true false 156 117 6
Circle -2674135 true false 175 133 4
Circle -2674135 true false 148 116 6
Circle -2674135 true false 167 135 8
Circle -2674135 true false 138 94 4
Circle -2674135 true false 142 57 6
Circle -2674135 true false 124 85 6
Circle -2674135 true false 145 132 6
Circle -2674135 true false 163 63 6
Circle -2674135 true false 115 63 4
Circle -2674135 true false 148 103 8
Circle -2674135 true false 141 63 6
Circle -2674135 true false 157 69 4
Circle -2674135 true false 161 110 4
Circle -7500403 true true 152 166 6
Circle -7500403 true true 138 186 2
Circle -7500403 true true 157 140 8
Circle -7500403 true true 131 135 8
Circle -7500403 true true 151 194 8
Circle -7500403 true true 151 178 6
Circle -7500403 true true 143 185 8
Circle -7500403 true true 144 193 4
Circle -7500403 true true 150 174 6
Circle -7500403 true true 142 176 6
Circle -7500403 true true 142 159 6
Circle -7500403 true true 159 151 6
Circle -7500403 true true 146 167 6
Circle -7500403 true true 151 152 4
Circle -7500403 true true 174 154 2
Circle -7500403 true true 176 145 2
Circle -7500403 true true 166 146 4
Circle -7500403 true true 135 143 4
Circle -7500403 true true 153 159 6
Circle -7500403 true true 167 164 2
Circle -7500403 true true 143 164 4
Circle -7500403 true true 139 152 4
Circle -7500403 true true 139 172 4
Circle -7500403 true true 140 142 4
Circle -7500403 true true 149 186 8
Circle -7500403 true true 145 141 10
Circle -7500403 true true 128 135 4
Circle -7500403 true true 158 146 2
Circle -7500403 true true 145 186 2
Circle -2674135 true false 124 97 8
Circle -2674135 true false 122 110 6
Circle -2674135 true false 134 116 6
Circle -2674135 true false 125 120 8
Circle -2674135 true false 133 101 6
Circle -2674135 true false 135 91 2

ittf world tour 05
true
0
Circle -2674135 true false 174 75 8
Circle -2674135 true false 177 84 6
Circle -2674135 true false 133 63 4
Circle -2674135 true false 143 111 4
Circle -2674135 true false 141 107 2
Circle -2674135 true false 139 79 10
Circle -2674135 true false 183 127 4
Circle -2674135 true false 152 126 10
Circle -2674135 true false 129 67 2
Circle -2674135 true false 128 77 6
Circle -2674135 true false 149 65 4
Circle -2674135 true false 157 102 6
Circle -2674135 true false 177 121 6
Circle -2674135 true false 172 106 8
Circle -2674135 true false 176 96 8
Circle -2674135 true false 183 108 4
Circle -2674135 true false 168 122 8
Circle -2674135 true false 181 136 6
Circle -2674135 true false 167 68 8
Circle -2674135 true false 167 112 6
Circle -2674135 true false 188 124 2
Circle -2674135 true false 185 93 2
Circle -2674135 true false 183 115 4
Circle -2674135 true false 142 126 6
Circle -2674135 true false 150 84 6
Circle -2674135 true false 166 100 6
Circle -2674135 true false 147 93 6
Circle -2674135 true false 159 89 8
Circle -2674135 true false 166 87 6
Circle -2674135 true false 153 75 6
Circle -2674135 true false 156 82 6
Circle -2674135 true false 144 71 4
Circle -2674135 true false 162 79 4
Circle -2674135 true false 136 73 6
Circle -2674135 true false 152 59 6
Circle -2674135 true false 191 112 4
Circle -2674135 true false 156 117 6
Circle -2674135 true false 175 133 4
Circle -2674135 true false 148 116 6
Circle -2674135 true false 166 131 8
Circle -2674135 true false 138 94 4
Circle -2674135 true false 142 57 6
Circle -2674135 true false 124 85 6
Circle -2674135 true false 135 127 6
Circle -2674135 true false 163 63 6
Circle -2674135 true false 184 100 4
Circle -2674135 true false 148 103 8
Circle -2674135 true false 138 63 6
Circle -2674135 true false 157 69 4
Circle -2674135 true false 161 110 4
Circle -7500403 true true 152 166 6
Circle -7500403 true true 138 186 2
Circle -7500403 true true 158 147 4
Circle -7500403 true true 129 139 8
Circle -7500403 true true 161 153 8
Circle -7500403 true true 148 183 6
Circle -7500403 true true 139 191 8
Circle -7500403 true true 143 185 4
Circle -7500403 true true 150 174 6
Circle -7500403 true true 142 176 6
Circle -7500403 true true 142 159 6
Circle -7500403 true true 171 147 6
Circle -7500403 true true 146 167 6
Circle -7500403 true true 151 152 4
Circle -7500403 true true 141 202 2
Circle -7500403 true true 139 138 2
Circle -7500403 true true 166 146 4
Circle -7500403 true true 135 148 4
Circle -7500403 true true 153 159 6
Circle -7500403 true true 158 139 4
Circle -7500403 true true 143 164 4
Circle -7500403 true true 137 153 4
Circle -7500403 true true 139 172 4
Circle -7500403 true true 140 142 4
Circle -7500403 true true 151 194 6
Circle -7500403 true true 145 141 10
Circle -7500403 true true 143 152 4
Circle -7500403 true true 158 146 2
Circle -7500403 true true 136 196 2
Circle -2674135 true false 124 97 8
Circle -2674135 true false 122 110 6
Circle -2674135 true false 134 116 6
Circle -2674135 true false 123 122 8
Circle -2674135 true false 133 101 6
Circle -2674135 true false 135 91 2

ittf world tour 06
true
0
Circle -2674135 true false 174 75 8
Circle -2674135 true false 177 84 6
Circle -2674135 true false 133 63 4
Circle -2674135 true false 144 110 12
Circle -2674135 true false 137 103 10
Circle -2674135 true false 139 79 10
Circle -2674135 true false 170 134 8
Circle -2674135 true false 139 127 10
Circle -2674135 true false 129 67 2
Circle -2674135 true false 120 80 6
Circle -2674135 true false 149 65 4
Circle -2674135 true false 154 98 8
Circle -2674135 true false 172 127 12
Circle -2674135 true false 172 106 8
Circle -2674135 true false 176 96 8
Circle -2674135 true false 180 105 10
Circle -2674135 true false 169 122 8
Circle -2674135 true false 164 132 12
Circle -2674135 true false 167 68 8
Circle -2674135 true false 166 112 8
Circle -2674135 true false 178 121 6
Circle -2674135 true false 156 61 8
Circle -2674135 true false 177 115 8
Circle -2674135 true false 132 130 6
Circle -2674135 true false 150 84 6
Circle -2674135 true false 166 100 6
Circle -2674135 true false 145 91 10
Circle -2674135 true false 159 89 8
Circle -2674135 true false 163 79 12
Circle -2674135 true false 153 75 6
Circle -2674135 true false 156 82 6
Circle -2674135 true false 140 67 12
Circle -2674135 true false 159 74 10
Circle -2674135 true false 126 70 14
Circle -2674135 true false 149 61 6
Circle -2674135 true false 166 93 12
Circle -2674135 true false 152 113 12
Circle -2674135 true false 155 121 14
Circle -2674135 true false 146 119 6
Circle -2674135 true false 149 129 12
Circle -2674135 true false 135 91 10
Circle -2674135 true false 142 60 6
Circle -2674135 true false 119 89 6
Circle -2674135 true false 119 114 14
Circle -2674135 true false 163 63 6
Circle -2674135 true false 184 100 4
Circle -2674135 true false 148 103 8
Circle -2674135 true false 136 63 6
Circle -2674135 true false 155 67 8
Circle -2674135 true false 157 103 12
Circle -7500403 true true 150 164 10
Circle -7500403 true true 134 182 8
Circle -7500403 true true 162 142 10
Circle -7500403 true true 122 139 8
Circle -7500403 true true 161 152 8
Circle -7500403 true true 148 183 6
Circle -7500403 true true 149 188 6
Circle -7500403 true true 141 183 8
Circle -7500403 true true 151 173 8
Circle -7500403 true true 142 176 6
Circle -7500403 true true 144 165 6
Circle -7500403 true true 174 147 0
Circle -7500403 true true 144 170 6
Circle -7500403 true true 151 152 4
Circle -7500403 true true 139 186 8
Circle -7500403 true true 128 139 12
Circle -7500403 true true 169 144 6
Circle -7500403 true true 136 150 4
Circle -7500403 true true 152 155 10
Circle -7500403 true true 127 146 10
Circle -7500403 true true 134 161 10
Circle -7500403 true true 134 151 10
Circle -7500403 true true 134 173 10
Circle -7500403 true true 137 142 10
Circle -7500403 true true 138 185 2
Circle -7500403 true true 147 143 6
Circle -7500403 true true 142 153 10
Circle -7500403 true true 151 141 12
Circle -7500403 true true 146 176 8
Circle -2674135 true false 115 95 8
Circle -2674135 true false 114 107 12
Circle -2674135 true false 131 113 14
Circle -2674135 true false 123 129 6
Circle -2674135 true false 123 98 14
Circle -2674135 true false 126 85 10

ittf world tour 07
true
0
Circle -2674135 true false 174 75 8
Circle -2674135 true false 181 80 6
Circle -2674135 true false 133 63 4
Circle -2674135 true false 144 110 12
Circle -2674135 true false 122 103 10
Circle -2674135 true false 139 79 10
Circle -2674135 true false 170 134 8
Circle -2674135 true false 131 135 10
Circle -2674135 true false 129 67 2
Circle -2674135 true false 120 80 6
Circle -2674135 true false 149 65 4
Circle -2674135 true false 154 98 8
Circle -2674135 true false 182 133 12
Circle -2674135 true false 172 106 8
Circle -2674135 true false 176 96 8
Circle -2674135 true false 178 103 14
Circle -2674135 true false 169 122 8
Circle -2674135 true false 159 133 12
Circle -2674135 true false 167 68 8
Circle -2674135 true false 166 112 8
Circle -2674135 true false 178 121 6
Circle -2674135 true false 156 61 8
Circle -2674135 true false 177 115 8
Circle -2674135 true false 121 130 6
Circle -2674135 true false 150 84 6
Circle -2674135 true false 166 100 6
Circle -2674135 true false 145 91 10
Circle -2674135 true false 159 89 8
Circle -2674135 true false 163 79 12
Circle -2674135 true false 153 75 6
Circle -2674135 true false 156 82 6
Circle -2674135 true false 130 70 12
Circle -2674135 true false 159 74 10
Circle -2674135 true false 118 71 10
Circle -2674135 true false 149 61 6
Circle -2674135 true false 166 92 12
Circle -2674135 true false 154 117 12
Circle -2674135 true false 174 119 14
Circle -2674135 true false 146 119 6
Circle -2674135 true false 149 124 12
Circle -2674135 true false 135 91 10
Circle -2674135 true false 142 60 6
Circle -2674135 true false 113 95 6
Circle -2674135 true false 140 131 14
Circle -2674135 true false 163 63 6
Circle -2674135 true false 184 100 4
Circle -2674135 true false 148 103 8
Circle -2674135 true false 136 63 6
Circle -2674135 true false 155 67 8
Circle -2674135 true false 157 103 12
Circle -7500403 true true 159 196 10
Circle -7500403 true true 132 217 8
Circle -7500403 true true 173 148 10
Circle -7500403 true true 113 147 8
Circle -7500403 true true 163 162 8
Circle -7500403 true true 152 196 6
Circle -7500403 true true 158 216 10
Circle -2674135 true false 143 210 14
Circle -7500403 true true 155 204 12
Circle -7500403 true true 146 175 6
Circle -7500403 true true 144 165 6
Circle -7500403 true true 174 147 0
Circle -7500403 true true 150 170 6
Circle -7500403 true true 151 152 4
Circle -2674135 true false 141 216 8
Circle -7500403 true true 127 148 12
Circle -7500403 true true 168 150 6
Circle -7500403 true true 136 150 4
Circle -7500403 true true 150 159 10
Circle -7500403 true true 118 149 10
Circle -7500403 true true 134 193 10
Circle -7500403 true true 126 155 10
Circle -7500403 true true 133 205 10
Circle -7500403 true true 141 149 10
Circle -7500403 true true 138 185 2
Circle -7500403 true true 182 148 6
Circle -7500403 true true 138 156 10
Circle -7500403 true true 155 182 12
Circle -7500403 true true 142 193 10
Circle -2674135 true false 103 101 8
Circle -2674135 true false 104 127 12
Circle -2674135 true false 116 119 14
Circle -2674135 true false 109 137 6
Circle -2674135 true false 100 112 14
Circle -2674135 true false 126 85 10
Circle -2674135 true false 151 216 8
Circle -7500403 true true 143 182 12
Circle -7500403 true true 134 179 12
Circle -7500403 true true 134 166 12
Circle -7500403 true true 154 169 12
Circle -2674135 true false 146 204 8
Circle -7500403 true true 154 149 12
Circle -7500403 true true 167 154 10
Circle -2674135 true false 136 116 10
Circle -2674135 true false 121 134 10
Circle -2674135 true false 128 115 10
Circle -2674135 true false 131 100 14
Circle -2674135 true false 118 90 14
Circle -2674135 true false 105 83 14
Circle -2674135 true false 186 126 10
Circle -2674135 true false 187 112 14
Circle -2674135 true false 190 99 10
Circle -2674135 true false 184 87 12
Circle -2674135 true false 143 68 10
Circle -2674135 true false 111 103 14
Circle -2674135 true false 137 123 12
Polygon -7500403 true true 90 150
Circle -2674135 true false 215 138 6
Circle -2674135 true false 210 138 6
Circle -2674135 true false 215 144 6
Circle -2674135 true false 85 148 6
Circle -2674135 true false 209 148 6
Circle -2674135 true false 207 157 6
Circle -2674135 true false 203 150 6
Circle -2674135 true false 208 164 6
Circle -2674135 true false 200 163 6
Circle -2674135 true false 205 170 6
Circle -2674135 true false 197 171 6
Circle -2674135 true false 201 178 6
Circle -2674135 true false 199 184 6
Circle -2674135 true false 196 175 6
Circle -2674135 true false 198 189 6
Circle -2674135 true false 193 193 6
Circle -2674135 true false 188 197 6
Circle -2674135 true false 193 199 6
Circle -2674135 true false 187 203 6
Circle -2674135 true false 193 205 6
Circle -2674135 true false 193 211 6
Circle -2674135 true false 187 208 6
Circle -2674135 true false 185 218 6
Circle -2674135 true false 212 152 6
Circle -2674135 true false 176 212 6
Circle -2674135 true false 181 206 6
Circle -2674135 true false 180 198 6
Circle -2674135 true false 171 194 6
Circle -2674135 true false 178 179 6
Circle -2674135 true false 168 180 6
Circle -2674135 true false 171 168 6
Circle -2674135 true false 175 186 6
Circle -2674135 true false 165 170 6
Circle -2674135 true false 171 176 6
Circle -2674135 true false 173 203 4
Circle -2674135 true false 178 194 4
Circle -2674135 true false 79 138 6
Circle -2674135 true false 84 138 6
Circle -2674135 true false 79 144 6
Circle -2674135 true false 91 150 6
Circle -2674135 true false 85 148 6
Circle -2674135 true false 82 152 6
Circle -2674135 true false 87 157 6
Circle -2674135 true false 94 163 6
Circle -2674135 true false 86 164 6
Circle -2674135 true false 89 170 6
Circle -2674135 true false 97 171 6
Circle -2674135 true false 196 175 6
Circle -2674135 true false 95 184 6
Circle -2674135 true false 193 185 6
Circle -2674135 true false 101 185 6
Circle -2674135 true false 96 189 6
Circle -2674135 true false 98 175 6
Circle -2674135 true false 93 178 6
Circle -2674135 true false 101 193 6
Circle -2674135 true false 106 197 6
Circle -2674135 true false 101 199 6
Circle -2674135 true false 101 205 6
Circle -2674135 true false 187 203 6
Circle -2674135 true false 101 211 6
Circle -2674135 true false 107 208 6
Circle -2674135 true false 109 218 6
Circle -2674135 true false 189 214 6
Circle -2674135 true false 105 214 6
Circle -2674135 true false 181 206 6
Circle -2674135 true false 118 212 6
Circle -2674135 true false 123 203 4
Circle -2674135 true false 114 198 6
Circle -2674135 true false 107 203 6
Circle -2674135 true false 123 194 6
Circle -2674135 true false 113 206 6
Circle -2674135 true false 118 194 4
Circle -2674135 true false 119 186 6
Circle -2674135 true false 116 179 6
Circle -2674135 true false 126 180 6
Circle -2674135 true false 123 176 6
Circle -2674135 true false 123 168 6
Circle -2674135 true false 129 170 6

ittf world tour 08
true
0
Circle -2674135 true false 158 73 36
Circle -2674135 true false 181 80 6
Circle -2674135 true false 133 63 4
Circle -2674135 true false 144 110 12
Circle -2674135 true false 122 103 10
Circle -2674135 true false 139 79 10
Circle -2674135 true false 170 134 8
Circle -2674135 true false 115 114 34
Circle -2674135 true false 129 67 2
Circle -2674135 true false 113 73 20
Circle -2674135 true false 149 65 4
Circle -2674135 true false 146 89 20
Circle -2674135 true false 182 133 12
Circle -2674135 true false 172 106 8
Circle -2674135 true false 176 96 8
Circle -2674135 true false 178 103 14
Circle -2674135 true false 110 121 20
Circle -2674135 true false 151 132 14
Circle -2674135 true false 167 68 8
Circle -2674135 true false 166 112 8
Circle -2674135 true false 178 121 6
Circle -2674135 true false 156 61 8
Circle -2674135 true false 177 115 8
Circle -2674135 true false 121 130 6
Circle -2674135 true false 150 84 6
Circle -2674135 true false 166 100 6
Circle -2674135 true false 118 76 44
Circle -2674135 true false 159 89 8
Circle -2674135 true false 163 79 12
Circle -2674135 true false 153 75 6
Circle -2674135 true false 156 82 6
Circle -2674135 true false 124 64 24
Circle -2674135 true false 149 64 30
Circle -2674135 true false 118 71 10
Circle -2674135 true false 149 61 6
Circle -2674135 true false 166 92 12
Circle -2674135 true false 138 101 44
Circle -2674135 true false 167 112 28
Circle -2674135 true false 146 119 6
Circle -2674135 true false 149 124 12
Circle -2674135 true false 135 91 10
Circle -2674135 true false 142 60 6
Circle -2674135 true false 108 90 16
Circle -2674135 true false 140 131 14
Circle -2674135 true false 163 63 6
Circle -2674135 true false 176 92 20
Circle -2674135 true false 148 103 8
Circle -2674135 true false 136 63 6
Circle -2674135 true false 155 67 8
Circle -2674135 true false 156 102 14
Circle -7500403 true true 150 187 16
Circle -7500403 true true 129 206 14
Circle -7500403 true true 173 148 10
Circle -7500403 true true 113 147 8
Circle -7500403 true true 163 162 8
Circle -7500403 true true 152 196 6
Circle -7500403 true true 156 205 14
Circle -2674135 true false 143 210 14
Circle -7500403 true true 155 198 12
Circle -7500403 true true 141 170 16
Circle -7500403 true true 144 165 6
Circle -7500403 true true 174 147 0
Circle -7500403 true true 150 170 6
Circle -7500403 true true 151 152 4
Circle -2674135 true false 141 216 8
Circle -7500403 true true 127 148 12
Circle -7500403 true true 168 150 6
Circle -7500403 true true 136 150 4
Circle -7500403 true true 145 154 20
Circle -7500403 true true 118 149 10
Circle -7500403 true true 131 191 16
Circle -7500403 true true 126 155 10
Circle -7500403 true true 131 201 10
Circle -7500403 true true 141 149 10
Circle -7500403 true true 138 185 2
Circle -7500403 true true 182 148 6
Circle -7500403 true true 134 152 18
Circle -7500403 true true 149 180 16
Circle -7500403 true true 138 180 18
Circle -2674135 true false 97 95 20
Circle -2674135 true false 104 127 12
Circle -2674135 true false 101 114 20
Circle -2674135 true false 109 137 6
Circle -2674135 true false 100 112 14
Circle -2674135 true false 126 85 10
Circle -2674135 true false 151 216 8
Circle -7500403 true true 133 187 12
Circle -7500403 true true 134 179 12
Circle -7500403 true true 134 166 12
Circle -7500403 true true 154 169 12
Circle -2674135 true false 146 204 8
Circle -7500403 true true 154 149 12
Circle -7500403 true true 158 150 18
Circle -2674135 true false 136 116 10
Circle -2674135 true false 121 134 10
Circle -2674135 true false 128 115 10
Circle -2674135 true false 116 103 24
Circle -2674135 true false 118 90 14
Circle -2674135 true false 105 83 14
Circle -2674135 true false 186 126 10
Circle -2674135 true false 187 112 14
Circle -2674135 true false 190 99 10
Circle -2674135 true false 184 87 12
Circle -2674135 true false 135 60 26
Circle -2674135 true false 111 103 14
Circle -2674135 true false 137 123 12
Polygon -7500403 true true 90 150
Circle -2674135 true false 215 138 6
Circle -2674135 true false 210 138 6
Circle -2674135 true false 215 144 6
Circle -2674135 true false 85 148 6
Circle -2674135 true false 203 142 18
Circle -2674135 true false 201 151 18
Circle -2674135 true false 203 150 6
Circle -2674135 true false 208 164 6
Circle -2674135 true false 196 159 14
Circle -2674135 true false 200 168 14
Circle -2674135 true false 192 174 14
Circle -2674135 true false 192 182 16
Circle -2674135 true false 199 184 6
Circle -2674135 true false 196 175 6
Circle -2674135 true false 198 189 6
Circle -2674135 true false 193 193 6
Circle -2674135 true false 182 191 18
Circle -2674135 true false 193 199 6
Circle -2674135 true false 187 203 6
Circle -2674135 true false 187 199 18
Circle -2674135 true false 193 211 6
Circle -2674135 true false 187 208 6
Circle -2674135 true false 179 213 12
Circle -2674135 true false 212 152 6
Circle -2674135 true false 176 212 6
Circle -2674135 true false 181 206 6
Circle -2674135 true false 173 194 14
Circle -2674135 true false 171 194 6
Circle -2674135 true false 178 179 6
Circle -2674135 true false 168 180 6
Circle -2674135 true false 171 168 6
Circle -2674135 true false 175 186 6
Circle -2674135 true false 165 171 6
Circle -2674135 true false 164 169 20
Circle -2674135 true false 173 203 4
Circle -2674135 true false 171 184 16
Circle -2674135 true false 77 134 14
Circle -2674135 true false 84 138 6
Circle -2674135 true false 79 144 6
Circle -2674135 true false 91 150 6
Circle -2674135 true false 81 144 14
Circle -2674135 true false 82 152 6
Circle -2674135 true false 87 157 6
Circle -2674135 true false 94 163 6
Circle -2674135 true false 83 154 16
Circle -2674135 true false 89 170 6
Circle -2674135 true false 97 171 6
Circle -2674135 true false 196 175 6
Circle -2674135 true false 95 184 6
Circle -2674135 true false 190 182 12
Circle -2674135 true false 101 185 6
Circle -2674135 true false 89 175 20
Circle -2674135 true false 98 175 6
Circle -2674135 true false 88 167 14
Circle -2674135 true false 101 193 6
Circle -2674135 true false 106 197 6
Circle -2674135 true false 92 188 24
Circle -2674135 true false 101 205 6
Circle -2674135 true false 187 203 6
Circle -2674135 true false 101 211 6
Circle -2674135 true false 107 208 6
Circle -2674135 true false 104 209 16
Circle -2674135 true false 185 210 14
Circle -2674135 true false 98 209 18
Circle -2674135 true false 175 200 18
Circle -2674135 true false 116 218 6
Circle -2674135 true false 121 203 2
Circle -2674135 true false 114 198 6
Circle -2674135 true false 108 196 6
Circle -2674135 true false 123 194 6
Circle -2674135 true false 102 196 22
Circle -2674135 true false 118 194 4
Circle -2674135 true false 109 184 18
Circle -2674135 true false 116 179 6
Circle -2674135 true false 126 180 6
Circle -2674135 true false 112 172 20
Circle -2674135 true false 120 165 12
Circle -2674135 true false 129 170 6

ittf world tour 09
true
0
Circle -2674135 true false 164 171 22
Circle -2674135 true false 154 78 50
Circle -2674135 true false 181 80 6
Circle -2674135 true false 133 63 4
Circle -2674135 true false 144 110 12
Circle -2674135 true false 122 103 10
Circle -2674135 true false 139 79 10
Circle -2674135 true false 170 134 8
Circle -2674135 true false 111 113 34
Circle -2674135 true false 129 67 2
Circle -2674135 true false 110 60 60
Circle -2674135 true false 149 65 4
Circle -2674135 true false 146 89 20
Circle -2674135 true false 169 127 20
Circle -2674135 true false 172 106 8
Circle -2674135 true false 176 96 8
Circle -2674135 true false 178 103 14
Circle -2674135 true false 110 121 20
Circle -2674135 true false 151 132 14
Circle -2674135 true false 167 68 8
Circle -2674135 true false 166 112 8
Circle -2674135 true false 178 121 6
Circle -2674135 true false 156 61 8
Circle -2674135 true false 177 115 8
Circle -2674135 true false 121 130 6
Circle -2674135 true false 150 84 6
Circle -2674135 true false 166 100 6
Circle -2674135 true false 118 76 44
Circle -2674135 true false 159 89 8
Circle -2674135 true false 163 79 12
Circle -2674135 true false 153 75 6
Circle -2674135 true false 156 82 6
Circle -2674135 true false 124 64 24
Circle -2674135 true false 139 64 56
Circle -2674135 true false 128 81 10
Circle -2674135 true false 149 61 6
Circle -2674135 true false 166 92 12
Circle -2674135 true false 134 103 44
Circle -2674135 true false 154 119 28
Circle -2674135 true false 146 119 6
Circle -2674135 true false 149 124 12
Circle -2674135 true false 135 91 10
Circle -2674135 true false 142 60 6
Circle -2674135 true false 108 90 16
Circle -2674135 true false 136 132 14
Circle -2674135 true false 163 63 6
Circle -2674135 true false 176 92 20
Circle -2674135 true false 148 103 8
Circle -2674135 true false 136 63 6
Circle -2674135 true false 155 67 8
Circle -2674135 true false 156 102 14
Circle -7500403 true true 151 189 16
Circle -7500403 true true 129 206 14
Circle -7500403 true true 169 150 14
Circle -7500403 true true 113 147 8
Circle -7500403 true true 163 162 8
Circle -7500403 true true 152 196 6
Circle -7500403 true true 156 209 18
Circle -2674135 true false 143 210 14
Circle -7500403 true true 155 200 16
Circle -7500403 true true 141 170 16
Circle -7500403 true true 144 165 6
Circle -7500403 true true 174 147 0
Circle -7500403 true true 150 170 6
Circle -7500403 true true 151 152 4
Circle -2674135 true false 141 216 8
Circle -7500403 true true 124 148 20
Circle -7500403 true true 168 150 6
Circle -7500403 true true 136 150 4
Circle -7500403 true true 145 154 20
Circle -7500403 true true 118 149 10
Circle -7500403 true true 130 188 22
Circle -7500403 true true 126 155 10
Circle -7500403 true true 131 201 10
Circle -7500403 true true 141 149 10
Circle -7500403 true true 138 185 2
Circle -7500403 true true 180 150 6
Circle -7500403 true true 132 149 34
Circle -7500403 true true 149 180 16
Circle -7500403 true true 134 167 32
Circle -2674135 true false 99 81 42
Circle -2674135 true false 104 127 12
Circle -2674135 true false 101 114 20
Circle -2674135 true false 99 115 32
Circle -2674135 true false 97 102 30
Circle -2674135 true false 126 85 10
Circle -2674135 true false 151 216 8
Circle -7500403 true true 126 209 16
Circle -7500403 true true 134 166 12
Circle -7500403 true true 154 169 12
Circle -2674135 true false 146 204 8
Circle -7500403 true true 154 149 12
Circle -7500403 true true 159 150 18
Circle -2674135 true false 136 116 10
Circle -2674135 true false 121 134 10
Circle -2674135 true false 128 115 10
Circle -2674135 true false 116 103 24
Circle -2674135 true false 118 90 14
Circle -2674135 true false 105 72 38
Circle -2674135 true false 181 137 10
Circle -2674135 true false 166 108 36
Circle -2674135 true false 160 96 44
Circle -2674135 true false 184 87 12
Circle -2674135 true false 120 56 58
Circle -2674135 true false 111 103 14
Circle -2674135 true false 137 123 12
Polygon -7500403 true true 90 150
Circle -2674135 true false 215 138 6
Circle -2674135 true false 210 138 6
Circle -2674135 true false 215 144 6
Circle -2674135 true false 85 148 6
Circle -2674135 true false 203 142 18
Circle -2674135 true false 201 151 18
Circle -2674135 true false 203 150 6
Circle -2674135 true false 208 164 6
Circle -2674135 true false 196 159 14
Circle -2674135 true false 200 168 14
Circle -2674135 true false 192 174 14
Circle -2674135 true false 192 182 16
Circle -2674135 true false 199 184 6
Circle -2674135 true false 196 175 6
Circle -2674135 true false 198 189 6
Circle -2674135 true false 193 193 6
Circle -2674135 true false 182 191 18
Circle -2674135 true false 193 199 6
Circle -2674135 true false 187 203 6
Circle -2674135 true false 187 199 18
Circle -2674135 true false 193 211 6
Circle -2674135 true false 187 208 6
Circle -2674135 true false 179 213 12
Circle -2674135 true false 212 152 6
Circle -2674135 true false 176 212 6
Circle -2674135 true false 181 206 6
Circle -2674135 true false 173 194 14
Circle -2674135 true false 171 194 6
Circle -2674135 true false 178 179 6
Circle -2674135 true false 168 180 6
Circle -2674135 true false 171 168 6
Circle -2674135 true false 175 186 6
Circle -2674135 true false 165 171 6
Circle -2674135 true false 164 169 20
Circle -2674135 true false 173 203 4
Circle -2674135 true false 171 184 16
Circle -2674135 true false 209 134 14
Circle -2674135 true false 84 138 6
Circle -2674135 true false 79 144 6
Circle -2674135 true false 91 150 6
Circle -2674135 true false 81 144 14
Circle -2674135 true false 82 152 6
Circle -2674135 true false 87 157 6
Circle -2674135 true false 94 163 6
Circle -2674135 true false 83 154 16
Circle -2674135 true false 89 170 6
Circle -2674135 true false 97 171 6
Circle -2674135 true false 196 175 6
Circle -2674135 true false 95 184 6
Circle -2674135 true false 190 182 12
Circle -2674135 true false 101 185 6
Circle -2674135 true false 89 180 20
Circle -2674135 true false 98 175 6
Circle -2674135 true false 84 159 18
Circle -2674135 true false 101 193 6
Circle -2674135 true false 106 197 6
Circle -2674135 true false 192 175 24
Circle -2674135 true false 101 205 6
Circle -2674135 true false 187 203 6
Circle -2674135 true false 101 211 6
Circle -2674135 true false 107 208 6
Circle -2674135 true false 104 209 16
Circle -2674135 true false 185 210 14
Circle -2674135 true false 98 209 18
Circle -2674135 true false 175 200 18
Circle -2674135 true false 116 218 6
Circle -2674135 true false 121 203 2
Circle -2674135 true false 114 198 6
Circle -2674135 true false 108 196 6
Circle -2674135 true false 123 194 6
Circle -2674135 true false 175 195 32
Circle -2674135 true false 118 194 4
Circle -2674135 true false 109 184 18
Circle -2674135 true false 126 180 6
Circle -2674135 true false 168 182 24
Circle -2674135 true false 120 165 12
Circle -2674135 true false 129 170 6
Circle -2674135 true false 196 165 20
Circle -2674135 true false 213 138 14
Circle -2674135 true false 207 147 18
Circle -2674135 true false 203 157 20
Circle -2674135 true false 199 168 20
Circle -2674135 true false 190 189 22
Circle -7500403 true true 134 173 18
Circle -2674135 true false 108 182 24
Circle -2674135 true false 114 171 22
Circle -2674135 true false 75 147 18
Circle -2674135 true false 73 138 14
Circle -2674135 true false 77 134 14
Circle -2674135 true false 203 157 20
Circle -2674135 true false 192 175 24
Circle -2674135 true false 88 189 22
Circle -2674135 true false 93 195 32
Circle -2674135 true false 77 157 20
Circle -2674135 true false 84 175 24
Circle -2674135 true false 81 168 20
Circle -2674135 true false 84 165 20

ittf world tour 10
true
14
Circle -2674135 true false 103 65 95
Circle -2674135 true false 103 72 95
Circle -7500403 true false 103 73 95
Polygon -2674135 true false 142 225 157 225 150 210
Polygon -16777216 true true 75 135 76 136 91 137
Polygon -7500403 true false 75 132
Circle -2674135 true false 103 58 95
Rectangle -2674135 true false 120 105 180 150
Rectangle -16777216 true true 92 142 210 150
Polygon -7500403 true false 135 150 165 150 165 225 150 195 135 225 135 150
Polygon -2674135 true false 205 135 225 135 195 225 174 225 170 204 170 168 174 164 185 195
Polygon -2674135 true false 103 112 102 123 104 129 105 137 109 142 194 142 198 130 198 115 197 106
Polygon -2674135 true false 95 135 75 135 105 225 126 225 130 204 130 168 126 164 115 195

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

serving0
true
0
Circle -7500403 true true 114 240 32
Polygon -7500403 true true 60 160 142 211 150 180 105 135
Circle -7500403 true true 136 181 28
Circle -1 true false 136 184 24
Polygon -7500403 true true 130 197 115 256 139 255 165 195
Polygon -1 true false 135 194 120 255 135 255 161 195
Polygon -1 true false 61 156 150 210 150 186 99 135
Polygon -7500403 true true 141 75 210 120 210 150 111 93
Polygon -1 true false 149 84 211 125 207 144 111 93
Polygon -1 true false 75 150
Polygon -1 true false 165 120
Polygon -1 true false 226 139
Circle -7500403 true true 165 45 60
Circle -1 true false 170 50 50
Circle -7500403 true true 105 75 60
Circle -1 true false 110 80 50
Polygon -7500403 true true 123 77 63 107 75 165 149 131
Circle -7500403 true true 45 105 60
Circle -1 true false 50 110 50
Circle -1 true false 118 244 24
Polygon -7500403 true true 45 135 75 225 105 225 105 150
Circle -7500403 true true 0 255 30
Circle -1 true false 4 259 22
Polygon -7500403 true true 75 210 15 255 30 270 90 240
Circle -7500403 true true 75 210 30
Circle -1 true false 80 215 20
Polygon -1 true false 81 211 13 261 19 272 94 233
Polygon -1 true false 49 135 81 225 100 226 101 145
Circle -7500403 true true 270 127 30
Polygon -7500403 true true 210 120 210 150 285 150 285 135 210 120
Polygon -1 true false 210 137 207 143 285 147 286 139 210 125
Circle -1 true false 274 131 22
Circle -7500403 true true 219 132 44
Polygon -7500403 true true 150 165 195 135 195 120 150 135
Circle -7500403 true true 135 135 30
Circle -1 true false 139 139 22
Polygon -7500403 true true 165 105 165 150 135 150 105 105
Polygon -1 true false 160 105 161 152 139 150 110 103
Polygon -1 true false 125 82 62 113 73 159 150 126
Circle -1 true false 200 125 20
Polygon -6459832 true false 204 125 224 138 218 147 204 139
Circle -7500403 true true 180 120 30
Circle -1 true false 184 124 22
Polygon -1 true false 151 159 196 131 195 123 149 140
Circle -7500403 true true 212 128 46

serving1
true
0
Polygon -7500403 true true 170 197 185 256 161 255 135 195
Circle -7500403 true true 136 181 28
Polygon -7500403 true true 240 160 158 211 150 180 195 135
Polygon -1 true false 239 156 150 210 150 186 201 135
Circle -7500403 true true 37 132 44
Circle -7500403 true true 42 128 46
Polygon -6459832 true false 96 125 76 138 82 147 96 139
Circle -7500403 true true 90 120 30
Circle -1 true false 94 124 22
Circle -7500403 true true 135 135 30
Polygon -7500403 true true 135 105 135 150 165 150 195 105
Polygon -7500403 true true 150 165 105 135 105 120 150 135
Polygon -1 true false 149 159 104 131 105 123 151 140
Circle -1 true false 139 139 22
Polygon -1 true false 140 105 139 152 161 150 190 103
Circle -7500403 true true 0 127 30
Polygon -7500403 true true 90 120 90 150 15 150 15 135 90 120
Polygon -1 true false 90 137 93 143 15 147 14 139 90 125
Circle -1 true false 4 131 22
Polygon -7500403 true true 159 75 90 120 90 150 175 116
Polygon -1 true false 75 150
Polygon -1 true false 165 120
Polygon -1 true false 226 139
Circle -7500403 true true 75 45 60
Circle -1 true false 80 50 50
Circle -7500403 true true 135 75 60
Circle -1 true false 140 80 50
Polygon -7500403 true true 177 77 237 107 225 165 151 131
Circle -7500403 true true 195 105 60
Circle -1 true false 200 110 50
Circle -1 true false 140 184 24
Circle -7500403 true true 154 240 32
Circle -1 true false 158 244 24
Polygon -1 true false 165 194 180 255 165 255 139 195
Polygon -7500403 true true 255 135 225 225 195 225 195 150
Circle -7500403 true true 270 255 30
Circle -1 true false 274 259 22
Polygon -7500403 true true 225 210 285 255 270 270 210 240
Circle -7500403 true true 195 210 30
Circle -1 true false 200 215 20
Polygon -1 true false 219 211 287 261 281 272 206 233
Polygon -1 true false 251 135 219 225 200 226 199 145
Polygon -1 true false 175 82 238 113 227 159 150 126
Circle -1 true false 80 125 20
Polygon -1 true false 151 84 89 125 93 144 165 116

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

sparkle
true
0
Polygon -7500403 true true 0 150 120 120 150 0 180 120 300 150 180 180 150 300 120 180
Polygon -1 true false 0 150 135 135 150 0 165 135 300 150 165 165 150 300 135 165

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

table
true
0
Polygon -16777216 true false 61 31 241 31 256 271 46 271
Polygon -7500403 true true 237 34 151 34 151 145 245 145
Polygon -7500403 true true 64 34 148 34 148 145 57 145
Polygon -7500403 true true 244 153 153 153 153 267 253 267
Polygon -7500403 true true 58 153 150 153 151 267 51 267
Rectangle -16777216 true false 41 131 258 153
Rectangle -1 true false 45 135 255 150
Line -16777216 false 240 270 240 300
Line -16777216 false 60 270 60 300

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

waiting0
true
0
Circle -7500403 true true 75 240 30
Circle -7500403 true true 90 195 30
Circle -1 true false 95 200 20
Polygon -7500403 true true 90 210 75 255 105 255 120 210
Polygon -1 true false 95 209 80 255 100 255 115 210
Circle -1 true false 80 245 20
Polygon -7500403 true true 75 165 90 210 120 210 105 150
Polygon -1 true false 78 163 95 210 120 210 108 148
Polygon -7500403 true true 75 90 165 75 165 105 75 120
Circle -7500403 true true 60 90 30
Polygon -7500403 true true 60 105 75 165 90 165 90 105
Polygon -1 true false 64 105 79 163 87 165 85 105
Circle -7500403 true true 120 270 30
Circle -7500403 true true 120 210 30
Polygon -7500403 true true 120 227 79 183 135 165 150 225
Circle -7500403 true true 72 132 66
Circle -7500403 true true 165 135 30
Circle -1 true false 170 140 20
Polygon -7500403 true true 165 150 150 180 180 180 195 150
Polygon -1 true false 169 150 155 180 174 183 190 149
Circle -1 true false 65 95 20
Polygon -1 true false 72 95 159 81 159 100 73 113
Polygon -7500403 true true 105 210
Circle -7500403 true true 150 105 30
Circle -7500403 true true 133 43 62
Circle -1 true false 139 49 50
Circle -7500403 true true 118 73 62
Polygon -7500403 true true 180 107 180 180 150 180 150 120
Polygon -1 true false 174 105 174 181 156 180 155 105
Circle -7500403 true true 150 165 30
Circle -1 true false 155 170 20
Polygon -7500403 true true 73 152 120 90 177 119 129 179
Polygon -1 true false 81 151 127 93 172 115 123 173
Circle -1 true false 124 79 50
Polygon -1 true false 174 105 174 181 156 180 155 105
Polygon -1 true false 125 225 88 183 130 163 145 225
Circle -1 true false 125 215 20
Polygon -7500403 true true 120 225 120 285 150 285 150 225
Polygon -1 true false 126 223 125 286 145 286 145 224
Circle -1 true false 125 275 20
Circle -1 true false 78 139 52

waiting1
true
0
Polygon -7500403 true true 135 120 150 165 180 165 165 120
Polygon -7500403 true true 120 240 135 180 165 180 150 240
Circle -7500403 true true 135 165 30
Polygon -7500403 true true 150 165 204 138 224 164 150 195
Polygon -1 true false 148 170 188 152 229 157 150 192
Circle -7500403 true true 120 225 30
Polygon -7500403 true true 210 195 222 146 269 142 240 195
Circle -7500403 true true 210 180 30
Circle -1 true false 214 184 22
Circle -7500403 true true 150 90 60
Circle -1 true false 155 95 50
Circle -7500403 true true 210 105 60
Circle -1 true false 215 110 50
Polygon -7500403 true true 180 90 240 105 240 165 180 150
Polygon -1 true false 180 95 241 110 240 162 180 145
Polygon -7500403 true true 240 90 177 102 180 140 240 116
Circle -7500403 true true 161 101 38
Circle -1 true false 165 105 30
Circle -7500403 true true 225 90 30
Circle -1 true false 229 94 22
Polygon -1 true false 240 94 180 105 180 135 241 112
Polygon -7500403 true true 210 195 225 270 255 270 240 195
Circle -7500403 true true 225 255 30
Circle -1 true false 229 259 22
Polygon -1 true false 214 195 230 269 251 269 236 194
Circle -1 true false 139 169 22
Polygon -1 true false 124 239 139 179 161 179 145 243
Circle -1 true false 124 229 22
Circle -7500403 true true 135 105 30
Circle -1 true false 139 109 22
Circle -7500403 true true 150 150 30
Circle -1 true false 154 154 22
Polygon -1 true false 139 120 155 164 176 165 160 119
Circle -7500403 true true 135 150 30
Circle -1 true false 139 154 22
Circle -7500403 true true 120 75 60
Circle -1 true false 125 80 50
Polygon -1 true false 216 192 225 148 264 141 235 195
Polygon -7500403 true true 255 105 255 150 225 150 225 105
Circle -7500403 true true 225 135 30
Circle -1 true false 229 139 22
Polygon -1 true false 251 103 251 151 229 153 229 103

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
