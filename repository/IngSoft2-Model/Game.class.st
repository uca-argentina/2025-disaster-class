Class {
	#name : 'Game',
	#superclass : 'Object',
	#instVars : [
		'board',
		'dice',
		'ships',
		'shipTurnIndex'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Game class >> playedIn: aBoard with: aDie and: someShips [

	^ self new initializeWith: aBoard and: aDie and: someShips
]

{ #category : 'accessing' }
Game >> board [

	^ board
]

{ #category : 'accessing' }
Game >> dice [

	^ dice
]

{ #category : 'as yet unclassified' }
Game >> finalPositions [

	^ Dictionary newFrom: (ships collect: [ :ship |
			   ship -> (board getMap indexOf:
				    (board getMap detect: [ :cell | cell includes: ship ])) ])
]

{ #category : 'initialization' }
Game >> initializeWith: aBoard and: someDice and: someShips [

	board := aBoard.
	dice := someDice.
	ships := someShips.
	shipTurnIndex := 1.
	board placeAllShipsAtStart: someShips
]

{ #category : 'testing' }
Game >> isOver [

	^ self winner notNil
]

{ #category : 'as yet unclassified' }
Game >> playTurn [ 
	| shipToPlay oldCell totalRoll targetIndex newCell |
	self isOver ifTrue: [ ^self ].

	shipToPlay := ships at: shipTurnIndex.
	oldCell := board getMap detect: [ :cell | cell includes: shipToPlay ].
	oldCell leaves: shipToPlay.

	totalRoll := dice sum: [ :eachDie | eachDie rollDice ].

	targetIndex := (board getMap indexOf: oldCell) + totalRoll.
	targetIndex := targetIndex min: board getMap size. "evita pasarse"

	newCell := board getMap at: targetIndex.
	newCell enters: shipToPlay.

	board applyEffectTo: shipToPlay.

	shipTurnIndex := shipTurnIndex \\ ships size + 1.

]

{ #category : 'testing' }
Game >> winner [

	^ ships
		  detect: [ :ship |
			  | shipCell |
			  shipCell := board getMap detect: [ :cell | cell includes: ship ].
			  shipCell = board getMap last ]
		  ifNone: [ nil ]
]
