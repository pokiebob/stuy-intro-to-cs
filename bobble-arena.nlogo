globals
[
  chealth phealth
  p-jump? pright? pleft?
  plaser? claser?
  phurt? churt?
  pprotec? cprotec?
  plaser-length claser-length
  jump-x
  pbobble-direction cbobble-direction
  pbobble-counter cbobble-counter
  phurt-counter churt-counter
  pshield-counter cshield-counter
]
breed [shields shield]
breed [plines pline]
breed [clines cline]
breed [players player]
breed [computers computer]
breed [ears ear]
breed [lasers laser]

to setup
  ca
  set jump-x -11
  set pbobble-counter 5 set cbobble-counter 5
  set phealth 10 set chealth 10
  ask patches [set pcolor white]
  cro 1 [
    set breed players
    set shape "owo005"
    set color black
    set size 6
    setxy -10 -5
  ]
  cro 1 [
    set breed computers
    set shape "owo015"
    set color black
    set size 6
    setxy 10 -5
  ]
  cro 1 [
    set breed ears
    set shape "ears00"
    set size 6
    setxy -9.5 -2.5
    hide-turtle
  ]
  cro 1 [
    set breed ears
    set shape "ears10"
    set size 6
    setxy 9.5 -2.5
    hide-turtle
  ]
  cro 1 [
    set breed shields
    set shape "circle"
    set size 0
    setxy -10 -5
    hide-turtle
  ]
  cro 1 [
    set breed shields
    set shape "circle"
    set size 0
    setxy 10 -5
    hide-turtle
  ]
end

to go
  ask player 0 [
    if pright? = 1 [
      move-right
    ]
    if pleft? = 1 [
      move-left
    ]
    ifelse plaser? = 1 [
      if color = 0 [set color 5]
      set color color + 10
    ]
    [set color black]
    if phurt? = 1 [
      phurt
    ]
    if xcor > [xcor] of computer 1 - 3 [
      set xcor [xcor] of computer 1 - 3
    ]
    if xcor < -13 [
      set xcor -13
    ]
    jump-up
    pbobble
  ]
  ask computer 1 [
    ifelse claser? = 1 [
      if color = 0 [set color 5]
      set color color + 10
    ]
    [set color black]
    if churt? = 1 [
      churt
    ]
    if xcor > 13 [
      set xcor 13
    ]
    cbobble
  ]
  if pprotec? = 1 [
    pprotec
  ]
  if cprotec? = 1 [
    cprotec
  ]
  if plaser? = 1
  [plaser-beam]
  if claser? = 1
  [claser-beam]
  if plaser? = 0 and claser? = 0
  [ask lasers [die]]
  wait .025
end

to pprotec
  ask ear 2 [
    show-turtle
    set xcor [xcor] of player 0
    if pshield-counter > 4 and pshield-counter <= 12 [
      set shape insert-item 5 "ears0" word "" (round pshield-counter - 4)
    ]
    if pshield-counter < 40 and pshield-counter > 32 [
      ask ears [
        set shape insert-item 5 "ears0" word "" (round (40 - pshield-counter))
      ]
    ]
  ]
  ask player 0 [
    set shape "owo005"
  ]
  ask shield 4 [
    show-turtle
    setxy [xcor] of player 0 [ycor] of player 0
    set color 99 - pshield-counter / 4
    if pshield-counter <= 10  [set size size + .25]
  ]
  if pshield-counter < 8 and (round (pshield-counter * 4) = pshield-counter * 4)  [
    cro 1 [
      set breed plines
      set shape "shield-lines"
      setxy [xcor] of player 0 [ycor] of player 0
      rt (45 + 4) * pshield-counter * 4
    ]
  ]
  ask plines [
    setxy [xcor] of player 0 [ycor] of player 0
    if pshield-counter <= 10  [set size pshield-counter]
    rt 1
  ]
  if pshield-counter > 32 [
    ask shield 4 [set size size - .5]
    ask plines [set size size - .5]
  ]
  set pshield-counter pshield-counter + .25
  if pshield-counter > 42 [
    ask shield 4 [hide-turtle set size 0]
    ask ear 2 [hide-turtle]
    ask plines [die]
    set pshield-counter 0
    set pprotec? 0
  ]
end

