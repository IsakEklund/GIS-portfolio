extensions [gis]

globals [
  traffic-light-groups roads Lcosts nodes path-patches
]

patches-own [
  light-index    ; Tracks current position in color sequence
is-road
overlap-allowed?
allowed-from
infart
  entry-direction
  allowed-directions
  bridge
  imposed-heading
]
breed [arena cat]
turtles-own [
  target-node    ; The node the turtle is moving towards
  speed          ; The speed of the turtle based on the path color
    accumulated-distance  ; Track partial steps for non-integer speeds
  stopped?       ; Whether the turtle is currently stopped
  delay-timer    ; Timer for delayed effects (e.g., switching colors)
  previous-patch ; The patch the turtle was on before moving
start-tick
  entry-heading
]

to setup
  clear-all  ; Reset the world before loading datasets or setting up patches/turtles

  ; Load GIS datasets
  let rasterLayer gis:load-dataset "desp.asc"
  resize-world 0 (gis:width-of rasterLayer - 1) 0 (gis:height-of rasterLayer - 1)
  gis:set-world-envelope gis:envelope-of rasterLayer
  gis:apply-raster rasterLayer is-road
  ask patches with [is-road = 1] [set pcolor orange]

  ask patches with [is-road = 4] [set pcolor orange]

  ask patches with [is-road = 6] [set pcolor blue]

  ask patches with [is-road = 2] [set pcolor blue]

  ask patches with [is-road = 5] [set pcolor magenta]

  ask patches with [is-road = 3] [set pcolor magenta]


 setup-patches
  setup-nodes
  setup-turtles


  set traffic-light-groups (list
    (patches with [pxcor = 328 and pycor = 179])  ; Original
   (patches with [pxcor = 369 and pycor = 118])
    (patches with [pxcor = 410 and pycor = 155])

(patches with [pxcor = 325 and pycor = 178])
    (patches with [pxcor = 245 and pycor = 177])
    (patches with [pxcor = 337 and pycor = 105])
    (patches with [pxcor = 266 and pycor = 139])



      (patches with [pxcor = 299 and pycor = 216])
  )

  foreach traffic-light-groups [
    group ->
    ask group [
      set light-index 0
      update-color
    ]
  ]

  ; Reset the simulation
  reset-ticks
end

to update-color
  ; Define the sequence of colors
  let colors [red yellow green]

  ; Set the patch color based on light-index
  set pcolor item (light-index mod length colors) colors
end

to setup-patches

  ask patch 380 170 [  set pcolor pink]
  ask patch 150 50 [ set pcolor black]
  ask patch 150 51 [ set pcolor black]
  ask patch 151 50 [ set pcolor black]
  ask patch 151 51 [ set pcolor black]
  ask patch 388 173 [ set pcolor black]
  ask patch 387 194 [ set pcolor black]
  ask patch 401 175 [ set pcolor black]
  ask patch 339 244 [ set pcolor black]
  ask patch 339 242 [ set pcolor black]
  ask patch 337 242 [ set pcolor black]
  ask patch 352 226 [ set pcolor black]
  ask patch 353 226 [ set pcolor black]
  ask patch 354 226 [ set pcolor black]
  ask patch 459 90 [ set pcolor black]
  ask patch 458 90 [ set pcolor black]
  ask patch 456 92 [ set pcolor black]
  ask patch 456 90 [ set pcolor black]
  ask patch 455 91 [ set pcolor blue]

  ask patch 402 176 [ set pcolor magenta]
  ask patch 457 93 [ set pcolor magenta]
  ask patch 458 89 [ set pcolor magenta]
  ask patch 457 89 [ set pcolor magenta]
  ask patch 457 90 [ set pcolor magenta]
  ask patch 338 241 [ set pcolor magenta]
  ask patch 338 244 [ set pcolor magenta]
  ask patch 337 245 [ set pcolor magenta]
  ask patch 338 245 [ set pcolor magenta]
  ask patch 337 244 [ set pcolor black]
  ask patch 336 244 [ set pcolor black]
  ask patch 403 173 [ set pcolor black]
  ask patch 472 73 [ set pcolor black]
  ask patch 471 73 [ set pcolor black]
  ask patch 336 243 [ set pcolor blue]
  ask patch 340 243 [ set pcolor blue]
  ask patch 402 172 [ set pcolor magenta]
  ask patch 402 174 [ set bridge true]
  ask patch 338 243 [ set bridge true]
  ask patch 457 91 [ set bridge true]
  ask patch 410 154 [ set pcolor black]
  ask patch 411 154 [ set pcolor black]
  ask patch 327 178 [ set pcolor black]
  ask patch 270 148 [ set pcolor black]
  ask patch 270 147 [ set pcolor black]
  ask patch 215 3 [ set pcolor black]
