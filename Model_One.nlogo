
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Alice Williams, PhD Thesis code, 2019;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
             ;;;;; Model_1 ;;;;;
             ;;;;;;;;;;;;;;;;;;;



;;;;;;;;
;;; ABSTRACT ENVRIONMENTAL CIRCUMSCRIPTION MODEL - MODEL 1, version 9.9.9.5
;;;;;;;;


;;;;;;;;;;;;;
;;; MODEL ;;;
;;;;;;;;;;;;;



globals [
  average-hierarchy
  max-hierarchy
  average-polity-hierarchy
  group-size
  total-polities
  total-polities-attacking
  total-villages-fragmenting
  step-time
]


breed [arch-polities arch-polity]  ;to record polity information, and call all villages of that polity
breed [villages village]  ;active agents
breed [environments environment] ;agents to randomly allocate a certain number of green patches




;;; AGENT SPECIFICATIONS  - the properties that each village can have

arch-polities-own [
  whole-polity
  target-polity
  attacking
  polity-villages
  polity-resources
  attacking-tally
  maximum-hierarchy
  size-of-polity
]

villages-own [
  polity
  hierarchy
  level-above
  level-below
  resources
  nearest-neighbour
  defending
  benefit-move
  benefit-remain
  hier-resid
  fragmenting
  fragmenting-tally

  ]

patches-own [
  land-resources
  village-claim
  potential-escape
  territory
  ]






;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; TO SET UP THE WORLD ;;; (create the villages, place them in the world and give some of their attributes values)


;;;;;;;;;;
;; LINE ;;

to setup-line

  clear-all
  reset-ticks

 ;;ASSIGNING land type to patches

 ; LINES ;;;;;

  ask patches with [pxcor >= line2] [set pcolor 0]
  ask patches with [pxcor < line2 and pxcor >= line1] [set pcolor 52]
  ask patches with [pxcor < line1] [set pcolor 0]


    ifelse count patches with [pcolor = 52] > 0
    [
      ask patches with [pcolor = 52] [set land-resources fertile-land]
      ask patches with [pcolor = black] [set land-resources barren-land]
      ]

    [
    ask patches [set land-resources barren-land ]
    ]


  create-all-turtles


end



;;;;;;;;;;;;
;; RANDOM ;;