to cprotec
  ask ear 3 [
    show-turtle
    set xcor [xcor] of computer 1
    if cshield-counter > 4 and cshield-counter <= 12 [
      set shape insert-item 5 "ears1" word "" (round cshield-counter - 4)
    ]
    if cshield-counter < 40 and cshield-counter > 32 [
      ask ears [
        set shape insert-item 5 "ears1" word "" (round (40 - cshield-counter))
      ]
    ]
  ]
  ask computer 1 [
    set shape "owo015"
  ]
  ask shield 5 [
    show-turtle
    setxy [xcor] of computer 1 [ycor] of computer 1
    set color 99 - cshield-counter / 4
    if cshield-counter <= 10 [set size size + .25]
  ]
  if cshield-counter < 8 and (round (cshield-counter * 4) = cshield-counter * 4)  [
    cro 1 [
      set breed clines
      set shape "shield-lines"
      setxy [xcor] of computer 1 [ycor] of computer 1
      rt (45 + 4) * cshield-counter * 4
    ]
  ]
  ask clines [
    setxy [xcor] of computer 1 [ycor] of computer 1
    if cshield-counter <= 10 [set size cshield-counter]
    rt 1
  ]
  if cshield-counter > 32 [
    ask shield 5 [set size size - .5]
    ask clines [set size size - .5]
  ]
  set cshield-counter cshield-counter + .25
  if cshield-counter > 42 [
    ask shield 5 [hide-turtle set size 0]
    ask ear 3 [hide-turtle]
    ask clines [die]
    set cshield-counter 0
    set cprotec? 0
  ]
end

to phurt
  set xcor xcor - .4
  set color 15 + phealth / 2
  set shape "owo008"
  set heading -45
  set phurt-counter phurt-counter + 1
  if phurt-counter >= 10 [
    set phurt-counter 0
    set phurt? 0
    set heading 0
  ]
end

to churt
  set xcor xcor + .4
  set color 15 + chealth / 2
  set shape "owo018"
  set heading 45
  set churt-counter churt-counter + 1
  if churt-counter >= 10 [
    set churt-counter 0
    set churt? 0
    set heading 0
  ]
end

to plaser-beam
  if pbobble-counter <= 1 [
    create-lasers 1 [
      set size 2
      set breed lasers
      set shape "laser"
      set xcor [xcor] of player 0 + plaser-length
      set ycor -3.5
      set plaser-length plaser-length + 1
      if xcor > [xcor] of computer 1 - 5 and cshield-counter > 4 and cshield-counter < 36 [
        wait .5
        set plaser? 0
        set plaser-length 0
      ]
      if xcor > [xcor] of computer 1 - 3 [
        wait .5
        set plaser? 0
        set plaser-length 0
        set chealth chealth - 3
        set churt? 1
      ]
    ]
  ]
end

to claser-beam
  if cbobble-counter <= 1 [
    create-lasers 1 [
      set size 2
      set breed lasers
      set shape "laser"
      set xcor [xcor] of computer 1 - claser-length
      set ycor -3.5
      set claser-length claser-length + 1
      if xcor < [xcor] of player 0 + 5 and pshield-counter > 4 and pshield-counter < 36 [
        wait .5
        set claser? 0
        set claser-length 0
      ]
      if xcor < [xcor] of player 0 + 3 [
        wait .5
        set claser? 0
        set claser-length 0
        set phealth phealth - 3
        set phurt? 1
      ]
    ]
  ]
end

to pbobble
  if round pbobble-counter = pbobble-counter
  [set shape replace-item 5 shape word "" pbobble-counter]
  if pbobble-direction = 0 [
    set pbobble-counter pbobble-counter + .5
    if pbobble-counter = 9 [set pbobble-direction 1]
  ]
  if pbobble-direction = 1 [
    set pbobble-counter pbobble-counter - .5
    if pbobble-counter <= 1
    [ifelse plaser? = 0
      [set pbobble-direction 0]
      [set pbobble-counter 1 set shape "owo000"]
    ]
  ]
end

to cbobble
  if round cbobble-counter = cbobble-counter
  [set shape replace-item 5 shape word "" cbobble-counter]
  if cbobble-direction = 0 [
    set cbobble-counter cbobble-counter + .5
    if cbobble-counter = 9 [set cbobble-direction 1]
  ]
  if cbobble-direction = 1 [
    set cbobble-counter cbobble-counter - .5
    if cbobble-counter <= 1
    [ifelse claser? = 0
      [set cbobble-direction 0]
      [set cbobble-counter 1 set shape "owo010"]
    ]
  ]
