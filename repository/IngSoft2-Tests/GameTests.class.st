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

	| aDie aGame aBoard someShips |
	someShips := OrderedCollection with: Ship new.
	aDie := Die with: 2.
	aBoard := Board with: 20.
	aGame := Game playedIn: aBoard with: aDie and: someShips.

	self assert: aGame board equals: aBoard
]

{ #category : 'tests' }
GameTests >> test002IfGameIsCreatedWithASingleDieThenIsValid [

	| aDie aGame aBoard someShips |
	someShips := OrderedCollection with: Ship new.
	aDie := Die with: 2.
	aBoard := Board with: 20.
	aGame := Game playedIn: aBoard with: aDie and: someShips.

	self assert: aGame die equals: aDie
]

{ #category : 'tests' }
GameTests >> test003IfGameIsCreatedWithAShipThenIsValid [

	| aShip aDie aGame aBoard someShips firstCell |
	aShip := Ship new.
	someShips := OrderedCollection with: aShip.
	aDie := Die with: 2.
	aBoard := Board with: 20.
	aGame := Game playedIn: aBoard with: aDie and: someShips.
	firstCell := aGame board getMap first.

	self assert: (firstCell includes: aShip)
]

{ #category : 'tests' }
GameTests >> test004IfGameIsCreatedWithMultipleShipsThenIsValid [

	| aDie aGame aBoard aGroupOfShips firstCell |
	aGroupOfShips := OrderedCollection with: Ship new with: Ship new.
	aDie := Die with: 2.
	aBoard := Board with: 20.
	aGame := Game playedIn: aBoard with: aDie and: aGroupOfShips.
	firstCell := aGame board getMap first.

	self assert: (firstCell includesAll: aGroupOfShips)
]

{ #category : 'tests' }
GameTests >> test005IfGameIsCreatedThenAllShipsAreAtCell1 [

	| aGroupOfShips aDie aBoard aGame firstCell |
	aGroupOfShips := OrderedCollection with: Ship new with: Ship new.
	aDie := Die with: 2.
	aBoard := Board with: 20.
	aGame := Game playedIn: aBoard with: aDie and: aGroupOfShips.
	firstCell := aBoard getMap first.

	self assert: (firstCell includesAll: aGroupOfShips)
]

{ #category : 'tests' }
GameTests >> test006IfPlayTurnMovesShipOneSpaceThenIsValid [

	| aShip aDie aGame aBoard aGroupOfShips firstCell secondCell |
	aShip := Ship new.
	aGroupOfShips := OrderedCollection with: aShip with: Ship new.
	aDie := Die with: 2.
	aBoard := Board with: 20.
	aGame := Game playedIn: aBoard with: aDie and: aGroupOfShips.
	firstCell := aGame board getMap first.
	secondCell := aGame board getMap at: 2.

	self assert: ((firstCell includesAll: aGroupOfShips) and:
			 secondCell getShips isEmpty).

	aGame playTurn.

	self assert:
		((firstCell includes: aShip) not and: (secondCell includes: aShip))
]

{ #category : 'tests' }
GameTests >> test007IfPlayTurnTwiceMovesSecondShipThenIsValid [

	| ship1 ship2 ships die board game firstCell secondCell thirdCell |
	ship1 := Ship new.
	ship2 := Ship new.
	ships := OrderedCollection with: ship1 with: ship2.
	die := Die with: 20. 
	board := Board with: 5.
	game := Game playedIn: board with: die and: ships.

	firstCell := board getMap at: 1.
	secondCell := board getMap at: 2.
	thirdCell := board getMap at: 3.

	"Before any turns"
	self assert: (firstCell includes: ship1).
	self assert: (firstCell includes: ship2).

	game playTurn. "ship1 moves to cell 2"
	game playTurn. "ship2 moves to cell 2"

	self assert: (secondCell includes: ship1).
	self assert: (secondCell includes: ship2).
	self deny: (firstCell includes: ship1).
	self deny: (firstCell includes: ship2)
]
