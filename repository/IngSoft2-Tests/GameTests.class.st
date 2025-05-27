Class {
	#name : 'GameTests',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
GameTests >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
GameTests >> test001IfGameIsCreatedWithABoardThenIsValid [

	| aDie aGame cells aGenerator aBoard |
	aDie := Die with: 2.

	aGenerator := DefaultCellGenerator withDistributions: {
		([ RegularCell new ] -> 1.0)
	}.

	cells := aGenerator generateCells: 20.
	WormholeCell newPairIn: cells at: 2 and: 4.
	aBoard := Board withCells: cells.

	aGame := Game
		createdWith: aGenerator
		playedOnABoardSized: 20
		withWormholesAt: 2
		and: 4
		for: 1
		with: (OrderedCollection with: aDie)
		andShipsNamed: #( 'Apollo' ).

	self assert: aGame board size equals: aBoard size.

]

{ #category : 'tests' }
GameTests >> test002IfGameIsCreatedWithASingleDieThenIsValid [

	| aDie aGame aGenerator someDice |
	aDie := Die with: 2.
	someDice := OrderedCollection with: aDie.

	aGenerator := DefaultCellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := Game
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 2
		         and: 4
		         for: 1
		         with: someDice
		         andShipsNamed: #( 'Apollo' ).

	self assert: aGame dice equals: someDice
]

{ #category : 'tests' }
GameTests >> test003IfGameIsCreatedWithAShipThenIsValid [

	| aDie aGame aGenerator someDice |
	aDie := Die with: 2.
	someDice := OrderedCollection with: aDie.

	aGenerator := DefaultCellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := Game
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 2
		         and: 4
		         for: 1
		         with: someDice
		         andShipsNamed: #( 'Apollo' ).

	self assert:
		(aGame ships anySatisfy: [ :ship | ship name = 'Apollo' ])
]

{ #category : 'tests' }
GameTests >> test004IfGameIsCreatedWithMultipleShipsThenIsValid [

	| aDie aGame aGenerator someDice |
	aDie := Die with: 2.
	someDice := OrderedCollection with: aDie.

	aGenerator := DefaultCellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := Game
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 2
		         and: 4
		         for: 1
		         with: someDice
		         andShipsNamed: #( 'Apollo' 'Orion' ).

	self assert:
		(aGame ships anySatisfy: [ :ship | ship name = 'Apollo' ]).
	self assert:
		(aGame ships anySatisfy: [ :ship | ship name = 'Orion' ])
]

{ #category : 'tests' }
GameTests >> test005IfGameIsCreatedThenAllShipsAreAtCell1 [

	| aDie aGenerator aGame someDice positions |
	aDie := Die with: 2.
	someDice := OrderedCollection with: aDie.

	aGenerator := DefaultCellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := Game
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 2
		         and: 4
		         for: 1
		         with: someDice
		         andShipsNamed: #( 'Apollo' 'Orion' ).

	positions := aGame positions.

	self assert: (positions values allSatisfy: [ :pos | pos = 1 ])
]

{ #category : 'tests' }
GameTests >> test006IfPlayTurnMovesShipOneSpaceThenIsValid [

	| aDie aGame aGenerator positionsBefore positionsAfter |
	aDie := TestDie withRolls: #( 1 ).
	aGenerator := DefaultCellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := Game
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 10
		         and: 18
		         for: 1
		         with: (OrderedCollection with: aDie)
		         andShipsNamed: #( 'Apollo' 'Orion' ).

	positionsBefore := aGame positions.

	self assert: (positionsBefore at: 'Apollo') equals: 1.
	self assert: (positionsBefore at: 'Orion') equals: 1.

	aGame playTurn.

	positionsAfter := aGame positions.

	self assert: (positionsAfter at: 'Apollo') equals: 2.
	self assert: (positionsAfter at: 'Orion') equals: 1
]

{ #category : 'tests' }
GameTests >> test007IfPlayTurnTwiceMovesSecondShipThenIsValid [

	| aDie aGenerator game positionsAfterTurn2 |
	aDie := TestDie withRolls: #( 2 ).
	aGenerator := DefaultCellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	game := Game
		        createdWith: aGenerator
		        playedOnABoardSized: 20
		        withWormholesAt: 2
		        and: 4
		        for: 1
		        with: (OrderedCollection with: aDie)
		        andShipsNamed: #( 'Apollo' 'Orion' ).

	self assert: (game positions at: 'Apollo') equals: 1.
	self assert: (game positions at: 'Orion') equals: 1.

	game playTurn.
	game playTurn.

	positionsAfterTurn2 := game positions.

	self assert: (positionsAfterTurn2 at: 'Apollo') equals: 3.
	self assert: (positionsAfterTurn2 at: 'Orion') equals: 3
]

{ #category : 'tests' }
GameTests >> test008IfShipFallsIntoWormholeThenIsTransportedToOtherEndThenIsValid [

	| aDie aGenerator aGame positionsAfter |
	aDie := TestDie withRolls: #( 1 ).
	aGenerator := DefaultCellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := Game
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 2
		         and: 4
		         for: 1
		         with: (OrderedCollection with: aDie)
		         andShipsNamed: #( 'Apollo' ).

	aGame playTurn.

	positionsAfter := aGame positions.

	self assert: (positionsAfter at: 'Apollo') equals: 4
]

{ #category : 'tests' }
GameTests >> test009IfRollDiceMovesShipAccordinglyThenIsValid [

	| aDie aGenerator aGame positionsBefore positionsAfter |
	aDie := TestDie withRolls: #( 3 ).
	aGenerator := DefaultCellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := Game
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 10
		         and: 18
		         for: 1
		         with: (OrderedCollection with: aDie)
		         andShipsNamed: #( 'Apollo' ).

	positionsBefore := aGame positions.

	self assert: (positionsBefore at: 'Apollo') equals: 1.

	aGame playTurn.

	positionsAfter := aGame positions.

	self assert: (positionsAfter at: 'Apollo') equals: 4
]

{ #category : 'tests' }
GameTests >> test010GameIsOverWhenShipCompletesTheRequiredLaps [

	| aDie aGenerator aGame |
	aDie := TestDie withRolls: #( 20 ).

	aGenerator := DefaultCellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := Game
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 10
		         and: 18
		         for: 1
		         with: (OrderedCollection with: aDie)
		         andShipsNamed: #( 'Apollo' ).

	self deny: aGame isOver.

	aGame playTurn.

	self assert: aGame isOver
]

{ #category : 'tests' }
GameTests >> test011GameIsNotOverWhenNoShipHasReachedTheEnd [

	| die generator game |
	die := TestDie withRolls: #( 1 ).
	generator := DefaultCellGenerator withDistributions:
		             { ([ RegularCell new ] -> 1.0) }.

	game := Game
		        createdWith: generator
		        playedOnABoardSized: 20
		        withWormholesAt: 2
		        and: 4
		        for: 1
		        with: (OrderedCollection with: die)
		        andShipsNamed: #( 'Apollo' ).

	self deny: game isOver.

	game playTurn.

	self deny: game isOver
]

{ #category : 'tests' }
GameTests >> test012IfShipReachesLastCellThenWinnerIsThatShip [

	| die generator game |
	die := TestDie withRolls: #( 20 ).
	generator := DefaultCellGenerator withDistributions:
		             { ([ RegularCell new ] -> 1.0) }.

	game := Game
		        createdWith: generator
		        playedOnABoardSized: 20
		        withWormholesAt: 10
		        and: 18
		        for: 1
		        with: (OrderedCollection with: die)
		        andShipsNamed: #( 'Apollo' ).

	self assert: game winner isNil.

	game playTurn.

	self assert: game winner name equals: 'Apollo'
]

{ #category : 'tests' }
GameTests >> test013GameIsOverWhenThereIsAWinner [

	| die generator game |
	die := TestDie withRolls: #( 20 ).
	generator := DefaultCellGenerator withDistributions:
		             { ([ RegularCell new ] -> 1.0) }.

	game := Game
		        createdWith: generator
		        playedOnABoardSized: 20
		        withWormholesAt: 10
		        and: 18
		        for: 1
		        with: (OrderedCollection with: die)
		        andShipsNamed: #( 'Apollo' ).

	self deny: game isOver.
	self assert: game winner isNil.

	game playTurn.

	self assert: game isOver.
	self assert: game winner name equals: 'Apollo'
]

{ #category : 'tests' }
GameTests >> test014NoMoreTurnsAfterGameIsOverWhenLapsCompleted [

	| aDie aGenerator aGame somePositions aShip |
	aDie := TestDie withRolls: #( 20 ).

	aGenerator := DefaultCellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := Game
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 10
		         and: 18
		         for: 1
		         with: (OrderedCollection with: aDie)
		         andShipsNamed: #( 'Apollo' ).

	aGame playTurn.
	self assert: aGame isOver.

	somePositions := aGame positions.
	self assert: (somePositions at: 'Apollo') equals: 1.

	aGame playTurn. "No debería cambiar nada"

	self assert: aGame isOver.
	self assert: (aGame positions at: 'Apollo') equals: 1.

	aShip := aGame ships first.
	self assert: (aGame currentLapsFor: aShip) equals: 1
]

{ #category : 'tests' }
GameTests >> test015IfYouCanPlayWithMultipleDieConsecutivelyThenIsValid [

	| aDie1 aDie2 someDice aGenerator aGame somePositions aShip |
	aDie1 := TestDie withRolls: #( 6 4 ).
	aDie2 := TestDie withRolls: #( 5 5 ).
	someDice := OrderedCollection with: aDie1 with: aDie2.

	aGenerator := DefaultCellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := Game
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 10
		         and: 18
		         for: 1
		         with: someDice
		         andShipsNamed: #( 'Apollo' ).

	aGame playTurn.
	self deny: aGame isOver.

	somePositions := aGame positions.
	self assert: (somePositions at: 'Apollo') equals: 12.

	aGame playTurn.
	self assert: aGame isOver.

	somePositions := aGame positions.
	self assert: (somePositions at: 'Apollo') equals: 1.

	aShip := aGame ships first.
	self assert: (aGame currentLapsFor: aShip) equals: 1
]

{ #category : 'tests' }
GameTests >> test016IfWhenGameEndsItReportsWinnerAndFinalPositionsCorrectlyThenIsValid [

	| aDie aGenerator aGame somePositions |
	aDie := TestDie withRolls: #( 20 ).

	aGenerator := DefaultCellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := Game
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 10
		         and: 18
		         for: 1
		         with: (OrderedCollection with: aDie)
		         andShipsNamed: #( 'Apollo' 'Orion' ).

	aGame playTurn.

	self assert: aGame isOver.
	self assert: aGame winner name equals: 'Apollo'.

	somePositions := aGame positions.
	self assert: (somePositions at: 'Apollo') equals: 1.
	self assert: (somePositions at: 'Orion') equals: 1
]

{ #category : 'tests' }
GameTests >> test017IfWhenGameEndsPlayTurnDoesNothingThenIsValid [

	| aDie aGenerator aGame somePositions |
	aDie := TestDie withRolls: #( 21 ).
	aGenerator := DefaultCellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := Game
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 10
		         and: 18
		         for: 1
		         with: (OrderedCollection with: aDie)
		         andShipsNamed: #( 'Apollo' 'Orion' ).

	aGame playTurn.
	self assert: aGame isOver.

	somePositions := aGame positions.
	self assert: (somePositions at: 'Apollo') equals: 2.
	self assert: (somePositions at: 'Orion') equals: 1.

	aGame playTurn.

	somePositions := aGame positions.
	self assert: (somePositions at: 'Apollo') equals: 2.
	self assert: (somePositions at: 'Orion') equals: 1
]

{ #category : 'tests' }
GameTests >> test018ShipStartsWithFuelAndConsumesItPerStepMoved [

	| aDie aGenerator aGame initialFuel fuelAfterTurn |
	aDie := TestDie withRolls: #( 3 ).
	aGenerator := DefaultCellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := Game
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 10
		         and: 18
		         for: 1
		         with: (OrderedCollection with: aDie)
		         andShipsNamed: #( 'Apollo' ).

	initialFuel := aGame fuelOf: 'Apollo'.
	self assert: initialFuel equals: 6.

	aGame playTurn.

	fuelAfterTurn := aGame fuelOf: 'Apollo'.
	self assert: fuelAfterTurn equals: 3
]

{ #category : 'tests' }
GameTests >> test019IfShipRunsOutOfFuelThenReturnsToFirstCell [

	| die generator game ship |
	die := TestDie withRolls: #( 6 ).
	generator := DefaultCellGenerator withDistributions:
		             { ([ RegularCell new ] -> 1.0) }.

	game := Game
		        createdWith: generator
		        playedOnABoardSized: 10
		        withWormholesAt: 3
		        and: 7
		        for: 1
		        with: (OrderedCollection with: die)
		        andShipsNamed: #( 'Apollo' ).

	ship := game ships first.
	ship consumeFuel: 12. "Simula que no tiene suficiente fuel"

	game playTurn.

	self assert: (game board indexOfCellContaining: ship) equals: 1
]

{ #category : 'tests' }
GameTests >> test020IfShipRunsOutOfFuelThenLosesTwoTurns [

	| die generator game ship |
	die := TestDie withRolls: #( 6 ).
	generator := DefaultCellGenerator withDistributions:
		             { ([ RegularCell new ] -> 1.0) }.

	game := Game
		        createdWith: generator
		        playedOnABoardSized: 10
		        withWormholesAt: 3
		        and: 7
		        for: 1
		        with: (OrderedCollection with: die)
		        andShipsNamed: #( 'Apollo' ).

	ship := game ships first.
	ship consumeFuel: 12.

	game playTurn. "turno 1"
	self deny: ship canPlay.

	game playTurn. "turno 2"
	self deny: ship canPlay.

	game playTurn. "turno 3"
	self assert: ship canPlay
]

{ #category : 'tests' }
GameTests >> test021IfPlayerSkipsTurnThenFuelIsRestoredToMax [

	| die generator game ship |
	die := TestDie withRolls: #( 3 ).
	generator := DefaultCellGenerator withDistributions:
		             { ([ RegularCell new ] -> 1.0) }.

	game := Game
		        createdWith: generator
		        playedOnABoardSized: 10
		        withWormholesAt: 2
		        and: 4
		        for: 1
		        with: (OrderedCollection with: die)
		        andShipsNamed: #( 'Apollo' ).

	ship := game ships first.
	ship consumeFuel: 5.
	self assert: ship fuel equals: 1.

	game skipTurn.

	self assert: ship fuel equals: ship fuelCapacity
]

{ #category : 'tests' }
GameTests >> test022IfGameIsCreatedWithCellGeneratorThenIsValid [

	| die generator game |
	die := TestDie withRolls: #( 1 ).

	generator := DefaultCellGenerator withDistributions:
		             { ([ RegularCell new ] -> 1.0) }.

	game := Game
		        createdWith: generator
		        playedOnABoardSized: 5
		        withWormholesAt: 2
		        and: 4
		        for: 3
		        with: (OrderedCollection with: die)
		        andShipsNamed: #( 'Apollo' 'Orion' ).

	self assert: game board size equals: 5
]