end

to jump-up
  if jump-x >= -10 [
    ifelse jump-x < 0
    [set ycor ycor + .025 * jump-x ^ 2 set jump-x jump-x + 1]
    [set ycor ycor - .025 * jump-x ^ 2 set jump-x jump-x + 1]
  ]
  if jump-x > 10 [set jump-x -11]
end

to move-right
  set xcor xcor + .4
  set shape replace-item 4 shape "0"
  if round pbobble-counter = pbobble-counter [
    ifelse (item 3 shape) = "1"
    [set shape replace-item 3 shape "0"]
    [set shape replace-item 3 shape "1"]
  ]
  set pright? 0
end

to move-left
  set xcor xcor - .4
  set shape replace-item 4 shape "1"
  if round pbobble-counter = pbobble-counter [
    ifelse (item 3 shape) = "1"
    [set shape replace-item 3 shape "0"]
    [set shape replace-item 3 shape "1"]
  ]
  set pleft? 0
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
10
1
1
1
0
1
1
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
23
38
86
71
NIL
setup
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
30
89
93
122
NIL
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
10
406
104
439
A
if pprotec? = 0 [set pleft? 1]
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
110
406
202
439
D
if pprotec? = 0 [set pright? 1]
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

BUTTON
11
267
203
300
LASER BEAM
set plaser? 1
NIL
1
T
OBSERVER
NIL
K
NIL
NIL
1

TEXTBOX
698
48
848
66
testing
11
0.0
1

BUTTON
692
91
793
124
NIL
set claser? 1
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
689
143
799
176
NIL
set cprotec? 1
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
12
309
203
342
SHIELD
set pprotec? 1
NIL
1
T
OBSERVER
NIL
L
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
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

ears00
true
0
Polygon -7500403 true true 135 240
Polygon -1 true false 175 81 176 105 176 131 175 151 174 163 165 170 154 162 144 145 129 104 124 71 126 50 135 25 146 14 158 14 167 23 172 36 173 56
Polygon -2064490 true false 159 18 146 23 141 46 143 76 147 100 151 119 159 138 169 154 175 164 178 132 177 107 178 77 175 48 169 27 158 17
Polygon -1 true false 130 81 131 105 131 131 130 151 129 163 120 170 109 162 99 145 84 104 79 71 81 50 90 25 101 14 113 14 122 23 127 36 128 56
Polygon -2064490 true false 114 18 101 23 96 46 98 76 102 100 106 119 114 138 124 154 130 164 133 132 132 107 133 77 130 48 124 27 113 17

ears01
true
0
Polygon -7500403 true true 135 240
Polygon -1 true false 175 81 176 105 176 131 175 151 174 163 165 170 154 162 144 145 129 104 133 58 149 28 168 17 180 14 195 17 199 27 193 34 182 52
Polygon -2064490 true false 178 23 166 31 158 45 148 67 147 100 151 119 159 138 169 154 175 164 178 132 177 107 178 77 187 48 197 33 190 26
Polygon -1 true false 130 81 131 105 131 131 130 151 129 163 120 170 109 162 99 145 84 104 88 58 104 28 123 17 135 14 150 17 154 27 148 34 137 52
Polygon -2064490 true false 133 23 121 31 113 45 103 67 102 100 106 119 114 138 124 154 130 164 133 132 132 107 133 77 142 48 152 33 145 26

ears02
true
0
Polygon -7500403 true true 135 240
Polygon -1 true false 178 82 176 105 176 131 175 151 174 163 165 170 153 159 141 128 139 97 141 74 147 48 167 30 183 23 195 23 206 29 210 42 203 61
Polygon -2064490 true false 201 37 189 35 169 43 155 64 150 88 151 114 159 138 169 154 175 164 178 132 177 107 181 82 194 70 204 60 209 46
Polygon -1 true false 133 82 131 105 131 131 130 151 129 163 120 170 108 159 96 128 94 97 96 74 102 48 122 30 138 23 150 23 161 29 165 42 158 61
Polygon -2064490 true false 156 37 144 35 124 43 110 64 105 88 106 114 114 138 124 154 130 164 133 132 132 107 136 82 149 70 159 60 164 46

