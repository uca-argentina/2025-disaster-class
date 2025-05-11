Class {
	#name : 'Game',
	#superclass : 'Object',
	#instVars : [
		'board',
		'die',
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
Game >> die [
	^ die
]

{ #category : 'initialization' }
Game >> initializeWith: aBoard and: aDie and: someShips [
	board := aBoard.
	die := aDie.
	ships := someShips.
	shipTurnIndex := 1.
	board placeAllShipsAtStart: someShips.
]

{ #category : 'as yet unclassified' }
Game >> playTurn [
	| shipToPlay oldCell newCell |
	shipToPlay := ships at: shipTurnIndex.
 
	oldCell := board getMap detect: [ :cell | cell includes: shipToPlay ].
	oldCell leaves: shipToPlay.

	newCell := board getMap at: ((board getMap indexOf: oldCell) + 1).
	newCell enters: shipToPlay.

	shipTurnIndex := (shipTurnIndex \\ ships size) + 1.
]
