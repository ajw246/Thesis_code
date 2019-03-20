
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Alice Williams, PhD Thesis code, 2019;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
             ;;;;; Model_3 ;;;;;
             ;;;;;;;;;;;;;;;;;;;




;;;;;;;;
;;; ABSTRACT ENVRIONMENTAL CIRCUMSCRIPTION MODEL - MODEL 3, version 4
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
  time-to-run
  population-growth-time
  update-arch-polities-time
  battle-polities-time
  fragment-time
  output-calculation-time
  social-circumscription
  environmental-circumscription
  number-founded
  proportion-founded
  number-fled
  proportion-fled
  patch-data
  etla-population
  etla-hierarchy
  tlac-population
  tlac-hierarchy
  ocot-population
  ocot-hierarchy
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
  attacking-tally ;to measure
  maximum-hierarchy ;to measure
  size-of-polity ;to measure
]

villages-own [
  polity
  hierarchy
  level-above
  level-below
  head-village
  resources
  population ;set to resources (not essential to running of model code)
  dominant-dying
  rebelling
  remaining-head
  potential-rebels
  rebelling-head
  defending ;to identify the main defending village and all of its subordinates
  benefit-move
  benefit-remain
  hatching-new-village
  fragmenting-tally ;to measure
  maximum-polity-hierarchy
  tag
  socially-circumscribed ;to measure
  environmentally-circumscribed ;to measure
  newly-founded ;to measure
  fled ;to measure
  ]

patches-own [
  land-resources
  splinter-location ;for a newly created village to move to
  village-claim
  potential-escape ;for a defeated village to attempt to move to
  territory
  ]






;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; TO SET UP THE WORLD ;;; (create the villages, place them in the world and give some of their attributes values)



;;;;;;;;;
;; MAP ;;

to setup-map-uniform

  clear-turtles
  clear-all-plots
  clear-globals
  clear-links
  clear-output

  reset-ticks


  ;to import the map
  import-pcolors filename



  ;to clean up the imported image

  ask patches with [pcolor < 5] [set pcolor black] ;MOUNTAIN

  ask patches with [pcolor != black] [set pcolor 9] ;not mountain


  ;to set resources of land types

  ask patches with [pcolor = black] [set land-resources mountain] ;MOUNTAIN

  ask patches with [pcolor = 9] [set land-resources classI]  ;not mountain



  ask patches [set splinter-location false]


  ; populate the area

  create-all-turtles

end



to setup-map-landtypes

; villages to go in their archaeological locations

  clear-turtles
  clear-all-plots
  clear-globals
  clear-links
  clear-output

  reset-ticks

  ;to import the map
  import-pcolors filename

  ;to clean up the imported image

  ask patches with [pcolor < 5] [set pcolor black] ;MOUNTAIN

  ask patches with [pcolor > 5 and pcolor < 7] [set pcolor 5]  ;CLASS IIIb

  ask patches with [pcolor > 7 and pcolor < 8] [set pcolor 7]  ;CLASS IIIa

  ask patches with [pcolor > 8 and pcolor < 9] [set pcolor 8]  ;CLASS II

  ask patches with [pcolor > 9 and pcolor < 10] [set pcolor 9]  ;CLASS I



  ;to set resources of different land types

  ask patches with [pcolor = black] [set land-resources mountain] ;MOUNTAIN

  ask patches with [pcolor = 5] [set land-resources classIIIb]  ;CLASS IIIb

  ask patches with [pcolor = 7] [set land-resources classIIIa]  ;CLASS IIIa

  ask patches with [pcolor = 8] [set land-resources classII]  ;CLASS II

  ask patches with [pcolor = 9] [set land-resources classI]  ;CLASS I



  ; to label the different valleys

  ask patches with [pxcor < 3 and pycor <= 1 and pcolor != black] [set plabel "O"]
  ask patches with [pxcor >= -4 and pycor > -13 and pcolor != black] [set plabel "T"]
  ask patches with [pxcor < -2 and pycor > 1 and pcolor != black] [set plabel "E"]

  ask patches [set plabel-color [pcolor] of self ]



  ask patches [set splinter-location false]


  ; populate the area

  create-all-turtles


end



;;;;;;;;;;;;;;;;;;;;;;;
;; RANDOM within map ;;

to setup-map-random

;villages go on any Class I or Class II land types

  clear-turtles
  clear-all-plots
  clear-globals
  clear-links
  clear-output

  reset-ticks

  ;to import the map
  import-pcolors filename

  ;to clean up the imported image

  ask patches with [pcolor < 5] [set pcolor black] ;MOUNTAIN

  ask patches with [pcolor > 5 and pcolor < 7] [set pcolor 5]  ;CLASS IIIb

  ask patches with [pcolor > 7 and pcolor < 8] [set pcolor 7]  ;CLASS IIIa

  ask patches with [pcolor > 8 and pcolor < 9] [set pcolor 8]  ;CLASS II

  ask patches with [pcolor > 9 and pcolor < 10] [set pcolor 9]  ;CLASS I



  ;to set resources of different land types

  ask patches with [pcolor = black] [set land-resources mountain] ;MOUNTAIN

  ask patches with [pcolor = 5] [set land-resources classIIIb]  ;CLASS IIIb

  ask patches with [pcolor = 7] [set land-resources classIIIa]  ;CLASS IIIa

  ask patches with [pcolor = 8] [set land-resources classII]  ;CLASS II

  ask patches with [pcolor = 9] [set land-resources classI]  ;CLASS I


    ; to label the different valleys

  ask patches with [pxcor < 3 and pycor <= 1 and pcolor != black] [set plabel "O"]  ;Ocotlan valley
  ask patches with [pxcor >= -4 and pycor > -13 and pcolor != black] [set plabel "T"] ; Tlacolula valley
  ask patches with [pxcor < -2 and pycor > 1 and pcolor != black] [set plabel "E"] ; Etla valley

  ask patches [set plabel-color [pcolor] of self ]


  ask patches [set splinter-location false]


  ; populate the area

  create-all-turtles-random-location



end


to setup-map-Rrandom

;villages go on any Class I, Class II, or Class IIIa land types

  clear-turtles
  clear-all-plots
  clear-globals
  clear-links
  clear-output

  reset-ticks

  ;to import the map
  import-pcolors filename

  ;to clean up the imported image

  ask patches with [pcolor < 5] [set pcolor black] ;MOUNTAIN

  ask patches with [pcolor > 5 and pcolor < 7] [set pcolor 5]  ;CLASS IIIb

  ask patches with [pcolor > 7 and pcolor < 8] [set pcolor 7]  ;CLASS IIIa

  ask patches with [pcolor > 8 and pcolor < 9] [set pcolor 8]  ;CLASS II

  ask patches with [pcolor > 9 and pcolor < 10] [set pcolor 9]  ;CLASS I



  ;to set resources of different land types

  ask patches with [pcolor = black] [set land-resources mountain] ;MOUNTAIN

  ask patches with [pcolor = 5] [set land-resources classIIIb]  ;CLASS IIIb

  ask patches with [pcolor = 7] [set land-resources classIIIa]  ;CLASS IIIa

  ask patches with [pcolor = 8] [set land-resources classII]  ;CLASS II

  ask patches with [pcolor = 9] [set land-resources classI]  ;CLASS I


    ; to label the different valleys

  ask patches with [pxcor < 3 and pycor <= 1 and pcolor != black] [set plabel "O"]  ;Ocotlan valley
  ask patches with [pxcor >= -4 and pycor > -13 and pcolor != black] [set plabel "T"] ; Tlacolula valley
  ask patches with [pxcor < -2 and pycor > 1 and pcolor != black] [set plabel "E"] ; Etla valley

  ask patches [set plabel-color [pcolor] of self ]


  ask patches [set splinter-location false]


  ; populate the area

  create-all-turtles-Rrandom-location