ears03
true
0
Polygon -7500403 true true 135 240
Polygon -1 true false 197 81 187 99 176 130 175 150 174 162 167 169 157 155 151 128 148 95 155 60 167 45 187 30 208 25 223 33 232 49 227 64 212 77
Polygon -2064490 true false 222 50 212 43 199 45 181 52 165 73 158 96 160 127 169 154 175 164 178 132 186 106 198 85 213 78 226 67 227 58
Polygon -1 true false 152 81 142 99 131 130 130 150 129 162 122 169 112 155 106 128 103 95 110 60 122 45 142 30 163 25 178 33 187 49 182 64 167 77
Polygon -2064490 true false 177 50 167 43 154 45 136 52 120 73 113 96 115 127 124 154 130 164 133 132 141 106 153 85 168 78 181 67 182 58

ears04
true
0
Polygon -7500403 true true 135 240
Polygon -1 true false 233 89 208 97 189 112 178 150 174 162 165 164 161 156 155 124 158 87 175 60 185 50 201 46 218 44 232 47 240 55 245 69 240 80
Polygon -2064490 true false 233 65 222 59 207 60 190 68 178 78 165 101 166 129 169 153 175 163 182 137 191 114 208 101 222 97 235 90 240 80
Polygon -1 true false 188 89 163 97 144 112 133 150 129 162 120 164 116 156 110 124 113 87 130 60 140 50 156 46 173 44 187 47 195 55 200 69 195 80
Polygon -2064490 true false 188 65 177 59 162 60 145 68 133 78 120 101 121 129 124 153 130 163 137 137 146 114 163 101 177 97 190 90 195 80

ears05
true
0
Polygon -7500403 true true 135 240
Polygon -1 true false 226 107 203 108 187 126 178 149 174 161 165 163 161 155 159 124 168 82 195 59 217 54 241 57 260 75 264 91 258 116 240 119 232 116
Polygon -2064490 true false 235 110 228 100 215 85 202 84 193 85 178 99 166 127 169 151 175 161 184 135 194 120 205 111 222 110 235 119 236 114
Polygon -1 true false 181 107 158 108 142 126 133 149 129 161 120 163 116 155 114 124 123 82 150 59 172 54 196 57 215 75 219 91 213 116 195 119 187 116
Polygon -2064490 true false 190 110 183 100 170 85 157 84 148 85 133 99 121 127 124 151 130 161 139 135 149 120 160 111 177 110 190 119 191 114

ears06
true
0
Polygon -7500403 true true 135 240
Polygon -1 true false 216 119 204 113 187 126 178 149 174 161 164 164 159 140 164 111 177 83 210 70 248 68 268 83 274 101 271 121 260 133 240 137 224 130
Polygon -2064490 true false 231 127 236 126 237 115 232 102 218 93 202 95 187 109 177 130 175 160 184 134 194 119 206 113 218 118 225 131 229 129
Polygon -1 true false 171 119 159 113 142 126 133 149 129 161 119 164 114 140 119 111 132 83 165 70 203 68 223 83 229 101 226 121 215 133 195 137 179 130
Polygon -2064490 true false 186 127 191 126 192 115 187 102 173 93 157 95 142 109 132 130 130 160 139 134 149 119 161 113 173 118 180 131 184 129

ears07
true
0
Polygon -7500403 true true 135 240
Polygon -1 true false 210 119 205 117 190 129 177 152 171 163 161 157 164 135 171 106 181 90 200 75 225 75 256 89 267 117 259 144 243 161 227 158 215 146
Polygon -7500403 true true 192 122
Polygon -2064490 true false 195 135
Polygon -2064490 true false 172 159 188 124 193 115 202 111 209 114 191 128
Polygon -1 true false 165 119 160 117 145 129 132 152 126 163 116 157 119 135 126 106 136 90 155 75 180 75 211 89 222 117 214 144 198 161 182 158 170 146
Polygon -2064490 true false 127 159 143 124 148 115 157 111 164 114 146 128

ears08
true
0
Polygon -7500403 true true 135 240
Polygon -1 true false 192 151 185 152 184 153 180 156 171 162 161 156 164 134 171 105 181 89 198 79 214 78 223 85 230 99 233 122 223 146 209 157 198 156
Polygon -7500403 true true 192 122
Polygon -2064490 true false 195 135
Polygon -1 true false 147 151 140 152 139 153 135 156 126 162 116 156 119 134 126 105 136 89 153 79 169 78 178 85 185 99 188 122 178 146 164 157 153 156