ask patch 350 91 [ set pcolor black]
  ask patch 301 67 [ set pcolor black]
  ask patches with [
  pxcor >= 45 and pxcor <= 173 and
  pycor >= 2 and pycor <= 29] [set pcolor black]
  ask patches with [
  pxcor >= 265 and pxcor <= 278 and
  pycor >= 164 and pycor <= 175] [set pcolor grey]

  ; setting infart
  ask patch 400 87 [ set allowed-from true]
  ask patch 401 87 [set infart true]
  ask patch 395 82 [ set allowed-from true]
  ask patch 395 83 [set infart true]
  ask patch 408 82 [ set allowed-from true]
  ask patch 408 81 [set infart true]
  ask patch 387 173 [ set allowed-from true]
  ask patch 387 174 [set infart true]
  ask patch 352 227 [ set allowed-from true]
  ask patch 351 227 [set infart true]
  ask patch 389 195 [ set allowed-from true]
  ask patch 390 195 [set infart true]
  ask patch 297 219 [ set allowed-from true]
  ask patch 388 194 [ set allowed-from true]
  ask patch 411 156 [ set allowed-from true]
  ask patch 471 77 [ set allowed-from true]
  ask patch 472 77 [set infart true]
  ask patch 438 105 [ set allowed-from true]
  ask patch 438 104 [ set allowed-from true]
  ask patch 470 74 [set infart true]
  ask patch 471 74 [ set allowed-from true]
  ask patch 386 171 [set infart true]
  ask patch 387 171 [ set allowed-from true]
  ask patch 173 29 [ set allowed-from true]


set path-patches patches with [
  pcolor = green or pcolor = blue or
  pcolor = yellow or
  pcolor = brown or pcolor = orange or
  pcolor = cyan or pcolor = magenta  ; Include node colors
]
; Debugging: Print the number of path patches

  ask patch 2 215 [set overlap-allowed? true]
  ask patch 299 280 [set overlap-allowed? true]
  ask patch 509 275 [set overlap-allowed? true]
  ask patch 553 4 [set overlap-allowed? true]
  ask patch 216 3 [set overlap-allowed? true]
end


to setup-nodes
  set nodes []

  ; Define specific locations for each node type
  let node-locations [
    ["Väg-275" [2 215]]       ; Switch node at (-20, -20)
    ["E4-Norr" [299 280]]  ; Stop-continue node at (20, 20)
    ["E18" [509 275]]          ; Slow node at (-20, 20)
    ["E4-Syd" [553 4]]             ; Stop node at (0, 0)
    ["Sydväst" [216 3]]      ; Continue node at (20, -20)
  ]

  ; Define colors for each node type
  let node-colors [
    ["Väg-275" pink]       ; Switch node is pink
    ["E4-Norr" brown] ; Stop-continue node is brown
    ["E18" green]         ; Slow node is green
    ["E4-Syd" pink]           ; Stop node is red
    ["Sydväst" yellow]    ; Continue node is yellow
  ]

  ; Iterate through the node-locations list
  foreach node-locations [
    [node-info] ->
    let node-type item 0 node-info  ; Extract node type
    let loc item 1 node-info        ; Extract location
    let node patch (item 0 loc) (item 1 loc)  ; Get the patch at the location

    ; Find the corresponding color for this node type
    let node-color item 1 (first (filter [info -> item 0 info = node-type] node-colors))

    ; Set up the node
    ask node [
      set pcolor node-color  ; Set the node color
      set plabel node-type   ; Label the node with its type
    ]

    ; Add the node to the global nodes list
    set nodes lput node nodes
  ]
end


to go
  ; Update all traffic light groups every 10 ticks
  if ticks mod 40 = 0 [
    foreach traffic-light-groups [
      group ->
      ask group [
        set light-index ((light-index + 1) mod 3)  ; Cycle through 0,1,2
        update-color
      ]
    ]
  ]


