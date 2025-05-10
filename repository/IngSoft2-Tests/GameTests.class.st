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
	aShip := Ship new.
	aDie := Die with: 2.
	aBoard := Board with: 20.
	aGame := Game playedIn: aBoard with: aDie and: aShip.

	self assert: aGame board isNotNil
]

{ #category : 'tests' }
GameTests >> test002IfGameIsCreatedWithASingleDieThenIsValid [

	| aDie aGame aBoard aShip |
	aShip := Ship new.
	aDie := Die with: 2.
	aBoard := Board with: 20.
	aGame := Game playedIn: aBoard with: aDie and: aShip.

	self assert: (aGame die) isNotNil
]

{ #category : 'tests' }
GameTests >> test003IfGameIsCreatedWithAShipThenIsValid [

	| aDie aGame aBoard aShip |
	aShip := Ship new.
	aDie := Die with: 2.
	aBoard := Board with: 20.
	aGame := Game playedIn: aBoard with: aDie and: aShip.

	self assert: (aGame ship) isNotNil
]

{ #category : 'tests' }
GameTests >> test004IfGameIsCreatedWithMultipleShipsThenIsValid [


	| aDie aGame aBoard aShip anotherShip aGroupOfShips |
	aShip := Ship new.
	anotherShip := Ship new.
	aGroupOfShips := OrderedCollection with: aShip with: anotherShip.
	aDie := Die with: 2. 
	aBoard := Board with: 20.
	aGame := Game playedIn: aBoard with: aDie and: aGroupOfShips.

	self assert: (aGame ship) equals: aGroupOfShips.
]

{ #category : 'tests' }
GameTests >> test005IfAGameIsCreatedThenAllShipsAreAtCell1 [

	| aDie aGame aBoard aShip anotherShip aGroupOfShips |
	aShip := Ship new.
	anotherShip := Ship new.
	aGroupOfShips := OrderedCollection with: aShip with: anotherShip.
	aDie := Die with: 2.
	aBoard := Board with: 20.
	aGame := Game playedIn: aBoard with: aDie and: aGroupOfShips.

	self assert: ((aGame board getMap) at: 1) getShips = aGroupOfShips
]