to setup-random

  clear-all
  reset-ticks

  create-environments green-patches [  ;to create the number of pseudo-turtles as number of green patches which are wanted

  let new-empty-patch one-of patches with [count turtles-here < 1]  ;so that there will always be the same number of green patches (the same patch won't be allocated green twice)
  setxy [pxcor] of new-empty-patch [pycor] of new-empty-patch  ;randomly choose a patch to be located on
  ask patch-here [
    set pcolor 52] ]

  ask environments [die]  ;to leave only the green patches

    ifelse count patches with [pcolor = 52] > 0
    [
      ask patches with [pcolor = 52] [set land-resources fertile-land]
      ask patches with [pcolor = black] [set land-resources barren-land]
      ]

    [
    ask patches [set land-resources barren-land ]
    ]

  create-all-turtles


end



;;;;;;;;;;;;;
;; STRIPES ;;

to setup-stripes

  clear-all
  reset-ticks

  create-environments number-stripes [

    let new-empty-patch one-of patches with [pcolor = 0 and count neighbors4 with [pcolor = 0] = 4]
    setxy [pxcor] of new-empty-patch [pycor] of new-empty-patch

    ask patch-here [
      set pcolor 52]

    ask patches with [pxcor = [xcor] of myself ] [
      set pcolor 52]
  ]

  ask environments [die]

    ifelse count patches with [pcolor = 52] > 0
    [
      ask patches with [pcolor = 52] [set land-resources fertile-land]
      ask patches with [pcolor = black] [set land-resources barren-land]
      ]

    [
    ask patches [set land-resources barren-land ]
    ]

  create-all-turtles

end








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CREATE VILLAGES AND ARCH-POLITIES ;;



to create-all-turtles



  ;to create the active village turtles

  ifelse count patches with [pcolor = 52] > 0  ;if there are patches with a higher yield, then villages are places in that area

     [create-villages initial-villages  [
       let new-empty-patch one-of patches with [count turtles-here < 1 and pcolor = 52]  ;patches can be occupied by more than one village
       setxy [pxcor] of new-empty-patch [pycor] of new-empty-patch

       set polity [who] of self   ;villages need a polity name, and easiest to assign each one their own individual number at the start

       set hierarchy 1

       set level-above 0
       set level-below 0

       set defending false

       set resources [land-resources] of patch-here

       ifelse polity < 14
         [set color polity * 10 + 5]
         [set color ((polity - 10 ) * 10 + 5)]

     ] ]

     [create-villages initial-villages  [
       let new-empty-patch one-of patches with [count turtles-here < 1]
       setxy [pxcor] of new-empty-patch [pycor] of new-empty-patch

       set polity [who] of self   ;villages need a polity name, and easiest to assign each one their own individual number at the start

       set hierarchy 1

       set level-above 0
       set level-below 0

       set defending false

       set resources [land-resources] of patch-here

       ifelse polity < 14
         [set color polity * 10 + 5 ]
         [set color ((polity - 10) * 10 + 5)]
     ] ]


  ask villages with [who = 0] [die]  ;to make labels less confusing (zero level-above or -below means none, rather than an agent name)


  ;to create the OVERALL POLITY LIST (info held by invisible turtles which do not interact with the normal village turtles)

  let new count villages
  create-arch-polities new [
    set whole-polity who - new
    set polity-resources sum [resources] of villages with [polity = [whole-polity] of myself]
    set polity-villages true
    set attacking false
    set target-polity false
    hide-turtle
  ]


end









;;;;;;;;;;;;;;;;;
;;;;; MODEL ;;;;;


to go


  tick

  reset-timer

  if total-polities = 1 [stop]

  ask arch-polities [
    ifelse any? villages with [polity = [whole-polity] of myself]
    [set polity-villages true]
    [set polity-villages false]
  ]

  if links? [update-links]

  battle-polities

  set total-polities-attacking count arch-polities with [attacking-tally = true] ;to record the number of polities attacking in the time step
  ask arch-polities with [attacking-tally = true] [set attacking-tally false] ;to reset the count of attacking polities for the next time step

  if links? [update-links]

  fragment

  set total-villages-fragmenting count villages with [fragmenting-tally = true] ;to record the number of villages fragmenting from their polity in the time step
  ask villages with [fragmenting-tally = true] [set fragmenting-tally false]  ;to reset the count of fragmenting villages for the next time step

  if links? [update-links]


  set average-hierarchy mean [hierarchy] of villages

  ask arch-polities with [polity-villages = true] [set maximum-hierarchy max [hierarchy] of villages with [polity = [whole-polity] of myself] ]
  set average-polity-hierarchy mean [maximum-hierarchy] of arch-polities with [polity-villages = true]

  ask arch-polities with [polity-villages = true] [set size count villages with [polity = [whole-polity] of myself] ]
  set group-size max [size-of-polity] of arch-polities with [polity-villages = true]

  let lowest-rank max-one-of villages [hierarchy]
  set max-hierarchy [hierarchy] of lowest-rank

  set total-polities count arch-polities with [polity-villages = true]

  set step-time timer

end


;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; UPDATE-LINKS ;;;;;;


to update-links

  ;to build links up again
    ask villages [

      let subordinates villages with [who = [level-above] of myself]

           if count subordinates != 0 [
            create-link-with one-of villages with [who = [level-above] of myself]
               ask my-links [
                  set thickness 0.3
                  set color [color] of myself] ]

    ]
end




;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; BATTLE ;;;;;;;;;;;;



to battle-polities

ask arch-polities [

  ifelse random-float 1 > probability-attack

  [
    ;do nothing because no attack
  ]

  [
    ;ATTACK because probability attack condition has been met!

    ;to make sure that the polity does in fact have villages
    ifelse polity-villages = false or polity-resources = 0 ;so that only polities with living villages and enough resources (that the villages won't die afterwards) can enter into battle

    [
     ;do nothing because the polity has no villages or resources
      ]

    [
     ;polity has villages, so can attack a neighbouring polity

    ;to count the number of polities attacking each time step
    set attacking-tally true


      ;to make sure that there is another polity which can be attacked (if not, do nothing)
      ifelse not any? villages with [polity = [whole-polity] of myself]
       [
        ;do nothing because the polity doesn't actually have any villages
         ]

       [
        ;if there is another polity to attack:
         set attacking true


         let my-village one-of villages with [polity = [whole-polity] of myself] ;"my-village" is one polity in the attacking polity, chosen at random, to attack another polity

         let attacking-villages villages with [polity = [polity] of my-village]



          ;to identify any villages within a certain area of the attacking village
          ask my-village [
            ask patches in-radius conquering-area [set territory true]
            ask patch-here [set territory false]
            ask patches with [count villages-here < 1] [set territory false]
            ask patches with [territory = true]
                  [if any? villages-here with [polity = [polity] of my-village]
                    [set territory false] ]
          ]


         let rival-villages villages-on patches with [territory = true]

         ifelse count rival-villages > 0

          [
          ;if there is a rival-village in the conquering-area

         let target-village one-of rival-villages
         let target-villages villages with [polity = [polity] of target-village] ;to identify the whole target polity

         ask one-of arch-polities with [whole-polity = [polity] of target-village] [set target-polity true] ;to identify the whole polity which is being attacked




         ;; attacking polity will always attack ;;
         ;;;;; PROBABILITY OF WINNING ;;;;;

         let attacker-resources sum [resources] of villages with [polity = [whole-polity] of myself]

         let defender-resources sum [resources] of villages with [polity = [whole-polity] of one-of arch-polities with [target-polity = true]]

         let pwin attacker-resources / (attacker-resources + defender-resources)


      ifelse random-float 1 > pwin ;the higher the probability of attacking, the less likley to choose not to attack


      [
       ;DO NOTHING BECAUSE LOST

       ;to reset all the code for the next round of village attack

       set attacking false
       ask villages with [nearest-neighbour = true] [set nearest-neighbour false]
       ask arch-polities with [target-polity = true] [set target-polity false]

         ]





      [
       ;WIN ATTACK


       ; IDENTIFY DEFEATED POLITY VILLAGES ;

       ;;; need to identify the villages in the defeated polity which may be conquered
       ;identified by setting 'defending = true'

          ;the attacking arch-polity is doing the asking here:
          ;so ask the defending arch-polity to identify all of the villages in its polity

          ask one-of arch-polities with [target-polity = true] [
            ask villages with [polity = [whole-polity] of myself]
            [set defending true]
            ]


          ;end of code asking attacking village to identify a rival polity






        ; CHOOSE POTENTIAL ESCAPE PATCH ;

        ;;; next step, all defending villages need to decide whether they want to move or not

         ask villages with [defending = true] [ ;ask villages (#1)


          ;to identify an escape patch

             ask patches in-radius 1 [set potential-escape true]

             ask patch-here [set potential-escape false]

            ask patches with [count villages-here >= 1] [set potential-escape false]


            ifelse count patches with [potential-escape = true] = 0


              [
               ;there are no potential escape patches

               ;DO NOTHING - don't need to count resources of potential escape patch because it will be 0
               set benefit-move 0

               ]




              [
               ;there is at least one escape patch

               ; TO CHOOSE BEST OF POTENTIAL ESCAPE PATCHES ;

               ifelse [pcolor] of one-of patches with [potential-escape = true] = 52


               [
                 ;if there are neighbouring dark green patches, decide whether to move to dark green or black land

                 let surrounding-environ sum [land-resources] of patches with [potential-escape = true]

                 let green-total sum [land-resources] of patches with [potential-escape = true and pcolor = 52]

                 ifelse random-float surrounding-environ <= green-total

                 [
                   ;choose one of the green patches to move to

                   ask one-of patches with [potential-escape = true and pcolor = 52] [set village-claim [who] of myself]
                  ]


                 [
                   ;choose one of the black patches to move to

                   ask one-of patches with [potential-escape = true and pcolor = black] [set village-claim [who] of myself]
                  ]

                ] ;end of code if there are any dark green potential escape patches



                [
                 ;choose any of the neighbouring black patches to move to

                 ask one-of patches with [potential-escape = true] [set village-claim [who] of myself]

                ] ;end of code if all potential escape patches are black


              ];end of code for choosing best of potential escape patches, if there are any escape patches to choose from



             ;;;to reset the patches for the next turn (potential escape patch has now been labelled by village-claim number)

              ask patches with [potential-escape = true] [set potential-escape false]


         ] ;#1 end of code asking defending villages to identify their choice of potential escape patch






        ; DECIDE WHETHER TO MOVE OR STAY ;
        ;; based on costs and benefits of becoming subordinate vs moving (current patch - tribute vs escape patch)

        ask villages with [defending = true] [ ;ask villages (#2)



              ;if the escape patch has more resources than the current patch - the tribute cost of remaining subordinate, set benefit move to nothing

              set benefit-remain [land-resources] of patch-here - ([land-resources] of patch-here * tribute)

              ifelse one-of patches with [village-claim = [who] of myself] != nobody
              [
                 set benefit-move [land-resources] of one-of patches with [village-claim = [who] of myself]
                ]

              [
                set benefit-move 0 ;if there is nowhere free to move to, set the benefits of moving to 0
                ]



             ] ;end of target villages to run code (#2)







         ; ALL OF DEFENDING VILLAGES TO DECIDE WHETHER TO MOVE OR STAY ;
         ;; based on total votes for move or stay

           let total-remain sum [benefit-remain] of villages with [defending = true]

           let total-move sum [benefit-move] of villages with [defending = true]

           if total-remain = 0 and total-move = 0 [ ;to avoid impossible division by 0, will make it 50/50 chance of moving
             set total-remain 1
             set total-move 1 ]

           let probability-of-moving total-move / (total-move + total-remain)


           ;; to leave or stay based on number of votes:

           ask one-of arch-polities with [target-polity = true] [  ;code section #3


             ifelse random-float 1 < probability-of-moving


              ;;; TO LEAVE ;;;


              [
                ;the defending villages move elsewhere and remains autonomous

               ask villages with [defending = true] [


                ifelse one-of patches with [village-claim = [who] of myself] = nobody
                [
                  ;remain autonomous but do not move

                  set defending false
                  set benefit-remain 0
                  set benefit-move 0
                  if nearest-neighbour = true [set nearest-neighbour false]


                  ;reset escape patches

                   ask patches with [village-claim = [who] of myself] [
                      set village-claim 0 ] ;end of code to reset the escape patches (no village claim)


                  ;reset target arch-polity

                  ask arch-polities with [target-polity = true] [set target-polity false]

                  ]


                [
                  ;if there is a patch to move to

                   ;to ask defending villages to move and remain in their original polity

                   move-to one-of patches with [village-claim = [who] of myself]
                   set defending false
                   set benefit-remain 0
                   set benefit-move 0
                   if nearest-neighbour = true [set nearest-neighbour false]


                   ;to reset the escape patches

                   ask patches with [village-claim = [who] of myself] [
                      set village-claim 0 ] ;end of code to reset the escape patches (no village claim)


                   ;to reset the target arch-polity

                   ask arch-polities with [target-polity = true] [set target-polity false]


                  ] ;end of code for polity to move and remain autonomous if there are any escape patches

                ] ;end of code to ask defending villages to leave

              ] ;end of code to LEAVE





              ;;; TO REMAIN ;;;


              [
               ;DECIDED TO REMAIN

              if links? [ ask links [die] ];to reset all the links

                ask target-villages with [hierarchy = 1] [
                     set level-above [who] of one-of attacking-villages with [hierarchy = 1]
                    set polity [polity] of one-of attacking-villages
                    set hierarchy 2

                    if any? other target-villages [
                      ask other target-villages [
                      set hierarchy hierarchy + 1
                      set polity [polity] of one-of attacking-villages ]
                    ]
                  ]



                 ;to reset level-below of villages

                ask villages [set level-below 0]


                ask villages  [
                  ask villages with [who = [level-above] of myself] [
                    set level-below [who] of myself] ]


               ;to reset the target polity to take loss of villages into account

               ask arch-polities with [target-polity = true] [

                set polity-villages false] ;should not be any target villages left


               ;to reset the rest of the defending village attributes

               ask villages with [defending = true] [
                 set defending false
                 set benefit-move 0
                 set benefit-remain 0
                 if nearest-neighbour = true [set nearest-neighbour false] ]



               ask villages [
                 ifelse polity < 14
                    [set color polity * 10 + 5 ]
                    [set color ((polity - 10) * 10 + 5)]
                    ]


            ] ;end of code to REMAIN




         ] ;end of asking target villages (#3) to either stay or move based on the number of votes in the polity

               ;to reset any potential escape patches

               ask patches with [village-claim != 0] [
                  set village-claim 0]



        ] ;end of code if win the attack


        ;;;; to reset the arch-polities at the end of the attacking turn

         set attacking false
         ask arch-polities with [target-polity = true] [set target-polity false]

        ] ;if there is a rival village in the conquering-area

        [] ;do nothing if there is no rival village in conquerable distance


      ] ;end of code for if there are any villages with recognise that they are part of the polity


    ] ;end of code for if the attacking arch-polity has any villages and resources in the polity

  ] ;end of ifelse attack condition is met

] ;end of asking each polity to work out probability attack


end








;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; FRAGMENTATION ;;;;;;;;

;to allow for villages within the polity to decide to break away from the polity
;one village per polity within each time step will decide whether to fragment or not
;if they fragment then all of their subordinates will  too
;code does not apply to villages with hierarchy = 1 (because would make no difference if fragment or not)

to fragment

  ask arch-polities [

    ;ask any one of the villages which are not the head village of the polity:

    if any? villages with [polity = [whole-polity] of myself and hierarchy > 1] [
      let rebel one-of villages with [polity = [whole-polity] of myself and hierarchy > 1]

      ask rebel [

          ;set deciding-to-fragment true

          ifelse random-float 1 < pfragment



          ;; fragment ;;

          [
         ; set decided-to-fragment true

          ask links [die]

          set fragmenting-tally true

          ;to identify all subordinates to also leave

          if any? villages with [polity = [polity] of rebel and level-above = [who] of rebel] [
            let subordinates villages with [polity = [polity] of rebel and level-above = [who] of rebel]
            ask subordinates [
                set fragmenting true] ]


          repeat count villages [   ;to repeat this section of code for as many times as there are villages

            ask villages with [fragmenting = true] [
             if villages with [level-above = [who] of myself] != nobody [
               ask villages with [level-above = [who] of myself] [
                 set fragmenting true] ] ]

             ]

          ask villages with [fragmenting = true] [
            set hier-resid hierarchy - [hierarchy] of rebel ]

          ;to change polity of the primary fragmenting village
          set polity [who] of rebel
          set level-above 0
          set hierarchy 1
          ifelse polity < 14
                    [set color polity * 10 + 5 ]
                    [set color ((polity - 10) * 10 + 5)]


           ;to reset level-below of villages (beacuse target village has moved)

           ask villages [set level-below 0]

           ask villages  [
               ask villages with [who = [level-above] of myself] [
                 set level-below [who] of myself] ]


          ;to change subordinates of the primary fragmenting village
          if any? villages with [fragmenting = true] [
            ask villages with [fragmenting = true] [
              set polity [polity] of rebel
              set hierarchy [hierarchy] of rebel + hier-resid
              set color [color] of rebel
            ]
          ]


          ;to build all the links again, from the bottom up
          ask villages with [level-above != 0] [
           if links? [
              create-link-with one-of villages with [who = [level-above] of myself]
            ask my-links [
                   set thickness 0.3
                   set color [color] of myself]
            ]
          ]

          ask villages with [fragmenting = true] [
            set fragmenting false]



          ]



          ;; don't fragment ;;

          [
           ;do nothing, polity remains intact
            ]



      ];end of asking the rebelling village

    ];end of identifying one of the villages in the polity to rebel

  ];end of asking each arch polity to identify a village in their polity to rebel



end
@#$#@#$#@
GRAPHICS-WINDOW
274
10
711
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

SLIDER
14
16
227
49
initial-villages
initial-villages
0
100
50.0
1
1
NIL
HORIZONTAL

BUTTON
15
57
96
90
NIL
setup-line
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
48
142
111
175
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
117
142
180
175
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
36
284
208
317
line1
line1
-17
17
-16.0
1
1
NIL
HORIZONTAL

SLIDER
36
318
208
351
line2
line2
-17
17
15.0
1
1
NIL
HORIZONTAL

PLOT
718
10
1328
214
Average hierarchy
step
average-hierarchy
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"average hierarchy" 1.0 0 -16777216 true "" "plot average-hierarchy"
"max hierarchy" 1.0 0 -5204280 true "" "plot max-hierarchy"
"average polity hierarchy" 1.0 0 -13791810 true "" "plot average-polity-hierarchy"

SLIDER
36
187
208
220
fertile-land
fertile-land
0
100
5.0
1
1
NIL
HORIZONTAL

SLIDER
36
220
208
253
barren-land
barren-land
0
100
4.5
1
1
NIL
HORIZONTAL

SLIDER
323
474
495
507
tribute
tribute
0
1
0.5
0.1
1
NIL
HORIZONTAL

PLOT
719
217
1234
469
hierarchy frequency
hierarchy level
villages
1.0
20.0
0.0
10.0
true
false
"" ""
PENS
"villages" 1.0 1 -16777216 true "" "histogram [hierarchy] of villages"

SLIDER
35
365
207
398
green-patches
green-patches
0
1089
1056.0
1
1
NIL
HORIZONTAL

BUTTON
103
57
227
90
NIL
setup-random
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
49
96
166
129
NIL
setup-stripes
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
37
410
209
443
number-stripes
number-stripes
0
14
14.0
1
1
NIL
HORIZONTAL

SLIDER
500
474
672
507
pfragment
pfragment
0
1
0.1
0.1
1
NIL
HORIZONTAL

SLIDER
37
460
209
493
probability-attack
probability-attack
0
1
1.0
0.1
1
NIL
HORIZONTAL

SWITCH
38
503
141
536
links?
links?
1
1
-1000

PLOT
228
520
682
677
Number of fragmenting villages
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot total-villages-fragmenting"

SLIDER
41
548
213
581
conquering-area
conquering-area
0
40
5.0
1
1
NIL
HORIZONTAL

PLOT
698
478
1159
652
Polity size (maximum)
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot group-size"

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
NetLogo 6.0.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="3" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
      <value value="-15"/>
      <value value="-15"/>
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-15"/>
      <value value="-10"/>
      <value value="0"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="high-yield">
      <value value="0.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="total-resources">
      <value value="50"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="3" runMetricsEveryStep="true">
    <setup>setup-square</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-x-axis">
      <value value="-16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="min-y-axis">
      <value value="-16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-x-axis">
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="high-yield">
      <value value="0.7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="total-resources">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-y-axis">
      <value value="16"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="ecological_gradient" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="line1">
      <value value="-11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="total-resources">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-11"/>
      <value value="-8"/>
      <value value="0"/>
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mid-yield">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="high-yield">
      <value value="0.8"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="ecological_gradient_high" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="line1">
      <value value="-2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line3">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line4">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="total-resources">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mid-yield">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-lightgreen">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-black">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="high-yield">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-darkgreen">
      <value value="0.9"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="ecological_gradient_medium" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="line1">
      <value value="-8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line3">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line4">
      <value value="9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="total-resources">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mid-yield">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-lightgreen">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-black">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="high-yield">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-darkgreen">
      <value value="0.9"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="ecological_gradient_low" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="line1">
      <value value="-13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line3">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line4">
      <value value="14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="total-resources">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mid-yield">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-lightgreen">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-black">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="high-yield">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-darkgreen">
      <value value="0.9"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="low-circumscription-gradient" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="line1">
      <value value="-14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-14"/>
      <value value="-4"/>
      <value value="-7"/>
      <value value="-11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line3">
      <value value="16"/>
      <value value="6"/>
      <value value="9"/>
      <value value="13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line4">
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-darkgreen">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-black">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="high-yield">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-lightgreen">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="total-resources">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mid-yield">
      <value value="0.2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="mid-circumscription-gradient" repetitions="3" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="line1">
      <value value="-7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-7"/>
      <value value="-2"/>
      <value value="-4"/>
      <value value="-5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line3">
      <value value="8"/>
      <value value="3"/>
      <value value="4"/>
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line4">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-darkgreen">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-black">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="high-yield">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-lightgreen">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="total-resources">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mid-yield">
      <value value="0.2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="high-circumscription-gradient" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="line1">
      <value value="-2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-2"/>
      <value value="-1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line3">
      <value value="3"/>
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line4">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-darkgreen">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-black">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="high-yield">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-lightgreen">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="total-resources">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mid-yield">
      <value value="0.2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="extending-gradient" repetitions="3" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="line1">
      <value value="-2"/>
      <value value="-3"/>
      <value value="-7"/>
      <value value="-12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line3">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line4">
      <value value="3"/>
      <value value="4"/>
      <value value="8"/>
      <value value="13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-lightgreen">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-black">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-darkgreen">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="circumscription_with_neighbours" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="mid-yield">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="high-yield">
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="total-resources">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-darkgreen">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="15"/>
      <value value="0"/>
      <value value="-10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-black">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="less_likely_to_move_distance" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="village-sight">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="probability_winning" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="prob-moving-darkgreen">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-10"/>
      <value value="0"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prob-moving-black">
      <value value="0"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="pwin" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-10"/>
      <value value="0"/>
      <value value="15"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="parameter_space" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-10"/>
      <value value="0"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="1"/>
      <value value="1.1"/>
      <value value="1.2"/>
      <value value="1.3"/>
      <value value="1.4"/>
      <value value="1.5"/>
      <value value="1.6"/>
      <value value="1.7"/>
      <value value="1.8"/>
      <value value="1.9"/>
      <value value="2"/>
      <value value="2.1"/>
      <value value="2.2"/>
      <value value="2.3"/>
      <value value="2.4"/>
      <value value="2.5"/>
      <value value="2.6"/>
      <value value="2.7"/>
      <value value="2.8"/>
      <value value="2.9"/>
      <value value="3"/>
      <value value="3.1"/>
      <value value="3.2"/>
      <value value="3.3"/>
      <value value="3.4"/>
      <value value="3.5"/>
      <value value="3.6"/>
      <value value="3.7"/>
      <value value="3.8"/>
      <value value="3.9"/>
      <value value="4"/>
      <value value="4.1"/>
      <value value="4.2"/>
      <value value="4.3"/>
      <value value="4.4"/>
      <value value="4.5"/>
      <value value="4.6"/>
      <value value="4.7"/>
      <value value="4.8"/>
      <value value="4.9"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.15"/>
      <value value="0.2"/>
      <value value="0.25"/>
      <value value="0.3"/>
      <value value="0.35"/>
      <value value="0.4"/>
      <value value="0.45"/>
      <value value="0.5"/>
      <value value="0.55"/>
      <value value="0.6"/>
      <value value="0.65"/>
      <value value="0.7"/>
      <value value="0.75"/>
      <value value="0.8"/>
      <value value="0.85"/>
      <value value="0.9"/>
      <value value="0.95"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="smaller_parameter_space" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-10"/>
      <value value="0"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0"/>
      <value value="0.2"/>
      <value value="0.4"/>
      <value value="0.6"/>
      <value value="0.8"/>
      <value value="1"/>
      <value value="1.2"/>
      <value value="1.4"/>
      <value value="1.6"/>
      <value value="1.8"/>
      <value value="2"/>
      <value value="2.2"/>
      <value value="2.4"/>
      <value value="2.6"/>
      <value value="2.8"/>
      <value value="3"/>
      <value value="3.2"/>
      <value value="3.4"/>
      <value value="3.6"/>
      <value value="3.8"/>
      <value value="4"/>
      <value value="4.2"/>
      <value value="4.4"/>
      <value value="4.6"/>
      <value value="4.8"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="environ_random" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <steppedValueSet variable="green-patches" first="0" step="50" last="1000"/>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="one_graph" repetitions="1000" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="barren-land">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-10"/>
      <value value="0"/>
      <value value="15"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="max_hier" repetitions="1" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="500"/>
    <metric>max-hierarchy</metric>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>[hierarchy] of villages</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="hierarchy_bins" repetitions="4" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <metric>hierarchy1</metric>
    <metric>hierarchy2</metric>
    <metric>hierarchy3</metric>
    <metric>hierarchy4</metric>
    <metric>hierarchy5</metric>
    <metric>hierarchy6</metric>
    <metric>hierarchy7</metric>
    <metric>hierarchy8</metric>
    <metric>hierarchy9</metric>
    <metric>hierarchy10</metric>
    <metric>hierarchy+</metric>
    <enumeratedValueSet variable="line2">
      <value value="-10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="landtype_bins" repetitions="20" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="500"/>
    <metric>green-land</metric>
    <metric>black-land</metric>
    <enumeratedValueSet variable="line2">
      <value value="-10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="equal_distribution_land" repetitions="4" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="10000"/>
    <metric>green-land</metric>
    <metric>black-land</metric>
    <enumeratedValueSet variable="line1">
      <value value="-16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="total_area_range" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-12"/>
      <value value="-11"/>
      <value value="-10"/>
      <value value="-9"/>
      <value value="-8"/>
      <value value="-7"/>
      <value value="-6"/>
      <value value="-5"/>
      <value value="-4"/>
      <value value="-3"/>
      <value value="-2"/>
      <value value="-1"/>
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
      <value value="5"/>
      <value value="6"/>
      <value value="7"/>
      <value value="8"/>
      <value value="9"/>
      <value value="10"/>
      <value value="11"/>
      <value value="12"/>
      <value value="13"/>
      <value value="14"/>
      <value value="15"/>
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="environ_stripes" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-stripes</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <steppedValueSet variable="number-stripes" first="0" step="1" last="14"/>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="environ_lines" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-12"/>
      <value value="-11"/>
      <value value="-10"/>
      <value value="-9"/>
      <value value="-8"/>
      <value value="-7"/>
      <value value="-6"/>
      <value value="-5"/>
      <value value="-4"/>
      <value value="-3"/>
      <value value="-2"/>
      <value value="-1"/>
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
      <value value="5"/>
      <value value="6"/>
      <value value="7"/>
      <value value="8"/>
      <value value="9"/>
      <value value="10"/>
      <value value="11"/>
      <value value="12"/>
      <value value="13"/>
      <value value="14"/>
      <value value="15"/>
      <value value="16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="hierarchy_trees_line" repetitions="1" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>count villages with [polity = 1]</metric>
    <metric>count villages with [polity = 2]</metric>
    <metric>count villages with [polity = 3]</metric>
    <metric>count villages with [polity = 4]</metric>
    <metric>count villages with [polity = 5]</metric>
    <metric>count villages with [polity = 6]</metric>
    <metric>count villages with [polity = 7]</metric>
    <metric>count villages with [polity = 8]</metric>
    <metric>count villages with [polity = 9]</metric>
    <metric>count villages with [polity = 10]</metric>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="collapse_small_parameter_space" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.3"/>
      <value value="0.5"/>
      <value value="0.7"/>
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-10"/>
      <value value="-5"/>
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="different_rebellion" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="pfragment">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <steppedValueSet variable="green-patches" first="50" step="50" last="1000"/>
  </experiment>
  <experiment name="Experiment4" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0"/>
      <value value="0.5"/>
      <value value="1"/>
      <value value="1.5"/>
      <value value="2"/>
      <value value="2.5"/>
      <value value="3"/>
      <value value="3.5"/>
      <value value="4"/>
      <value value="4.5"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="51"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Experiment9" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <steppedValueSet variable="green-patches" first="0" step="50" last="1050"/>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
      <value value="0.6"/>
      <value value="0.7"/>
      <value value="0.8"/>
      <value value="0.9"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="51"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Ex4" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="pfragment">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-6"/>
      <value value="15"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Ex3" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="pfragment">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
      <value value="0.75"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="66"/>
      <value value="297"/>
      <value value="990"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Ex2" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-stripes</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="pfragment">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="0.9"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-stripes">
      <value value="9"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Ex5" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-stripes</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="pfragment">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0"/>
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-stripes">
      <value value="9"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Ex6" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="pfragment">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="66"/>
      <value value="297"/>
      <value value="990"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Ex1" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line
setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="pfragment">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
      <value value="0.75"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-6"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="990"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Linear_hierarchy_pattern" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="pfragment">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
      <value value="0.75"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-6"/>
      <value value="0"/>
      <value value="10"/>
      <value value="15"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="parameters_ThreeBins" repetitions="100" runMetricsEveryStep="true">
    <setup>setup-line
setup-random</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="0"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="66"/>
      <value value="495"/>
      <value value="990"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="parameters_ThreeBins2" repetitions="100" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="0"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="parameters_ThreeBins_LINEAR" repetitions="100" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="0"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="parameters_ThreeBins_RANDOM" repetitions="100" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="66"/>
      <value value="495"/>
      <value value="990"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="numbers_fragmenting_LINEAR" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>total-deciding-to-fragment</metric>
    <metric>total-decided-to-fragment</metric>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="15"/>
      <value value="0"/>
      <value value="-13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="numbers_fragmenting_RANDOM" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>total-deciding-to-fragment</metric>
    <metric>total-decided-to-fragment</metric>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="66"/>
      <value value="495"/>
      <value value="990"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
      <value value="0.01"/>
      <value value="0.1"/>
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="small_random" repetitions="100" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="66"/>
      <value value="495"/>
      <value value="990"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="testing_experiment" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="pfragment">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="990"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-stripes">
      <value value="9"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="refined_parameter_sweep_LINEAR" repetitions="100" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-8"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="line2_variations" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-12"/>
      <value value="-10"/>
      <value value="-8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="refined_parameter_sweep_RANDOM" repetitions="100" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="66"/>
      <value value="231"/>
      <value value="1056"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="small_refined_parameter_sweep_LINEAR" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-8"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.001"/>
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="re_refined_parameter_space" repetitions="200" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-8"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="refined_parameter_sweep" repetitions="200" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-8"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="refined_parameter_sweep_2" repetitions="200" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-12"/>
      <value value="-11"/>
      <value value="-10"/>
      <value value="-8"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="refined_parameter_sweep_2_RANDOM" repetitions="100" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="50"/>
      <value value="100"/>
      <value value="250"/>
      <value value="500"/>
      <value value="750"/>
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="LINEAR" repetitions="100" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-12"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="RANDOM" repetitions="100" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="50"/>
      <value value="500"/>
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test_conquering_area_LINEAR_2" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-10"/>
      <value value="-5"/>
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test_conquering_area_RANDOM" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="50"/>
      <value value="250"/>
      <value value="500"/>
      <value value="750"/>
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test_conquering_area_LINEAR_4" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-10"/>
      <value value="-5"/>
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test_conquering_area_LINEAR_5" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-10"/>
      <value value="-5"/>
      <value value="0"/>
      <value value="5"/>
      <value value="10"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test_conquering_area_LINEAR_6" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="5"/>
      <value value="10"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="0"/>
      <value value="13"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test_conquering_area_RANDOM_2" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="5"/>
      <value value="10"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="50"/>
      <value value="500"/>
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="population-time" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>step-time</metric>
    <enumeratedValueSet variable="initial-villages">
      <value value="5"/>
      <value value="50"/>
      <value value="100"/>
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="links-time" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>step-time</metric>
    <enumeratedValueSet variable="initial-villages">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="RESULTS_1_LINEAR" repetitions="100" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="50"/>
      <value value="500"/>
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-12"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="RESULTS_1_RANDOM" repetitions="100" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="50"/>
      <value value="500"/>
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-12"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="2.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.001"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Model_1_LINEAR_1" repetitions="200" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>group-size</metric>
    <metric>total-polities</metric>
    <enumeratedValueSet variable="line1">
      <value value="-16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="5"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.01"/>
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Model_1_END_TEST_random" repetitions="100" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="2000"/>
    <metric>average-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>group-size</metric>
    <metric>total-polities</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="66"/>
      <value value="1023"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.01"/>
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Model_1_END_TEST_linear" repetitions="100" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="2000"/>
    <metric>average-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>group-size</metric>
    <metric>total-polities</metric>
    <enumeratedValueSet variable="line1">
      <value value="-16"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-14"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.01"/>
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Model_1_RANDOM_1" repetitions="200" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>group-size</metric>
    <metric>total-polities</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1023"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="4.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="5"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.01"/>
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