ears10
true
0
Polygon -7500403 true true 165 240
Polygon -1 true false 125 81 124 105 124 131 125 151 126 163 135 170 146 162 156 145 171 104 176 71 174 50 165 25 154 14 142 14 133 23 128 36 127 56
Polygon -2064490 true false 141 18 154 23 159 46 157 76 153 100 149 119 141 138 131 154 125 164 122 132 123 107 122 77 125 48 131 27 142 17
Polygon -1 true false 170 81 169 105 169 131 170 151 171 163 180 170 191 162 201 145 216 104 221 71 219 50 210 25 199 14 187 14 178 23 173 36 172 56
Polygon -2064490 true false 186 18 199 23 204 46 202 76 198 100 194 119 186 138 176 154 170 164 167 132 168 107 167 77 170 48 176 27 187 17

ears11
true
0
Polygon -7500403 true true 165 240
Polygon -1 true false 122 82 124 105 124 131 125 151 126 163 135 170 147 159 159 128 161 97 159 74 153 48 133 30 117 23 105 23 94 29 90 42 97 61
Polygon -2064490 true false 99 37 111 35 131 43 145 64 150 88 149 114 141 138 131 154 125 164 122 132 123 107 119 82 106 70 96 60 91 46
Polygon -1 true false 167 82 169 105 169 131 170 151 171 163 180 170 192 159 204 128 206 97 204 74 198 48 178 30 162 23 150 23 139 29 135 42 142 61
Polygon -2064490 true false 144 37 156 35 176 43 190 64 195 88 194 114 186 138 176 154 170 164 167 132 168 107 164 82 151 70 141 60 136 46

ears12
true
0
Polygon -7500403 true true 165 240
Polygon -1 true false 122 82 124 105 124 131 125 151 126 163 135 170 147 159 159 128 161 97 159 74 153 48 133 30 117 23 105 23 94 29 90 42 97 61
Polygon -2064490 true false 99 37 111 35 131 43 145 64 150 88 149 114 141 138 131 154 125 164 122 132 123 107 119 82 106 70 96 60 91 46
Polygon -1 true false 167 82 169 105 169 131 170 151 171 163 180 170 192 159 204 128 206 97 204 74 198 48 178 30 162 23 150 23 139 29 135 42 142 61
Polygon -2064490 true false 144 37 156 35 176 43 190 64 195 88 194 114 186 138 176 154 170 164 167 132 168 107 164 82 151 70 141 60 136 46

ears13
true
0
Polygon -7500403 true true 165 240
Polygon -1 true false 103 81 113 99 124 130 125 150 126 162 133 169 143 155 149 128 152 95 145 60 133 45 113 30 92 25 77 33 68 49 73 64 88 77
Polygon -2064490 true false 78 50 88 43 101 45 119 52 135 73 142 96 140 127 131 154 125 164 122 132 114 106 102 85 87 78 74 67 73 58
Polygon -1 true false 148 81 158 99 169 130 170 150 171 162 178 169 188 155 194 128 197 95 190 60 178 45 158 30 137 25 122 33 113 49 118 64 133 77
Polygon -2064490 true false 123 50 133 43 146 45 164 52 180 73 187 96 185 127 176 154 170 164 167 132 159 106 147 85 132 78 119 67 118 58

ears14
true
0
Polygon -7500403 true true 165 240
Polygon -1 true false 67 89 92 97 111 112 122 150 126 162 135 164 139 156 145 124 142 87 125 60 115 50 99 46 82 44 68 47 60 55 55 69 60 80
Polygon -2064490 true false 67 65 78 59 93 60 110 68 122 78 135 101 134 129 131 153 125 163 118 137 109 114 92 101 78 97 65 90 60 80
Polygon -1 true false 112 89 137 97 156 112 167 150 171 162 180 164 184 156 190 124 187 87 170 60 160 50 144 46 127 44 113 47 105 55 100 69 105 80
Polygon -2064490 true false 112 65 123 59 138 60 155 68 167 78 180 101 179 129 176 153 170 163 163 137 154 114 137 101 123 97 110 90 105 80