end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CREATE VILLAGES AND ARCH-POLITIES ;;



to create-all-turtles



  ;to create the active village turtles

  create-villages 22  [

    ask villages with [who = 0] [die]

       set polity [who] of self   ;villages need a polity name, and easiest to assign each one their own individual number at the start


       set hierarchy 1


       set level-above 0

       set level-below 0


       set defending false

       set remaining-head false


       set resources [land-resources] of patch-here

       set population resources

    set maximum-polity-hierarchy 1


       ifelse polity < 14
         [set color polity * 10 + 5]
         [set color ((polity - 10 ) * 10 + 5)]


     ]

  ask villages with [who = 1] [setxy -21 22]
  ask villages with [who = 2] [setxy -20 21]
  ask villages with [who = 3] [setxy -22 20]
  ask villages with [who = 4] [setxy -21 19]
  ask villages with [who = 5] [setxy -18 17]
  ask villages with [who = 6] [setxy -15 19]
  ask villages with [who = 7] [setxy -20 14]
  ask villages with [who = 8] [setxy -18 14]
  ask villages with [who = 9] [setxy -16 14]
  ask villages with [who = 10] [setxy -14 11]
  ask villages with [who = 11] [setxy -10 -3]
  ask villages with [who = 12] [setxy -13 -2]
  ask villages with [who = 13] [setxy -11 -4]
  ask villages with [who = 14] [setxy -12 -6]
  ask villages with [who = 15] [setxy -8 -8]
  ask villages with [who = 16] [setxy -15 -17]
  ask villages with [who = 17] [setxy -21 -22]
  ask villages with [who = 18] [setxy -2 9]
  ask villages with [who = 19] [setxy 18 -3]
  ask villages with [who = 20] [setxy 21 -6]
  ask villages with [who = 21] [setxy -9 4]








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






to create-all-turtles-random-location



  ;to create the active village turtles

  create-villages 22  [

    ask villages with [who = 0] [die]

       let new-empty-patch one-of patches with [count turtles-here < 1 and land-resources >= classII]  ;change the land-resources amount to change the patches that villages can occupy

       setxy [pxcor] of new-empty-patch [pycor] of new-empty-patch

       set polity [who] of self   ;villages need a polity name, and easiest to assign each one their own individual number at the start


       set hierarchy 1


       set level-above 0

       set level-below 0


       set defending false

       set remaining-head false


       set resources [land-resources] of patch-here

       set population resources

    set maximum-polity-hierarchy 1


       ifelse polity < 14
         [set color polity * 10 + 5]
         [set color ((polity - 10 ) * 10 + 5)]


     ]


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



to create-all-turtles-Rrandom-location



  ;to create the active village turtles

  create-villages 22  [

    ask villages with [who = 0] [die]

       let new-empty-patch one-of patches with [count turtles-here < 1 and land-resources >= classIIIa]  ;patches cannot be occupied by more than one village

       setxy [pxcor] of new-empty-patch [pycor] of new-empty-patch

       set polity [who] of self   ;villages need a polity name, and easiest to assign each one their own individual number at the start


       set hierarchy 1


       set level-above 0

       set level-below 0


       set defending false

       set remaining-head false


       set resources [land-resources] of patch-here

       set population resources

    set maximum-polity-hierarchy 1


       ifelse polity < 14
         [set color polity * 10 + 5]
         [set color ((polity - 10 ) * 10 + 5)]


     ]




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


ask villages with [size != 1] [set size 1]
  ask villages with [shape = "circle"] [set shape "default"]


  ;conditions to stop the model:

;; COMMENTED OUT so the model will run until the end of the time steps specified ;;
  ; if total-polities = 1 [stop] ;stop if all villages are part of the same polity  ;commented out so that the model continues recording till end of specified time steps
  ; if count patches with [count villages-here = 0] = 0 [stop] ;stop if there is no free land left



  ;submodels:

  population-growth

  if links? [update-links]

  update-arch-polities

  battle-polities

    ;to record data:
    set total-polities-attacking count arch-polities with [attacking-tally = true] ;to record the number of polities attacking in the time step
    ask arch-polities with [attacking-tally = true] [set attacking-tally false] ;to reset the count of attacking polities for the next time step

  if links? [update-links]

    fragment

  if links? [update-links]

    ;to record data:
    set total-villages-fragmenting count villages with [fragmenting-tally = true] ;to record the number of villages fragmenting from their polity in the time step
    ask villages with [fragmenting-tally = true] [set fragmenting-tally false]  ;to reset the count of fragmenting villages for the next time step

  update-arch-polities

  if links? [update-links]

  death-by-dearth



  ;to record data:

  set average-hierarchy mean [hierarchy] of villages  ;to record the overall level of hierarchy among all polities

  ask arch-polities with [polity-villages = true] [set maximum-hierarchy max [hierarchy] of villages with [polity = [whole-polity] of myself] ]
  set average-polity-hierarchy mean [maximum-hierarchy] of arch-polities with [polity-villages = true]

  ask arch-polities with [polity-villages = true] [set size-of-polity count villages with [polity = [whole-polity] of myself] ]
  set group-size max [size-of-polity] of arch-polities with [polity-villages = true]

  let lowest-rank max-one-of villages [hierarchy]  ;to record the maxium level of hierarchy present at each time step

  set max-hierarchy [hierarchy] of lowest-rank


  set total-polities count arch-polities with [polity-villages = true]   ;to record the total number of polities

  set number-founded count villages with [newly-founded = TRUE]
  set proportion-founded number-founded / count villages

  ask villages with [newly-founded = TRUE] [set newly-founded FALSE]


  set number-fled count villages with [fled = TRUE]
  set proportion-fled number-fled / count villages

  ask villages with [fled = TRUE] [set fled FALSE]



  ;; to record the different valleys


  set etla-population count villages-on patches with [plabel = "E"]
  set etla-hierarchy mean [hierarchy] of villages-on patches with [plabel = "E"]

  set tlac-population count villages-on patches with [plabel = "T"]
  set tlac-hierarchy mean [hierarchy] of villages-on patches with [plabel = "T"]

  set ocot-population count villages-on patches with [plabel = "O"]
  set ocot-hierarchy mean [hierarchy] of villages-on patches with [plabel = "O"]


  ;record experienced circumscription
  ; SOCIAL CIRCUMSCRIPTION

  ask villages [
    ifelse (count villages-on patches in-radius moving-distance - 1) = 0

    [;if there are no surrounding villages
      set socially-circumscribed 0

    ]

    [;if there are surrounding villages...

      ifelse (count villages-on patches in-radius moving-distance - 1) <= (((count patches in-radius moving-distance - 1) / 4) * 1)

      [
        ;if only a quarter of the surrounding area is occupied by villages
        set socially-circumscribed 1

      ]

      [;if there more surrounding villages than one quarter of the surrounding area...

       ifelse (count villages-on patches in-radius moving-distance - 1) <= (((count patches in-radius moving-distance - 1) / 2))

        [
          ;if up to a half of the surrounding area is occupied
          set socially-circumscribed 2

        ]

        [;if more than half the surrounding area is occupied...

          ifelse (count villages-on patches in-radius moving-distance - 1) <= (((count patches in-radius moving-distance - 1) / 4) * 3)

          [
           ;if up to three quarters of the surrounding land is occupied
            set socially-circumscribed 3

          ]

          [
           ;total villages in surrounding patches is over three quarters full
            set socially-circumscribed 4

          ]

        ]
      ]
    ]
  ] ;end of asking villaegs to check their surroundings


  ;to get a number of how e
  let circumscribed-patches
    (count villages with [socially-circumscribed = 1]) +
    (count villages with [socially-circumscribed = 2] * 2) +
    (count villages with [socially-circumscribed = 3] * 3) +
    (count villages with [socially-circumscribed = 4] * 4)

