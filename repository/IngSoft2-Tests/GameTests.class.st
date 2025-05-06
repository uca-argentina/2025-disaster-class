Class {
	#name : 'GameTests',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'as yet unclassified' }
GameTests class >> playedIn: aBoard [ 
	self shouldBeImplemented.
]

{ #category : 'tests' }
GameTests >> test001IfGameIsCreatedWithABoardThenIsValid [

	| aDie aGame aBoard aShip |
	aShip := Ship withName: 'Tom'.
	aDie := Die with: 2.
	aBoard := Board with: 20.
	aGame := Game playedIn: aBoard with: aDie and: aShip.

	self assert: aGame board isNotNil
]

{ #category : 'tests' }
GameTests >> test002IfGameIsCreatedWithASingleDieThenIsValid [

	| aDie aGame aBoard aShip |
	aShip := Ship withName: 'Tom'.
	aDie := Die with: 2.
	aBoard := Board with: 20.
	aGame := Game playedIn: aBoard with: aDie and: aShip.

	self assert: (aGame die) isNotNil
]

{ #category : 'tests' }
GameTests >> test003IfGameIsCreatedWithAShipThenIsValid [

	| aDie aGame aBoard aShip |
	aShip := Ship withName: 'Tom'.
	aDie := Die with: 2.
	aBoard := Board with: 20.
	aGame := Game playedIn: aBoard with: aDie and: aShip.

	self assert: (aGame ship) isNotNil
]
