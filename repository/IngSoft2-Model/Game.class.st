Class {
	#name : #Game,
	#superclass : #Object,
	#instVars : [
		'board',
		'die',
		'ships',
		'shipTurnIndex'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
Game class >> playedIn: aBoard with: aDie and: someShips [

	^ self new initializeWith: aBoard and: aDie and: someShips
]

{ #category : #accessing }
Game >> board [
	^ board
]

{ #category : #accessing }
Game >> die [
	^ die
]

{ #category : #initialization }
Game >> initializeWith: aBoard and: aDie and: someShips [
	board := aBoard.
	die := aDie.
	ships := someShips.
	shipTurnIndex := 1.
	board placeAllShipsAtStart: someShips.
]

{ #category : #testing }
Game >> isOver [

	^ ships anySatisfy: [ :ship |
		  | shipCell |
		  shipCell := board getMap detect: [ :cell | cell includes: ship ].
		  shipCell = board getMap last ]
]

{ #category : #'as yet unclassified' }
Game >> playTurn [
	| shipToPlay oldCell roll targetIndex newCell  |
	
shipToPlay := ships at: shipTurnIndex.
oldCell := board getMap detect: [:cell | cell includes: shipToPlay].
oldCell leaves: shipToPlay.

roll:= die rollDice.
targetIndex := (board getMap indexOf: oldCell) + roll.
targetIndex := targetIndex min: board getMap size. "evita que se pase al final"

newCell := board getMap at: targetIndex.
newCell enters: shipToPlay.

board applyEffectTo: shipToPlay.

shipTurnIndex := (shipTurnIndex \\ ships size ) + 1.


]