ears15
true
0
Polygon -7500403 true true 165 240
Polygon -1 true false 74 107 97 108 113 126 122 149 126 161 135 163 139 155 141 124 132 82 105 59 83 54 59 57 40 75 36 91 42 116 60 119 68 116
Polygon -2064490 true false 65 110 72 100 85 85 98 84 107 85 122 99 134 127 131 151 125 161 116 135 106 120 95 111 78 110 65 119 64 114
Polygon -1 true false 119 107 142 108 158 126 167 149 171 161 180 163 184 155 186 124 177 82 150 59 128 54 104 57 85 75 81 91 87 116 105 119 113 116
Polygon -2064490 true false 110 110 117 100 130 85 143 84 152 85 167 99 179 127 176 151 170 161 161 135 151 120 140 111 123 110 110 119 109 114

ears16
true
0
Polygon -7500403 true true 165 240
Polygon -1 true false 84 119 96 113 113 126 122 149 126 161 136 164 141 140 136 111 123 83 90 70 52 68 32 83 26 101 29 121 40 133 60 137 76 130
Polygon -2064490 true false 69 127 64 126 63 115 68 102 82 93 98 95 113 109 123 130 125 160 116 134 106 119 94 113 82 118 75 131 71 129
Polygon -1 true false 129 119 141 113 158 126 167 149 171 161 181 164 186 140 181 111 168 83 135 70 97 68 77 83 71 101 74 121 85 133 105 137 121 130
Polygon -2064490 true false 114 127 109 126 108 115 113 102 127 93 143 95 158 109 168 130 170 160 161 134 151 119 139 113 127 118 120 131 116 129

ears17
true
0
Polygon -7500403 true true 165 240
Polygon -1 true false 90 119 95 117 110 129 123 152 129 163 139 157 136 135 129 106 119 90 100 75 75 75 44 89 33 117 41 144 57 161 73 158 85 146
Polygon -7500403 true true 108 122
Polygon -2064490 true false 105 135
Polygon -2064490 true false 128 159 112 124 107 115 98 111 91 114 109 128
Polygon -1 true false 135 119 140 117 155 129 168 152 174 163 184 157 181 135 174 106 164 90 145 75 120 75 89 89 78 117 86 144 102 161 118 158 130 146
Polygon -2064490 true false 173 159 157 124 152 115 143 111 136 114 154 128

ears18
true
0
Polygon -7500403 true true 165 240
Polygon -1 true false 108 151 115 152 116 153 120 156 129 162 139 156 136 134 129 105 119 89 102 79 86 78 77 85 70 99 67 122 77 146 91 157 102 156
Polygon -7500403 true true 108 122
Polygon -2064490 true false 105 135
Polygon -1 true false 153 151 160 152 161 153 165 156 174 162 184 156 181 134 174 105 164 89 147 79 131 78 122 85 115 99 112 122 122 146 136 157 147 156

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

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

laser
false
0
Rectangle -2674135 true false 0 0 300 330
Rectangle -955883 true false 0 15 300 285
Rectangle -1184463 true false 0 30 300 270
Rectangle -10899396 true false 0 45 300 255
Rectangle -13840069 true false 0 60 300 240
Rectangle -14835848 true false 0 75 300 225
Rectangle -11221820 true false 0 90 300 210
Rectangle -13791810 true false 0 105 300 195
Rectangle -13345367 true false 0 120 300 180
Rectangle -16777216 true false 0 135 300 165

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

owo000
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true -75 0 240
Circle -1 true false -60 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 105 270 150 300
Rectangle -1 true false 165 255 195 285
Rectangle -1 true false 105 255 135 285
Circle -16777216 true false 30 90 30
Circle -16777216 true false 30 30 30

owo001
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true -60 0 240
Circle -1 true false -45 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 105 270 150 300
Rectangle -1 true false 165 255 195 285
Rectangle -1 true false 105 255 135 285
Circle -16777216 true false 45 90 30
Circle -16777216 true false 60 30 30

owo002
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true -30 0 240
Circle -1 true false -15 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 105 270 150 300
Rectangle -1 true false 165 255 195 285
Rectangle -1 true false 105 255 135 285
Circle -16777216 true false 75 90 30
Circle -16777216 true false 120 45 30

owo003
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true 0 0 240
Circle -1 true false 15 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 105 270 150 300
Rectangle -1 true false 165 255 195 285
Rectangle -1 true false 105 255 135 285
Circle -16777216 true false 90 90 30
Circle -16777216 true false 150 60 30