; if moving-distance = 1 [

  let total-neighbouring-patches count villages * 4

  set social-circumscription circumscribed-patches / total-neighbouring-patches


  ; ENVIRONMENTAL CIRCUMSCRIPTION


  ask villages [
    ifelse (sum [land-resources] of patches in-radius moving-distance - 1) = 0

    [;if there are no surrounding patches of more resources
      set environmentally-circumscribed 4

    ]

    [;if there some surrounding patches with more resources...

      ifelse (sum [land-resources] of patches in-radius moving-distance) <= ((( classI * count patches in-radius moving-distance ) / 4) * 1 )

      [
        ;if only up to a quarter of the surrounding area consists of more fertile patches
        set environmentally-circumscribed 3

      ]

      [;if there are more fertile patches...

        ifelse (sum [land-resources] of patches in-radius moving-distance) <= (((classI * count patches in-radius moving-distance) / 2))

        [
          ;if up to a half of the surrounding area consists of more fertile patches
          set environmentally-circumscribed 2

        ]

        [;if there are even more fertile patches about...

          ifelse (sum [land-resources] of patches in-radius moving-distance) <= (((classI * count patches in-radius moving-distance - 1) / 4) * 3)

          [
           ;if up to three quarters of the surrounding patches are more fertile
            set environmentally-circumscribed 1

          ]

          [
           ;total villages in surrounding patches is over three quarters full of more fertile patches
            set environmentally-circumscribed 0

          ]

        ]
      ]
    ]
  ] ;end of asking villaegs to check their surroundings


  ;to make experienced environmental circumscription a proportion:
  let sum-village-environmental-circumscription sum [environmentally-circumscribed] of villages

  let highest-possible-circumscription 4 * count villages

  set environmental-circumscription (sum-village-environmental-circumscription / highest-possible-circumscription)

end





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; POPULATION GROWTH AND TRIBUTE TRANSFER ;;;;;;

to population-growth

  ;; PROBABILITY OF RUNNING THE POPULATION GROWTH CODE

  if random-float 1 < probability-grow [


  ;;;;; decide whether to found a new village or not ;;;;;;

  ask villages [

    ;determine the population size based on residual resources

    set population resources

    if labels? [set label hierarchy]



    ;;;; To DIE or not to die ;;;;


    ifelse random-float 1 < probability-death

    [
      ; The village DIES
              ; and all of its subordinates become autonomous

        set dominant-dying true


         ;identify any subordinates of the dying village:
         ; NEW LOOP ;


                let subordinates villages with [level-above = [who] of myself]

                if any? subordinates [

                  ask subordinates
                  [
                  set tag true
                  ]

              while [count villages with [tag = true] > 0] [

                ask villages with [tag = true]
                 [
                   set dominant-dying true

                      if level-below != 0 [
                      ask villages with [level-above = [who] of myself]
                        [set tag true]
                    ]
                    set tag false

                 ] ;end of asking current batch of subordinate villages

                ] ;end of while loop


                ] ;end of code for if there are any subordinates




        ;to make the subordinates autonomous

        ask villages with [dominant-dying = true] [

           set level-above 0

           set level-below 0

           set polity who

           set hierarchy 1

           set dominant-dying false


          ;to update the arch-polities with all the new polities

           ask arch-polities with [whole-polity = [polity] of myself] [set polity-villages true]

        ]


        ;the village with no population then dies

        ask arch-polities with [whole-polity = [polity] of myself] [

            set polity-villages false

            ;die

          ]

        die

    ] ;end of village death code


    [
       ; the village LIVES
       ; so needs to decide whether to create a new village or not

       ; First, identify if there are any free neighbouring patches, and which of those has the most resources

      set hatching-new-village true

      ask patches in-radius placement-distance [set splinter-location true]


      ;to eliminate occupied patches as potential locations for newly created villages

      ask villages-on patches with [splinter-location = true] [

        ask patch-here [set splinter-location false]

        ]


      ;can only create a new village if there is somewhere for it to go

      ifelse count patches with [splinter-location = true] = 0

      [
        ;there are no potential locations for a newly created village
        ;therefore do nothing (no new village can be created)

        set hatching-new-village false

      ]


      [
        ;there is at least one unoccupied neighbouring patch for a newly created village
        ;so need to choose the best of the potential splinter-locations (prefer more resources over fewer)

        ifelse [land-resources] of one-of patches with [splinter-location = true] > 0  ;don't create a new village if the only option is mountains with no resources

        [
          ;if there is at some more fertile patches:

          let surrounding-environ sum [land-resources] of patches with [splinter-location = true]

          let green-total sum [land-resources] of patches with [splinter-location = true and land-resources > 0]


          ;probability of choosing a non mountainous patch:

          ifelse random-float surrounding-environ <= green-total

          [

            ;choose one of the non mountainous patches for the new village

            ask one-of patches with [splinter-location = true and land-resources > 0] [

              ask other patches with [splinter-location = true] [set splinter-location false]
              ]


          ]


          [


            ;choose one of the black patches for the new village

            ask one-of patches with [splinter-location = true and land-resources = 0] [

              ask other patches with [splinter-location = true] [set splinter-location false]
              ]


          ]


        ]


        [

          ;all neighbouring unoccupied patches are black

            ;choose one of the patches for the new village

            ask one-of patches with [splinter-location = true] [

              ask other patches with [splinter-location = true] [set splinter-location false]
              ]

        ]

      ]


  if count patches with [splinter-location = true] = 1 [

       ; Then, need to create a new village there with a likelihood dependent on the resources that the new patch has to offer (more resources = more likley to create a new village)

      let optimum-patch classI
      let new-patch [land-resources] of one-of patches with [splinter-location = true]

      ifelse random-float optimum-patch <= new-patch

      [
       ; DO create a new village

              ;;; create a new village (hatching code) ;;;


       hatch-villages 1 [

        set shape "star" ;for counting number of new villages to create corresponding number of arch-polities
        set newly-founded TRUE

        ;the attributes of the newly created village:

        move-to one-of patches with [splinter-location = true]

        set resources [land-resources] of patch-here

        set hierarchy 1

        set polity [who] of self

        set population resources

        set level-above 0

        set level-below 0

           ifelse polity < 14
             [set color polity * 10 + 5]
             [set color ((polity - 10 ) * 10 + 5)]

        if labels? [set label hierarchy]

        ask patches with [splinter-location = true ] [set splinter-location false]

         ]

            ask villages with [shape = "star"] [set polity [who] of self]


        ]  ;end of ifelse DO create a new village




      [
       ; DON'T create a new village
        ; (nothing happens)

      ]

      ] ;end of if there are any potential-patches

    ] ;end of if the village LIVES









    ;determine the population size based on residual resources

    set population resources




   ;determine the population size based on residual resources

   ask villages [set population resources ]


 ;need to create the corresponding number of arch-polities

  ask villages with [shape = "star"] [

      hatch-arch-polities 1 [

               set whole-polity [who] of myself ;

               set polity-resources sum [resources] of villages with [polity = [whole-polity] of myself]

               set attacking false

               set target-polity false

               hide-turtle

               ]

     set shape "default"

  ]

  ] ;end of asking villages to die or live or live and create a new village

  ] ;end of if probability-grow condition is met

end






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; UPDATE ARCH-POLITIES ;;;;;


to update-arch-polities

;to make sure that only the polities which still have villages and resource can run the battle code

  ask arch-polities [

    ifelse any? villages with [polity = [whole-polity] of myself]

    [
      set polity-villages true

      set polity-resources sum [resources] of villages with [polity = [whole-polity] of myself]

      set maximum-hierarchy max [hierarchy] of villages with [polity = [whole-polity] of myself]

      ask villages with [polity = [whole-polity] of myself ] [set maximum-polity-hierarchy [maximum-hierarchy] of myself]

    ]


    [
      set polity-villages false

      set polity-resources 0

      set maximum-hierarchy 0

    ]

  ]


end







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; FRAGMENT POLITIES ;;;;;;



to fragment

  ask arch-polities [

    if count villages with [polity = [whole-polity] of myself] >= 2 [


      ifelse random-float 1 < probability-fragment
      [
        ; DO fragment

        ;but need different types of fragmentation depending on the existing structure of the polity



        ;if the polity is hierarchical with one head-village (should be the case whatever, without the sister village code...)
        if count villages with [polity = [whole-polity] of myself and hierarchy = 1] = 1
          [


            ;to reset the links between villages of the same polity later
            if links? [ask links [die]]

            ;to identify all the villages in the same polity (with less code later)
            let fragmenting-villages villages with [polity = [whole-polity] of myself]

            ;to single out the head village who will not be rebelling
            ask one-of fragmenting-villages with [hierarchy = 1]
              [set remaining-head true]


            ;to identify all the other villages in the polity which could rebel
            ask fragmenting-villages with [remaining-head = false]
              [set potential-rebels true]



            ;to ask a village at the next level down to rebel (not just any subordinate village, that's too complicated)
            ask one-of fragmenting-villages with [potential-rebels = true and hierarchy = 2]
               [set rebelling-head true]


            ;to begin the rebelling process:
            ask one-of villages with [rebelling-head = true]
             [
              ;to reset the head rebelling village
              set rebelling true
              set level-above 0
                set polity [who] of self

              ifelse polity < 14
                 [set color polity * 10 + 5]
                 [set color ((polity - 10 ) * 10 + 5)]

              set hierarchy 1
              set head-village true




              ;identify all the subordinates of the defending village, if there are any
              ;  NEW LOOP  ;

                let subordinates villages with [level-above = [who] of myself]

                if any? subordinates [

                  ask subordinates
                  [
                  set tag true
                  ]

              while [count villages with [tag = true] > 0] [

                ask villages with [tag = true]
                 [
                   set rebelling true

                      if level-below != 0 [
                      ask villages with [level-above = [who] of myself]
                        [set tag true]
                    ]
                    set tag false

                 ] ;end of asking current batch of subordinate villages

                ] ;end of while loop


                ] ;end of code for if there are any subordinates




                ;all the villages which are leaving the old polity should now be labelled as 'rebelling'

                ;head-rebelling village to reset all new subordinate villages
                set rebelling false

                ask villages with [rebelling = true]
                [
                  set polity [polity] of one-of villages with [rebelling-head = true]
                  set color [color] of one-of villages with [rebelling-head = true]
                  if hierarchy > 1 [set hierarchy hierarchy - 1] ;to maintain the same hierarchical structure


                  set rebelling false

                ]
                ;to reset the old polity
                ask one-of villages with [remaining-head = true]
                [
                  ifelse any? villages with [level-above = [who] of myself]
                  [set level-below [who] of one-of villages with [level-above = [who] of myself]]
                  [set level-below 0]
                ]

                ;to reset rebelling head
                set rebelling-head false

                ;to reset the rest
                ask villages with [potential-rebels = true] [set potential-rebels false]
                ask villages with [remaining-head = true] [set remaining-head false]


              ] ;end of rebelling process

            update-arch-polities


        ]





        ;if the polity is egalitarian with sister villages all ranked at hierarchy 1
        if count villages with [polity = [whole-polity] of myself and hierarchy = 1] > 1
          [
            ;nothing should happen (but retaining space in case egalitarian polities are needed again - see Model_2.9.5 for commented out code to insert here
          ]



        ;if neither, then there is a problem
        if count villages with [polity = [whole-polity] of myself and hierarchy = 1] = 0
          [
            ;nothing should happen because this shouldn't happen
          ]


      ] ;end of DO fragment code

      [
        ; DON'T fragment
      ]

    ] ;end of if there are more than one village in the polity
  ] ;end of asking all arch-polities to see how many villages are in their polity



end



;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; UPDATE LINKS ;;;;;;



to update-links


  ;to build links up again

    ask villages [

      let sister-villages villages with [hierarchy = 1 and polity = [polity] of myself]

      let subordinates villages with [who = [level-above] of myself]


        ifelse count sister-villages > 2

           [
            ;nothing should happen (but retaining space in case egalitarian polities are needed again - see Model_2.9.5 for commented out code to insert here
           ]


          [

           if count subordinates != 0 [

            create-link-with one-of villages with [who = [level-above] of myself]

               ask my-links [
                  set thickness 0.3
                  set color [color] of myself]
             ]

          ]

    ]

end








;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; BATTLE ;;;;;;;;;;;;


to battle-polities


ask arch-polities [


  ifelse random-float 1 > probability-attack


  [

    ;do nothing because no attack happens

  ]


  [
    ;ATTACK because probability attack condition has been met!

  ;to identify one polity at a time

    ;to make sure that the polity does in fact have villages

    ifelse polity-villages = false or polity-resources = 0 ;so that only polities with living villages and enough resources (that the villages won't die afterwards) can enter into battle

    [

     ;do nothing because the polity has no villages or resources

      ]


    [
     ;polity has villages, so can attack a neighbouring polity

      ;to make sure that there is another polity which can be attacked (if not, do nothing)

      ifelse not any? villages with [polity = [whole-polity] of myself]

       [

        ;do nothing because the polity doesn't actually have any villages

         ]


       [

        ;if there is another polity to attack:

         set attacking true

         set attacking-tally true

         let my-village one-of villages with [polity = [whole-polity] of myself] ;"my-village" is one village in the attacking polity, chosen at random, to attack another polity

         let attacking-villages villages with [polity = [polity] of my-village]


         ;to identify any villages of a different polity within a certain area of the attacking village
          ask my-village [

            ask patches in-radius conquering-area [set territory true]

            ask patch-here [set territory false]

            ask patches with [count villages-here < 1] [set territory false]

            ask patches with [territory = true] [

              if any? villages-here with [polity = [polity] of my-village]

               [set territory false]

            ]

          ]


         let rival-villages villages-on patches with [territory = true] ;"rival-villages" are villages which belong to a different polity to the attacking polity

         ifelse count rival-villages < 1

          [

           ;there are no nearby rival villages to attack, so do nothing

          ]


          [
         ;there is a rival village to attack, so run attack code:

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

             ask patches in-radius moving-distance [set potential-escape true]

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

               ifelse [land-resources] of one-of patches with [potential-escape = true] > 0


               [
                 ;if the neighbouring patches are not mountains

                 let surrounding-environ sum [land-resources] of patches with [potential-escape = true]

                 let green-total sum [land-resources] of patches with [potential-escape = true and land-resources > 0]

                 ifelse random-float surrounding-environ <= green-total


                 [
                   ;choose one of the green patches to move to

                   ask patches with [potential-escape = true and land-resources > 0] [ ;to narrow down to all patches with some resources

                        ask other patches [set potential-escape false]


                        ;code adapted from NetLogo Lottery example, to make selection of patches with more [land-resources] more likely:
                        let pick random-float sum [land-resources] of patches with [potential-escape = true]

                        let winner nobody
                        ask patches with [potential-escape = true]
                         [ if winner = nobody
                            [ifelse land-resources > pick
                              [ask other patches with [potential-escape = true] [set potential-escape false]]
                              [set pick pick - land-resources ]
                            ]
                        ]



                      set village-claim [who] of myself

                    ]

                  ]


                 [
                   ;choose one of the mountain patches to move to

                   ask one-of patches with [potential-escape = true and land-resources = 0] [

                      set village-claim [who] of myself

                    ]

                  ]


                ] ;end of code if there are any dark green potential escape patches



                [
                 ;choose any of the neighbouring black patches to move to

                 ask one-of patches with [potential-escape = true] [set village-claim [who] of myself]

                ] ;end of code if all potential escape patches are black


              ];end of code for choosing best of potential escape patches, if there are any escape patches to choose from



             ;;;to reset the patches for the next turn (potential escape patch has now been labelled by village-claim number)

              ask patches with [potential-escape = true] [

                set potential-escape false

              ]


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



             ] ;end of target villages to run code (#2) to work out whether they want to vote to leave or stay based on the land type of their escape patch







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


                  ;reset escape patches

                   ask patches with [village-claim = [who] of myself] [

                      set village-claim 0

                    ] ;end of code to reset the escape patches (no village claim)


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

                   set fled TRUE

                   ;to reset the escape patches

                   ask patches with [village-claim = [who] of myself] [

                      set village-claim 0

                    ] ;end of code to reset the escape patches (no village claim)


                   ;to reset the target arch-polity

                   ask arch-polities with [target-polity = true] [set target-polity false]


                  ] ;end of code for polity to move and remain autonomous if there are any escape patches

                ] ;end of code to ask defending villages to leave

              ] ;end of code to LEAVE





              ;;; TO REMAIN ;;;


              [
               ;DECIDED TO REMAIN

              if links? [

                  ask links [die]

                ];to reset all the links



              ifelse count attacking-villages with [hierarchy = 1] > 1


              [
              ;if there are sister villages in the attacking polity, make one the head village and the others subordinate to it
              ;nothing should happen (but retaining space in case egalitarian polities are needed again - see Model_2.9.5 for commented out code to insert here

              ] ;half end of ifelse there are sister villages in attacking polity



              [
                 ;if there are no sister villages in the attacking polity, do basically the same commands but without altering the structure of the attacking polity

                ask one-of attacking-villages with [hierarchy = 1] [set head-village true]

              ;then attach the defeated polity below the head village

                ;check whether the target polity consists of sister villages or not

                ifelse count target-villages with [hierarchy = 1] > 1

                [
                ;if the target polity consists of sister villages, make them all subordinate to the head village of the attacking polity
                ;nothing should happen (but retaining space in case egalitarian polities are needed again - see Model_2.9.5 for commented out code to insert here

                ]


                [

                ;if the target polity consists of a hierarchical structure
                ;attach the subordinates to the attacking head village
                   ;attach the target beneath the attacking head

                  ask target-villages with [hierarchy = 1] [

                     set level-above [who] of one-of attacking-villages with [head-village = true]

                     if head-village = true [set head-village false]

                    set polity [polity] of one-of attacking-villages




                        if any? target-villages with [hierarchy != 1] [

                          ask target-villages with [hierarchy != 1] [

                      set hierarchy hierarchy + 1

                      set polity [polity] of one-of attacking-villages

                        ]

                    ]
                        set hierarchy 2

                  ]


                ] ;end of ifelse there are sister villages in the target polity

              ] ;end of ifelse there are no sister villages in the attacking polity





                 ;to reset level-below of villages

                ask villages [set level-below 0]


                ask villages  [

                  ask villages with [who = [level-above] of myself] [

                    set level-below [who] of myself

                  ]

                ]



               ;to reset the target polity to take loss of villages into account

               ask arch-polities with [target-polity = true] [

                set polity-villages false

                ] ;should not be any target villages left



               ;to reset the rest of the defending village attributes

               ask villages with [defending = true] [

                 set defending false

                 set benefit-move 0

                 set benefit-remain 0

                ]



               ask villages [

                 ifelse polity < 14
                    [set color polity * 10 + 5 ]
                    [set color ((polity - 10) * 10 + 5)]

                    ]



              if labels? [ask villages [set label hierarchy]]


            ] ;end of code to REMAIN




         ] ;end of asking target villages (#3) to either stay or move based on the number of votes in the polity

               ;to reset any potential escape patches

               ask patches with [village-claim != 0] [

                  set village-claim 0

                ]



        ] ;end of code if win the attack


        ;;;; to reset the arch-polities at the end of the attacking turn

         set attacking false

         ask arch-polities with [target-polity = true] [set target-polity false]

        ] ;end of ifelse there is a rival village in the conquering area

        set attacking false

        ask arch-polities with [target-polity = true] [set target-polity false]

        ask patches with [territory = true] [set territory false]

        ask villages with [defending = true] [set defending false]

        ask patches with [potential-escape = true] [set potential-escape false]


      ] ;end of code for if there are any villages with recognise that they are part of the polity

    ] ;end of code for if the attacking arch-polity has any villages and resources in the polity

  ] ;end of ifelse attack condition is met

] ;end of asking each polity to work out probability attack



end



to death-by-dearth

  ask villages [set resources [land-resources] of patch-here ]

  ask villages [ if resources  = 0
     [
      ; The village DIES
              ; and all of its subordinates become autonomous

        set dominant-dying true


         ;identify any subordinates of the dying village:
         ; NEW LOOP ;


                let subordinates villages with [level-above = [who] of myself]

                if any? subordinates [

                  ask subordinates
                  [
                  set tag true
                  ]

              while [count villages with [tag = true] > 0] [

                ask villages with [tag = true]
                 [
                   set dominant-dying true

                      if level-below != 0 [
                      ask villages with [level-above = [who] of myself]
                        [set tag true]
                    ]
                    set tag false

                 ] ;end of asking current batch of subordinate villages

                ] ;end of while loop


                ] ;end of code for if there are any subordinates




        ;to make the subordinates autonomous

        ask villages with [dominant-dying = true] [

           set level-above 0

           set level-below 0

           set polity who

           set hierarchy 1

           set dominant-dying false


          ;to update the arch-polities with all the new polities

           ask arch-polities with [whole-polity = [polity] of myself] [set polity-villages true]

        ]


        ;the village with no population then dies

        ask arch-polities with [whole-polity = [polity] of myself] [

            set polity-villages false

          ]

        die

    ] ;end of village death code

  ]

end
@#$#@#$#@
GRAPHICS-WINDOW
246
10
1030
795
-1
-1
12.7213115
1
10
1
1
1
0
0
0
1
-30
30
-30
30
1
1
1
ticks
30.0

BUTTON
40
10
103
43
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
110
10
173
43
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

PLOT
1040
13
1578
180
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
21
271
193
304
classI
classI
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
21
306
193
339
classII
classII
0
100
60.0
1
1
NIL
HORIZONTAL

PLOT
1580
173
2107
293
population size (total villages in the whole world)
time
number of villages
1.0
20.0
0.0
10.0
true
false
"" ""
PENS
"villages" 1.0 0 -16777216 true "" "plot count villages"

SWITCH
16
764
119
797
links?
links?
1
1
-1000

SLIDER
21
543
193
576
probability-fragment
probability-fragment
0
1
0.01
0.001
1
NIL
HORIZONTAL

SLIDER
21
581
193
614
probability-attack
probability-attack
0
1
0.1
0.001
1
NIL
HORIZONTAL

SLIDER
20
617
192
650
tribute
tribute
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
20
654
192
687
moving-distance
moving-distance
0
100
1.0
1
1
NIL
HORIZONTAL

SLIDER
19
724
191
757
conquering-area
conquering-area
0
50
1.0
1
1
NIL
HORIZONTAL

PLOT
1584
12
1972
168
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

SLIDER
22
496
194
529
probability-death
probability-death
0
1
0.01
0.001
1
NIL
HORIZONTAL

SLIDER
19
689
192
722
placement-distance
placement-distance
0
10
1.0
1
1
NIL
HORIZONTAL

SLIDER
21
460
193
493
probability-grow
probability-grow
0
1
0.1
0.001
1
NIL
HORIZONTAL

PLOT
1036
534
1670
735
Experienced circumscription
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"social circumscription" 1.0 0 -955883 true "" "plot social-circumscription"
"environmental circumscription" 1.0 0 -10899396 true "" "plot environmental-circumscription"

BUTTON
41
60
177
93
NIL
setup-map-uniform
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
34
96
183
129
NIL
setup-map-landtypes
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
21
341
193
374
classIIIa
classIIIa
0
100
20.0
1
1
NIL
HORIZONTAL

SLIDER
21
376
193
409
classIIIb
classIIIb
0
100
10.0
1
1
NIL
HORIZONTAL

SLIDER
21
412
193
445
mountain
mountain
0
100
0.0
1
1
NIL
HORIZONTAL

CHOOSER
9
213
237
258
filename
filename
"LandTypesBlackWhite.jpg" "LandTypesBW2.jpg" "LandTypesBW3.jpg" "LandTypesPrimaryBlack.jpg" "LandType2.jpg"
2

SWITCH
123
764
226
797
labels?
labels?
1
1
-1000

BUTTON
32
133
190
166
NIL
setup-map-random
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1044
186
1576
355
population in valleys
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"etla" 1.0 0 -16777216 true "" "plot etla-population"
"tlac" 1.0 0 -7500403 true "" "plot tlac-population"
"ocot" 1.0 0 -2674135 true "" "plot ocot-population"

PLOT
1045
359
1576
535
hierarchy in valleys
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"etla" 1.0 0 -16777216 true "" "plot etla-hierarchy"
"tlac" 1.0 0 -7500403 true "" "plot tlac-hierarchy"
"ocot" 1.0 0 -2674135 true "" "plot ocot-hierarchy"

BUTTON
29
170
196
203
NIL
setup-map-Rrandom
NIL
1
T
OBSERVER
NIL
NIL
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
  <experiment name="intial_parameter_test_LINEAR" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="splinter-resources">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="growth-threshold">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="-8"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="10"/>
      <value value="50"/>
      <value value="90"/>
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
  <experiment name="fragment-time-test" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="20"/>
    <metric>time-to-run</metric>
    <enumeratedValueSet variable="growth-threshold">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fragment-yes?">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="growth-probability">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="splinter-resources">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="wide_parameter_space_distribution" repetitions="3" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>count villages with [hierarchy = 1]</metric>
    <metric>count villages with [hierarchy = 2]</metric>
    <metric>count villages with [hierarchy = 3]</metric>
    <metric>count villages with [hierarchy = 4]</metric>
    <metric>count villages with [hierarchy = 5]</metric>
    <metric>count villages with [hierarchy = 6]</metric>
    <metric>count villages with [hierarchy = 7]</metric>
    <metric>count villages with [hierarchy = 8]</metric>
    <metric>count villages with [hierarchy = 9]</metric>
    <metric>count villages with [hierarchy = 10]</metric>
    <metric>count villages with [hierarchy = 11]</metric>
    <metric>count villages with [hierarchy = 12]</metric>
    <metric>count villages with [hierarchy = 13]</metric>
    <metric>count villages with [hierarchy = 14]</metric>
    <metric>count villages with [hierarchy = 15]</metric>
    <metric>count villages with [hierarchy &gt; 15]</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-14"/>
      <value value="-11"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="10"/>
      <value value="50"/>
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="growth-threshold">
      <value value="100"/>
      <value value="200"/>
      <value value="300"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fragment-yes?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fragment-yes?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="links-time-test" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="20"/>
    <metric>time-to-run</metric>
    <enumeratedValueSet variable="links?">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fragment-yes?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="growth-probability">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="pfragment">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="wide_parameter_space_distribution_RANDOM" repetitions="3" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>count villages with [hierarchy = 1]</metric>
    <metric>count villages with [hierarchy = 2]</metric>
    <metric>count villages with [hierarchy = 3]</metric>
    <metric>count villages with [hierarchy = 4]</metric>
    <metric>count villages with [hierarchy = 5]</metric>
    <metric>count villages with [hierarchy = 6]</metric>
    <metric>count villages with [hierarchy = 7]</metric>
    <metric>count villages with [hierarchy = 8]</metric>
    <metric>count villages with [hierarchy = 9]</metric>
    <metric>count villages with [hierarchy = 10]</metric>
    <metric>count villages with [hierarchy = 11]</metric>
    <metric>count villages with [hierarchy = 12]</metric>
    <metric>count villages with [hierarchy = 13]</metric>
    <metric>count villages with [hierarchy = 14]</metric>
    <metric>count villages with [hierarchy = 15]</metric>
    <metric>count villages with [hierarchy &gt; 15]</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="41"/>
      <value value="164"/>
      <value value="1312"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="10"/>
      <value value="50"/>
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="growth-threshold">
      <value value="100"/>
      <value value="200"/>
      <value value="300"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fragment-yes?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fragment-yes?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="small_parameter_test" repetitions="3" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>count villages with [hierarchy = 1]</metric>
    <metric>count villages with [hierarchy = 2]</metric>
    <metric>count villages with [hierarchy = 3]</metric>
    <metric>count villages with [hierarchy = 4]</metric>
    <metric>count villages with [hierarchy = 5]</metric>
    <metric>count villages with [hierarchy = 6]</metric>
    <metric>count villages with [hierarchy = 7]</metric>
    <metric>count villages with [hierarchy = 8]</metric>
    <metric>count villages with [hierarchy = 9]</metric>
    <metric>count villages with [hierarchy = 10]</metric>
    <metric>count villages with [hierarchy = 11]</metric>
    <metric>count villages with [hierarchy = 12]</metric>
    <metric>count villages with [hierarchy = 13]</metric>
    <metric>count villages with [hierarchy = 14]</metric>
    <metric>count villages with [hierarchy = 15]</metric>
    <metric>count villages with [hierarchy &gt; 15]</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="41"/>
      <value value="164"/>
      <value value="1312"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-14"/>
      <value value="-11"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-split">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="0.9"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="large_parameter_test" repetitions="1" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>count villages with [hierarchy = 1]</metric>
    <metric>count villages with [hierarchy = 2]</metric>
    <metric>count villages with [hierarchy = 3]</metric>
    <metric>count villages with [hierarchy = 4]</metric>
    <metric>count villages with [hierarchy = 5]</metric>
    <metric>count villages with [hierarchy = 6]</metric>
    <metric>count villages with [hierarchy = 7]</metric>
    <metric>count villages with [hierarchy = 8]</metric>
    <metric>count villages with [hierarchy = 9]</metric>
    <metric>count villages with [hierarchy = 10]</metric>
    <metric>count villages with [hierarchy = 11]</metric>
    <metric>count villages with [hierarchy = 12]</metric>
    <metric>count villages with [hierarchy = 13]</metric>
    <metric>count villages with [hierarchy = 14]</metric>
    <metric>count villages with [hierarchy = 15]</metric>
    <metric>count villages with [hierarchy &gt; 15]</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="41"/>
      <value value="164"/>
      <value value="1312"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="6"/>
      <value value="11"/>
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-14"/>
      <value value="-11"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="10"/>
      <value value="50"/>
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-split">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="0.9"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="testing_probability_split" repetitions="1" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count villages</metric>
    <metric>count villages with [hatching-new-village = true]</metric>
    <metric>count villages * probability-split</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="6"/>
      <value value="11"/>
      <value value="41"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-14"/>
      <value value="-11"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fragment-yes?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-split">
      <value value="0"/>
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="0.9"/>
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="testing_parameters_1" repetitions="3" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>count villages with [hierarchy = 1]</metric>
    <metric>count villages with [hierarchy = 2]</metric>
    <metric>count villages with [hierarchy = 3]</metric>
    <metric>count villages with [hierarchy = 4]</metric>
    <metric>count villages with [hierarchy = 5]</metric>
    <metric>count villages with [hierarchy = 6]</metric>
    <metric>count villages with [hierarchy = 7]</metric>
    <metric>count villages with [hierarchy = 8]</metric>
    <metric>count villages with [hierarchy = 9]</metric>
    <metric>count villages with [hierarchy = 10]</metric>
    <metric>count villages with [hierarchy = 11]</metric>
    <metric>count villages with [hierarchy = 12]</metric>
    <metric>count villages with [hierarchy = 13]</metric>
    <metric>count villages with [hierarchy = 14]</metric>
    <metric>count villages with [hierarchy = 15]</metric>
    <metric>count villages with [hierarchy &gt; 15]</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-15"/>
      <value value="-11"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="10"/>
      <value value="50"/>
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fragment-yes?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-split">
      <value value="0"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="testing_parameters_2" repetitions="3" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>count villages with [hierarchy = 1]</metric>
    <metric>count villages with [hierarchy = 2]</metric>
    <metric>count villages with [hierarchy = 3]</metric>
    <metric>count villages with [hierarchy = 4]</metric>
    <metric>count villages with [hierarchy = 5]</metric>
    <metric>count villages with [hierarchy = 6]</metric>
    <metric>count villages with [hierarchy = 7]</metric>
    <metric>count villages with [hierarchy = 8]</metric>
    <metric>count villages with [hierarchy = 9]</metric>
    <metric>count villages with [hierarchy = 10]</metric>
    <metric>count villages with [hierarchy = 11]</metric>
    <metric>count villages with [hierarchy = 12]</metric>
    <metric>count villages with [hierarchy = 13]</metric>
    <metric>count villages with [hierarchy = 14]</metric>
    <metric>count villages with [hierarchy = 15]</metric>
    <metric>count villages with [hierarchy &gt; 15]</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-15"/>
      <value value="-11"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0"/>
      <value value="50"/>
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-split">
      <value value="0"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="testing_parameters_3" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="2500"/>
    <metric>average-hierarchy</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="26"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-15"/>
      <value value="-11"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0"/>
      <value value="50"/>
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.05"/>
      <value value="0.1"/>
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-split">
      <value value="0.001"/>
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.001"/>
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="small_test" repetitions="3" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="2500"/>
    <metric>average-hierarchy</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="1089"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="76"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-15"/>
      <value value="-11"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-split">
      <value value="0.001"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test_1" repetitions="3" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="initial-villages">
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-13"/>
      <value value="0"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-split">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="population_test_LINEAR" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>count villages</metric>
    <metric>total-polities</metric>
    <enumeratedValueSet variable="initial-villages">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-15"/>
      <value value="-8"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-split">
      <value value="0.1"/>
      <value value="0.2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="population_test_RANDOM" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>count villages</metric>
    <metric>total-polities</metric>
    <enumeratedValueSet variable="initial-villages">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="66"/>
      <value value="369"/>
      <value value="1394"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-split">
      <value value="0.1"/>
      <value value="0.2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="LINEAR_test" repetitions="1" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>count villages</metric>
    <metric>total-polities</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-15"/>
      <value value="-8"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="30"/>
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="RANDOM_test" repetitions="1" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>count villages</metric>
    <metric>total-polities</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="66"/>
      <value value="369"/>
      <value value="1394"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="0.5"/>
      <value value="30"/>
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="LINEAR_initial_time" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="25"/>
    <metric>average-hierarchy</metric>
    <metric>count villages</metric>
    <metric>total-polities</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="932"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-15"/>
      <value value="-8"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="placement-distance_TEST_LINEAR" repetitions="3" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count villages</metric>
    <metric>total-polities</metric>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <enumeratedValueSet variable="initial-villages">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-15"/>
      <value value="-8"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="placement-distance_TEST_RANDOM" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count villages</metric>
    <metric>total-polities</metric>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <enumeratedValueSet variable="initial-villages">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="66"/>
      <value value="369"/>
      <value value="1394"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="LINEAR_growthrate" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count villages</metric>
    <metric>total-polities</metric>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <enumeratedValueSet variable="initial-villages">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-15"/>
      <value value="-8"/>
      <value value="17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="RANDOM_growthrate" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count villages</metric>
    <metric>total-polities</metric>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <enumeratedValueSet variable="initial-villages">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="66"/>
      <value value="369"/>
      <value value="1394"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Question_1" repetitions="3" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>total-polities</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
      <value value="20"/>
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Population_size" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>environmental-circumscription</metric>
    <metric>social-circumscription</metric>
    <metric>total-polities</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="100"/>
      <value value="500"/>
      <value value="1500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Population_size_2" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>environmental-circumscription</metric>
    <metric>social-circumscription</metric>
    <metric>total-polities</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="10"/>
      <value value="100"/>
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Population_size_3" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>environmental-circumscription</metric>
    <metric>social-circumscription</metric>
    <metric>total-polities</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="10"/>
      <value value="100"/>
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Population_size_4" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>environmental-circumscription</metric>
    <metric>social-circumscription</metric>
    <metric>total-polities</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="10"/>
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-17"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Question_2_low_social" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>environmental-circumscription</metric>
    <metric>social-circumscription</metric>
    <metric>total-polities</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-17"/>
      <value value="-7"/>
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Question_2_medium_social" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>environmental-circumscription</metric>
    <metric>social-circumscription</metric>
    <metric>total-polities</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-17"/>
      <value value="-7"/>
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Question_2_high_social" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>environmental-circumscription</metric>
    <metric>social-circumscription</metric>
    <metric>total-polities</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-17"/>
      <value value="-7"/>
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Question_1_a" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>total-polities</metric>
    <metric>count villages</metric>
    <metric>number-founded</metric>
    <metric>number-fled</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
      <value value="20"/>
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
      <value value="0.5"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Question_1_b" repetitions="3" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>total-polities</metric>
    <metric>count villages</metric>
    <metric>number-founded</metric>
    <metric>number-fled</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="6"/>
      <value value="11"/>
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Question_1_c" repetitions="2" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>total-polities</metric>
    <metric>count villages</metric>
    <metric>number-founded</metric>
    <metric>number-fled</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="6"/>
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Question_1_d" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>total-polities</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Question_1_e" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>total-polities</metric>
    <metric>count villages</metric>
    <metric>number-founded</metric>
    <metric>number-fled</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
      <value value="10"/>
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
      <value value="10"/>
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Question_1_f" repetitions="17" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>total-polities</metric>
    <metric>count villages</metric>
    <metric>number-founded</metric>
    <metric>number-fled</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.15"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
      <value value="10"/>
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Question_1_g" repetitions="3" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="500"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>total-polities</metric>
    <metric>count villages</metric>
    <metric>number-founded</metric>
    <metric>number-fled</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.15"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Population_growth_test_1" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="15"/>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="27"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.25"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Population_growth_test_2" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="30"/>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="27"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.125"/>
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Population_growth_test_3" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="60"/>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="27"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.0625"/>
      <value value="0.125"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Population_growth_test_4" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="120"/>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="27"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.03125"/>
      <value value="0.0625"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Population_growth_test_5" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="600"/>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="27"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.00625"/>
      <value value="0.03125"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Population_growth_test_6" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="3000"/>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="1681"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="27"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.00125"/>
      <value value="0.00625"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="social_batch1_low_distance" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
      <value value="501"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="social_batch1_high_distance" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
      <value value="501"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="social_batch2_low_distance" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="social_batch2_high_distance" repetitions="10" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="social_batch_1_a" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="500"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="social_batch_1_b" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="501"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="social_batch_1_c" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="500"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="51"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="social_batch_1_d" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="501"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="social_batch_2_a" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="social_batch_2_b" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="social_batch_2_c" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="social_batch_2_d" repetitions="50" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="all_group_1_a" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-18"/>
      <value value="19"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="all_group_1_b" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-18"/>
      <value value="19"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="all_group_1_c" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-18"/>
      <value value="19"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="all_group_1_d" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-18"/>
      <value value="19"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="all_group_2_a" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-18"/>
      <value value="19"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="all_group_2_b" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-18"/>
      <value value="19"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="all_group_2_c" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-18"/>
      <value value="19"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="all_group_2_d" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-line</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="line1">
      <value value="-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="-18"/>
      <value value="19"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="all_group_3_a" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="82"/>
      <value value="1599"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="all_group_3_b" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="82"/>
      <value value="1599"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="all_group_3_c" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="82"/>
      <value value="1599"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="all_group_3_d" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="82"/>
      <value value="1599"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="all_group_4_a" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="82"/>
      <value value="1599"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="all_group_4_b" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="82"/>
      <value value="1599"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="all_group_4_c" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="82"/>
      <value value="1599"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="all_group_4_d" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-random</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="green-patches">
      <value value="82"/>
      <value value="1599"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="11"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fertile-land">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="barren-land">
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test_map" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-map-landtypes</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green-patches">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line2">
      <value value="19"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="line1">
      <value value="-4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test_map_2" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-map-landtypes</setup>
    <go>go</go>
    <timeLimit steps="50"/>
    <metric>average-hierarchy</metric>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-villages">
      <value value="27"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBlackWhite.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test_1" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-map-landtypes</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test_2" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-map-landtypes</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.2"/>
      <value value="0.3"/>
      <value value="0.4"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="TESTa" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-map-landtypes</setup>
    <go>go</go>
    <timeLimit steps="500"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="TESTb" repetitions="5" runMetricsEveryStep="true">
    <setup>setup-map-landtypes</setup>
    <go>go</go>
    <timeLimit steps="1500"/>
    <metric>average-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="EXPA1" repetitions="25" runMetricsEveryStep="true">
    <setup>setup-map-landtypes</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>max-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <metric>etla-population</metric>
    <metric>etla-hierarchy</metric>
    <metric>tlac-population</metric>
    <metric>tlac-hierarchy</metric>
    <metric>ocot-population</metric>
    <metric>ocot-hierarchy</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="EXPA2" repetitions="25" runMetricsEveryStep="true">
    <setup>setup-map-landtypes</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>max-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <metric>etla-population</metric>
    <metric>etla-hierarchy</metric>
    <metric>tlac-population</metric>
    <metric>tlac-hierarchy</metric>
    <metric>ocot-population</metric>
    <metric>ocot-hierarchy</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="EXPA3" repetitions="25" runMetricsEveryStep="true">
    <setup>setup-map-landtypes</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>max-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <metric>etla-population</metric>
    <metric>etla-hierarchy</metric>
    <metric>tlac-population</metric>
    <metric>tlac-hierarchy</metric>
    <metric>ocot-population</metric>
    <metric>ocot-hierarchy</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="EXPA4" repetitions="25" runMetricsEveryStep="true">
    <setup>setup-map-landtypes</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>max-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <metric>etla-population</metric>
    <metric>etla-hierarchy</metric>
    <metric>tlac-population</metric>
    <metric>tlac-hierarchy</metric>
    <metric>ocot-population</metric>
    <metric>ocot-hierarchy</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="EXPR1" repetitions="25" runMetricsEveryStep="true">
    <setup>setup-map-random</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>max-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <metric>etla-population</metric>
    <metric>etla-hierarchy</metric>
    <metric>tlac-population</metric>
    <metric>tlac-hierarchy</metric>
    <metric>ocot-population</metric>
    <metric>ocot-hierarchy</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="EXPR2" repetitions="25" runMetricsEveryStep="true">
    <setup>setup-map-random</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>max-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <metric>etla-population</metric>
    <metric>etla-hierarchy</metric>
    <metric>tlac-population</metric>
    <metric>tlac-hierarchy</metric>
    <metric>ocot-population</metric>
    <metric>ocot-hierarchy</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="EXPR3" repetitions="25" runMetricsEveryStep="true">
    <setup>setup-map-random</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>max-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <metric>etla-population</metric>
    <metric>etla-hierarchy</metric>
    <metric>tlac-population</metric>
    <metric>tlac-hierarchy</metric>
    <metric>ocot-population</metric>
    <metric>ocot-hierarchy</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="EXPR4" repetitions="25" runMetricsEveryStep="true">
    <setup>setup-map-random</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>max-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <metric>etla-population</metric>
    <metric>etla-hierarchy</metric>
    <metric>tlac-population</metric>
    <metric>tlac-hierarchy</metric>
    <metric>ocot-population</metric>
    <metric>ocot-hierarchy</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="EXPRR1" repetitions="25" runMetricsEveryStep="true">
    <setup>setup-map-Rrandom</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>max-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <metric>etla-population</metric>
    <metric>etla-hierarchy</metric>
    <metric>tlac-population</metric>
    <metric>tlac-hierarchy</metric>
    <metric>ocot-population</metric>
    <metric>ocot-hierarchy</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="EXPRR2" repetitions="25" runMetricsEveryStep="true">
    <setup>setup-map-Rrandom</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>max-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <metric>etla-population</metric>
    <metric>etla-hierarchy</metric>
    <metric>tlac-population</metric>
    <metric>tlac-hierarchy</metric>
    <metric>ocot-population</metric>
    <metric>ocot-hierarchy</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="EXPRR3" repetitions="25" runMetricsEveryStep="true">
    <setup>setup-map-Rrandom</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>max-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <metric>etla-population</metric>
    <metric>etla-hierarchy</metric>
    <metric>tlac-population</metric>
    <metric>tlac-hierarchy</metric>
    <metric>ocot-population</metric>
    <metric>ocot-hierarchy</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="EXPRR4" repetitions="25" runMetricsEveryStep="true">
    <setup>setup-map-Rrandom</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>max-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <metric>etla-population</metric>
    <metric>etla-hierarchy</metric>
    <metric>tlac-population</metric>
    <metric>tlac-hierarchy</metric>
    <metric>ocot-population</metric>
    <metric>ocot-hierarchy</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="EXPA5" repetitions="25" runMetricsEveryStep="true">
    <setup>setup-map-landtypes</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>max-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <metric>etla-population</metric>
    <metric>etla-hierarchy</metric>
    <metric>tlac-population</metric>
    <metric>tlac-hierarchy</metric>
    <metric>ocot-population</metric>
    <metric>ocot-hierarchy</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="EXPA6" repetitions="25" runMetricsEveryStep="true">
    <setup>setup-map-landtypes</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>average-hierarchy</metric>
    <metric>max-hierarchy</metric>
    <metric>average-polity-hierarchy</metric>
    <metric>social-circumscription</metric>
    <metric>environmental-circumscription</metric>
    <metric>count villages</metric>
    <metric>etla-population</metric>
    <metric>etla-hierarchy</metric>
    <metric>tlac-population</metric>
    <metric>tlac-hierarchy</metric>
    <metric>ocot-population</metric>
    <metric>ocot-hierarchy</metric>
    <enumeratedValueSet variable="filename">
      <value value="&quot;LandTypesBW3.jpg&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classI">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classII">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIa">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="classIIIb">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mountain">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-grow">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-death">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-attack">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tribute">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probability-fragment">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="moving-distance">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="conquering-area">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="placement-distance">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="links?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="labels?">
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