ask turtles [
  if ticks >= start-tick [
    if not stopped? [
      ; Set speed based on patch color
      let current-patch patch-here
      if [pcolor] of current-patch = green [ set speed 0.25]
      if [pcolor] of current-patch = blue [ set speed 1.2 ]
      if [pcolor] of current-patch = yellow [ set speed 0.5 ]
      if [pcolor] of current-patch = pink [ set speed 0.5 ]
      if [pcolor] of current-patch = magenta [ set speed 2 ]
      if [pcolor] of current-patch = orange [ set speed 0.75 ]
      if [pcolor] of current-patch = brown [ set speed 0.5 ]
      if [pcolor] of current-patch = cyan [ set speed 0.5 ]
        if [pcolor] of current-patch = red [set speed 0.0]

      ; Calculate steps to take this tick
      let total-move (speed + accumulated-distance)
      let integer-steps floor(total-move)
      set accumulated-distance (total-move - integer-steps)

      ; Move for each integer step
      repeat integer-steps [
        let next-patch find-next-patch
        if next-patch = nobody [ stop ]
        face next-patch
        move-to next-patch
        set previous-patch current-patch
        check-node-effects  ; Re-check nodes after each move
        set current-patch patch-here
      ]
    ]

    ; Handle delay timers
    if delay-timer > 0 [ set delay-timer delay-timer - 1 ]
    if delay-timer = 0 [ set stopped? false ]
  ]
]
  tick
end

to apply-node-effect [node-type]
  if node-type = "switch" [
    ifelse delay-timer = 0 [
      set stopped? true
      set delay-timer 10
      set color one-of [yellow orange]
    ] [
      set delay-timer delay-timer - 1
      if delay-timer = 0 [
        set stopped? false
      ]
    ]
  ]
  if node-type = "stop-continue" [
    ifelse random 2 = 0 [
      set stopped? true
      set delay-timer 5
    ] [
      set stopped? false
    ]
  ]
  if node-type = "slow" [
    set speed 0.2
  ]
  if node-type = "stop" [
    set stopped? true
  ]
  if node-type = "continue" [
    set stopped? false  ; Ensure the turtle continues moving
    set speed 1.0   ; Reset speed to default
]
end

to setup-turtles
  create-turtles Turtle-amount [
    set color white
    set size 3
    ; Move the turtle to a valid path patch (green, red, yellow, pink, or brown)
    let spawn-patch patch 295 167
    move-to spawn-patch
    set target-node one-of nodes   ; Assign a random node as the target
    set speed 1.0                  ; Default speed
    set stopped? false
    set delay-timer 0
    set previous-patch nobody  ; Initialize previous-patch
  set start-tick who + 1  ; Assign start tick based on turtle's ID (who)
  ]

end


to-report find-next-patch
  let current-patch patch-here

  if [bridge] of current-patch = true [
    let next-patch patch-ahead 1  ; Set next-patch as the patch directly in front of the turtle
    report next-patch
  ]
  ; Find neighboring patches that are part of the path and not black
  let adjacent-patches neighbors4 with [
    member? self path-patches and pcolor != black
  ]

  ; Exclude the current patch and the previous patch
  set adjacent-patches adjacent-patches with [
    self != current-patch and self != [previous-patch] of myself
  ]
  ; Check for occupied patches and find a new patch if necessary
  set adjacent-patches adjacent-patches with [
    (overlap-allowed? = true) or (count turtles-here = 0) or (count turtles-here with [heading != imposed-heading] > 0)
  ]
  ; Filter adjacent-patches based on allowed-from and infart
  if [infart] of current-patch = true [
    set adjacent-patches adjacent-patches with [allowed-from = true]
  ]
  if [infart] of current-patch = 0 [
    set adjacent-patches adjacent-patches with [allowed-from = 0]
  ]

  ; Ensure turtles can move from allowed-from = true patches
  if [allowed-from] of current-patch = true [
    set adjacent-patches adjacent-patches with [allowed-from = 0 or allowed-from = true]
  ]

  if any? adjacent-patches [
    let next-patch min-one-of adjacent-patches [distance [target-node] of myself]
    report next-patch
  ]

  ; If no valid patches are found, return nobody
  report nobody
end
to check-node-effects
  ; Check if the turtle is on a node and apply the corresponding effect
  let current-patch patch-here
  ; Debugging: Print the current patch and the nodes list

  ; Ensure nodes is a list of patches
  if is-patch-set? nodes [
    if member? current-patch nodes [
      let node-type [plabel] of current-patch  ; Get the node type from the patch label
      apply-node-effect node-type
    ]
  ]
end

to move-towards-node
  ; Move towards the target node
  face target-node
  forward speed

end
@#$#@#$#@
GRAPHICS-WINDOW
109
10
1741
891
-1
-1
2.9
1
10
1
1
1
0
0
0
1
0
559
0
300
0
0
1
ticks
30.0

BUTTON
21
83
295
116
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
21
24
84
57
NIL
ca
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
161
150
224
183
NIL
go
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
63
150
126
183
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

SLIDER
109
24
281
57
Turtle-amount
Turtle-amount
0
3000
3000.0
10
1
NIL
HORIZONTAL

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
NetLogo 6.0.2
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