owo004
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true 15 0 240
Circle -1 true false 30 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 105 270 150 300
Rectangle -1 true false 165 255 195 285
Rectangle -1 true false 105 255 135 285
Circle -16777216 true false 120 90 30
Circle -16777216 true false 180 75 30

owo005
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true 30 0 240
Circle -1 true false 45 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 105 270 150 300
Rectangle -1 true false 165 255 195 285
Rectangle -1 true false 105 255 135 285
Circle -16777216 true false 135 90 30
Circle -16777216 true false 195 90 30

owo006
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true 45 0 240
Circle -1 true false 60 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 105 270 150 300
Rectangle -1 true false 165 255 195 285
Rectangle -1 true false 105 255 135 285
Circle -16777216 true false 150 90 30
Circle -16777216 true false 210 105 30

owo007
true
0
Rectangle -7500403 true true 105 270 150 300
Circle -7500403 true true 60 0 240
Circle -1 true false 75 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 150 270 195 300
Rectangle -1 true false 105 255 135 285
Rectangle -1 true false 165 255 195 285
Circle -16777216 true false 180 90 30
Circle -16777216 true false 240 120 30

owo008
true
0
Rectangle -7500403 true true 105 270 150 300
Circle -7500403 true true 90 0 240
Circle -1 true false 105 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 150 270 195 300
Rectangle -1 true false 105 255 135 285
Rectangle -1 true false 165 255 195 285
Circle -16777216 true false 195 90 30
Circle -16777216 true false 240 135 30

owo009
true
0
Rectangle -7500403 true true 105 270 150 300
Circle -7500403 true true 120 0 240
Circle -1 true false 135 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 150 270 195 300
Rectangle -1 true false 105 255 135 285
Rectangle -1 true false 165 255 195 285
Circle -16777216 true false 225 90 30
Circle -16777216 true false 240 150 30

owo010
true
0
Rectangle -7500403 true true 105 270 150 300
Circle -7500403 true true 135 0 240
Circle -1 true false 150 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 150 270 195 300
Rectangle -1 true false 105 255 135 285
Rectangle -1 true false 165 255 195 285
Circle -16777216 true false 240 90 30
Circle -16777216 true false 240 30 30

owo011
true
0
Rectangle -7500403 true true 105 270 150 300
Circle -7500403 true true 120 0 240
Circle -1 true false 135 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 150 270 195 300
Rectangle -1 true false 105 255 135 285
Rectangle -1 true false 165 255 195 285
Circle -16777216 true false 225 90 30
Circle -16777216 true false 210 30 30

owo012
true
0
Rectangle -7500403 true true 105 270 150 300
Circle -7500403 true true 90 0 240
Circle -1 true false 105 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 150 270 195 300
Rectangle -1 true false 105 255 135 285
Rectangle -1 true false 165 255 195 285
Circle -16777216 true false 195 90 30
Circle -16777216 true false 150 45 30

owo013
true
0
Rectangle -7500403 true true 105 270 150 300
Circle -7500403 true true 60 0 240
Circle -1 true false 75 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 150 270 195 300
Rectangle -1 true false 105 255 135 285
Rectangle -1 true false 165 255 195 285
Circle -16777216 true false 180 90 30
Circle -16777216 true false 120 60 30

owo014
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true 45 0 240
Circle -1 true false 60 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 105 270 150 300
Rectangle -1 true false 165 255 195 285
Rectangle -1 true false 105 255 135 285
Circle -16777216 true false 150 90 30
Circle -16777216 true false 90 75 30

owo015
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true 30 0 240
Circle -1 true false 45 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 105 270 150 300
Rectangle -1 true false 165 255 195 285
Rectangle -1 true false 105 255 135 285
Circle -16777216 true false 135 90 30
Circle -16777216 true false 75 90 30

owo016
true
0
Rectangle -7500403 true true 105 270 150 300
Circle -7500403 true true 15 0 240
Circle -1 true false 30 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 150 270 195 300
Rectangle -1 true false 105 255 135 285
Rectangle -1 true false 165 255 195 285
Circle -16777216 true false 120 90 30
Circle -16777216 true false 60 105 30

owo017
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true 0 0 240
Circle -1 true false 15 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 105 270 150 300
Rectangle -1 true false 165 255 195 285
Rectangle -1 true false 105 255 135 285
Circle -16777216 true false 90 90 30
Circle -16777216 true false 30 120 30

