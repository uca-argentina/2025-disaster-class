Class {
	#name : 'Game',
	#superclass : 'Object',
	#instVars : [
		'board',
		'die',
		'ship'
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

	| aShip |
	board := aBoard.
	( ( board getMap ) at: 1 )enters: someShips.
	die := aDie.
	ship := aShip.
]

{ #category : 'accessing' }
Game >> ship [
	^ ship
]
