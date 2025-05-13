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

	self assert: aGame dice equals: aDie
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
	aDie := OrderedCollection with: (TestDie withForcedRoll: 1).
	aBoard := Board with: 20.
	aGame := Game playedIn: aBoard with: aDie and: aGroupOfShips.

	firstCell := aGame board getMap at: 1.
	secondCell := aGame board getMap at: 2.

	self assert: ((firstCell includesAll: aGroupOfShips) and:
			 secondCell getShips isEmpty).

	aGame playTurn.

	self assert:
		((firstCell includes: aShip) not and: (secondCell includes: aShip))
]

{ #category : 'tests' }
GameTests >> test007IfPlayTurnTwiceMovesSecondShipThenIsValid [

	| ship1 ship2 ships die board game firstCell thirdCell |
	ship1 := Ship new.
	ship2 := Ship new.
	ships := OrderedCollection with: ship1 with: ship2.
	die := OrderedCollection with: (TestDie withForcedRoll: 2).
	board := Board with: 5.
	game := Game playedIn: board with: die and: ships.

	firstCell := board getMap at: 1.
	thirdCell := board getMap at: 3.

	self assert: (firstCell includes: ship1).
	self assert: (firstCell includes: ship2).

	game playTurn.
	game playTurn.

	self assert: (thirdCell includes: ship1).
	self assert: (thirdCell includes: ship2).
	self deny: (firstCell includes: ship1).
	self deny: (firstCell includes: ship2)
]

{ #category : 'tests' }
GameTests >> test008IfShipFallsIntoWormholeThenIsTransportedToOtherEndThenIsValid [

	| aShip aDie aBoard aGame resultCell pair |
	aShip := Ship new.
	aDie := OrderedCollection with: (TestDie withForcedRoll: 1).
	aBoard := Board new.
	aBoard initializeWith: 5.

	pair := WormholeCell createPair.
	aBoard getMap at: 2 put: (pair at: 1).
	aBoard getMap at: 4 put: (pair at: 2).

	aGame := Game
		         playedIn: aBoard
		         with: aDie
		         and: (OrderedCollection with: aShip).

	aGame playTurn.

	resultCell := aBoard getMap at: 4.

	self assert: (resultCell includes: aShip)
]

{ #category : 'tests' }
GameTests >> test009IfRollDiceMovesShipAccordinglyThenIsValid [

	| aShip aDie aBoard aGame startCell targetCell |
	aShip := Ship new.
	aDie := OrderedCollection with: (TestDie withForcedRoll: 3).
	aBoard := Board with: 10.
	aGame := Game
		         playedIn: aBoard
		         with: aDie
		         and: (OrderedCollection with: aShip).

	startCell := aBoard getMap at: 1.
	targetCell := aBoard getMap at: 4.

	self assert: (startCell includes: aShip).

	aGame playTurn.

	self assert: (targetCell includes: aShip).
	self deny: (startCell includes: aShip)
]

{ #category : 'tests' }
GameTests >> test010GameIsOverWhenShipReachesLastCell [

	| aShip aDie aBoard aGame |
	aShip := Ship new.
	aDie := OrderedCollection with: (TestDie withForcedRoll: 4).
	aBoard := Board with: 5.
	aGame := Game playedIn: aBoard with: aDie and: (OrderedCollection with: aShip).
	
	self deny: aGame isOver.
	
	aGame playTurn.
	
	self assert: aGame isOver. 
]

{ #category : 'tests' }
GameTests >> test011GameIsNotOverWhenNoShipHasReachedTheEnd [
	| ship die board game |
	ship := Ship new.
	die := OrderedCollection with: (TestDie withForcedRoll: 1).
	board := Board with: 5.
	game := Game playedIn: board with: die and: (OrderedCollection with: ship).
	
	self deny: game isOver.
	
	game playTurn.
	
	self deny: game isOver.
]

{ #category : 'tests' }
GameTests >> test012IfShipReachesLastCellThenWinnerIsThatShip [

	| ship die board game |
	ship := Ship new.
	die := OrderedCollection with: (TestDie withForcedRoll: 4). 
	board := Board with: 5.
	game := Game
		        playedIn: board
		        with: die
		        and: (OrderedCollection with: ship).

	self assert: game winner isNil.

	game playTurn.

	self assert: game winner equals: ship
]

{ #category : 'tests' }
GameTests >> test013GameIsOverWhenThereIsAWinner [

	| ship die board game |
	ship := Ship new.
	die:= OrderedCollection with: (TestDie withForcedRoll: 4).
	board := Board with: 5.
	game := Game playedIn: board with: die and: (OrderedCollection with: ship).
	
	self deny: game isOver.
	self assert: game winner isNil.
	
	game playTurn.
	
	self assert: game isOver.
	self assert: game winner equals: ship.
]

{ #category : 'tests' }
GameTests >> test014ThereAreNoMoreTurnsAfterThereIsAWinnerAndGameIsOverThenIsValid [

	| ship die board game lastCell |
	ship := Ship new.
	die := OrderedCollection with: (TestDie withForcedRoll: 4).
	board := Board with: 5.
	game := Game
		        playedIn: board
		        with: die
		        and: (OrderedCollection with: ship).

	game playTurn.
	lastCell := board getMap last.

	self assert: game isOver.
	self assert: (lastCell includes: ship).
	
	game playTurn.
	
	self assert: (lastCell includes: ship).
	self assert: game isOver.
]

{ #category : 'tests' }
GameTests >> test015IfYouCanPlayWithMultipleDieThenIsValid [

	| aShip aDie board game aSecondDie someDice lastCell |
	aShip := Ship new.
	aDie := TestDie withForcedRoll: 2.
	aSecondDie := TestDie withForcedRoll: 2.
	someDice := OrderedCollection with: aDie with: aSecondDie.
	board := Board with: 5.
	game := Game
		        playedIn: board
		        with: someDice
		        and: (OrderedCollection with: aShip).
	lastCell := board getMap last.

	game playTurn.
	self assert: (lastCell includes: aShip)
]

{ #category : 'tests' }
GameTests >> test016IFWhenGameEndsItReportsWinnerAndFinalPositionsCorrectlyThenIsValid [

	| ship1 ship2 board game die finalPositions |
	ship1 := Ship new.
	ship2 := Ship new.
	die := TestDie withForcedRoll: 4.
	board := Board with: 5.
	game := Game
		        playedIn: board
		        with: (OrderedCollection with: die)
		        and: (OrderedCollection with: ship1 with: ship2).

	game playTurn.

	self assert: game isOver.
	self assert: game winner equals: ship1.

	finalPositions := game finalPositions.

	self assert: (finalPositions at: ship1) equals: 5.
	self assert: (finalPositions at: ship2) equals: 1
]