owo018
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true -30 0 240
Circle -1 true false -15 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 105 270 150 300
Rectangle -1 true false 165 255 195 285
Rectangle -1 true false 105 255 135 285
Circle -16777216 true false 75 90 30
Circle -16777216 true false 30 135 30

owo019
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true -60 0 240
Circle -1 true false -45 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 270
Rectangle -7500403 true true 105 270 150 300
Rectangle -1 true false 165 255 195 285
Rectangle -1 true false 105 255 135 285
Circle -16777216 true false 45 90 30
Circle -16777216 true false 30 150 30

owo100
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true -75 0 240
Circle -1 true false -60 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 30 90 30
Circle -16777216 true false 30 30 30

owo101
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true -60 0 240
Circle -1 true false -45 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 45 90 30
Circle -16777216 true false 60 30 30

owo102
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true -30 0 240
Circle -1 true false -15 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 75 90 30
Circle -16777216 true false 120 45 30

owo103
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true 0 0 240
Circle -1 true false 15 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 90 90 30
Circle -16777216 true false 150 60 30

owo104
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true 15 0 240
Circle -1 true false 30 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 120 90 30
Circle -16777216 true false 180 75 30

owo105
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true 30 0 240
Circle -1 true false 45 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 135 90 30
Circle -16777216 true false 195 90 30

owo106
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true 45 0 240
Circle -1 true false 60 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 150 90 30
Circle -16777216 true false 210 105 30

owo107
true
0
Rectangle -7500403 true true 105 270 150 300
Circle -7500403 true true 60 0 240
Circle -1 true false 75 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 180 90 30
Circle -16777216 true false 240 120 30

owo108
true
0
Rectangle -7500403 true true 105 270 150 300
Circle -7500403 true true 90 0 240
Circle -1 true false 105 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 195 90 30
Circle -16777216 true false 240 135 30

owo109
true
0
Rectangle -7500403 true true 105 270 150 300
Circle -7500403 true true 120 0 240
Circle -1 true false 135 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 225 90 30
Circle -16777216 true false 240 150 30

owo110
true
0
Rectangle -7500403 true true 105 270 150 300
Circle -7500403 true true 135 0 240
Circle -1 true false 150 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 240 90 30
Circle -16777216 true false 240 30 30

owo111
true
0
Rectangle -7500403 true true 105 270 150 300
Circle -7500403 true true 120 0 240
Circle -1 true false 135 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 225 90 30
Circle -16777216 true false 210 30 30

owo112
true
0
Rectangle -7500403 true true 105 270 150 300
Circle -7500403 true true 90 0 240
Circle -1 true false 105 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 195 90 30
Circle -16777216 true false 150 45 30

owo113
true
0
Rectangle -7500403 true true 105 270 150 300
Circle -7500403 true true 60 0 240
Circle -1 true false 75 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 180 90 30
Circle -16777216 true false 120 60 30

owo114
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true 45 0 240
Circle -1 true false 60 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 150 90 30
Circle -16777216 true false 90 75 30

owo115
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true 30 0 240
Circle -1 true false 45 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 120 255 180 270
Rectangle -7500403 true true 105 270 150 300
Rectangle -1 true false 150 255 195 285
Rectangle -1 true false 105 255 150 285
Circle -16777216 true false 135 90 30
Circle -16777216 true false 75 90 30

owo116
true
0
Rectangle -7500403 true true 105 270 150 300
Circle -7500403 true true 15 0 240
Circle -1 true false 30 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 120 90 30
Circle -16777216 true false 60 105 30

owo117
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true 0 0 240
Circle -1 true false 15 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 90 90 30
Circle -16777216 true false 30 120 30

owo118
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true -30 0 240
Circle -1 true false -15 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 75 90 30
Circle -16777216 true false 30 135 30

owo119
true
0
Rectangle -7500403 true true 150 270 195 300
Circle -7500403 true true -60 0 240
Circle -1 true false -45 15 210
Rectangle -7500403 true true 90 240 210 300
Rectangle -1 true false 105 255 195 285
Circle -16777216 true false 45 90 30
Circle -16777216 true false 30 150 30

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

shield-lines
true
0
Line -1 false 300 150 45 255
Line -1 false 255 45 45 255
Line -1 false 150 0 45 255
Line -1 false 45 45 45 255
Line -1 false 255 255 45 255
Line -1 false 150 300 45 255
Line -1 false 0 150 45 255

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
