Class {
	#name : #GameTests,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
GameTests >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: errorMessage ]
]

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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
	self assert: (aGame board lapsCompletedOf: aShip) equals: 1

]

{ #category : #tests }
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
	self assert: (aGame board lapsCompletedOf: aShip) equals: 1

]

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

	game playTurn. 
	self deny: ship canPlay.

	game playTurn. 
	self deny: ship canPlay.

	game playTurn.
	self assert: ship canPlay
]

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
GameTests >> test023AtomicBombCellMovesAllShipsToStart [
    | ship1 ship2 board bombCell cells |

    ship1 := Ship withName: 'Apollo' and: 10.
    ship2 := Ship withName: 'Orion' and: 10.

    bombCell := AtomicBombCell new.

    cells := (1 to: 10) collect: [:i | RegularCell new].
    cells at: 5 put: bombCell.

    board := Board withCells: cells andShips: { ship1. ship2 } asOrderedCollection.
    board placeAllShipsAtStart: { ship1. ship2 } asOrderedCollection.

    board moveShip: ship1 steps: 4. 
    board moveShip: ship2 steps: 6.

    (board cellAt: 5) applyEffectTo: ship1 in: board.

    self assert: (board indexOfCellContaining: ship1) equals: 1.
    self assert: (board indexOfCellContaining: ship2) equals: 1.
]

{ #category : #tests }
GameTests >> test024AtomicBombCellDoesNotResetLaps [
    | ship1 ship2 board bombCell cells |

    ship1 := Ship withName: 'Apollo' and: 10.
    ship2 := Ship withName: 'Orion' and: 10.

    bombCell := AtomicBombCell new.

    cells := (1 to: 10) collect: [:i | RegularCell new].
    cells at: 5 put: bombCell.

    board := Board withCells: cells andShips: { ship1. ship2 } asOrderedCollection.
    board placeAllShipsAtStart: { ship1. ship2 } asOrderedCollection.

    board incrementLapsFor: ship1.
    board incrementLapsFor: ship2.

    board moveShip: ship1 steps: 4.

    (board cellAt: 5) applyEffectTo: ship1 in: board.

    self assert: (board lapsCompletedOf: ship1) equals: 1.
    self assert: (board lapsCompletedOf: ship2) equals: 1.

]

{ #category : #tests }
GameTests >> test025BlackHoleCellMovesShipBackwardsAndConsumesFuel [
    | ship board blackHoleCell cells initialFuel |

    ship := Ship withName: 'Apollo' and: 10.

    blackHoleCell := BlackHoleCell new.

    cells := (1 to: 10) collect: [:i | RegularCell new].
    cells at: 6 put: blackHoleCell.

    board := Board withCells: cells andShips: { ship } asOrderedCollection.
    board placeAllShipsAtStart: { ship } asOrderedCollection.

    board moveShip: ship steps: 5.

    initialFuel := ship fuel.

    (board cellAt: 6) applyEffectTo: ship in: board.

    self assert: (board indexOfCellContaining: ship) equals: 2.
    self assert: ship fuel < initialFuel.

]

{ #category : #tests }
GameTests >> test026BlackHoleCellSendsShipToStartAndPenalizesWhenNotEnoughFuel [
    | ship board blackHoleCell cells |

    ship := Ship withName: 'Apollo' and: 2.

    blackHoleCell := BlackHoleCell new.

    cells := (1 to: 10) collect: [:i | RegularCell new].
    cells at: 6 put: blackHoleCell.

    board := Board withCells: cells andShips: { ship } asOrderedCollection.
    board placeAllShipsAtStart: { ship } asOrderedCollection.

    board moveShip: ship steps: 5. 

    (board cellAt: 6) applyEffectTo: ship in: board.

    self assert: (board indexOfCellContaining: ship) equals: 1.
    self assert: ship fuel equals: ship fuelCapacity.
    self assert: ship canPlay not.

]

{ #category : #tests }
GameTests >> test027BlackHoleCellWrapsAroundWhenMovingBackwards [
    | ship board blackHoleCell cells |

    ship := Ship withName: 'Apollo' and: 10.

    blackHoleCell := BlackHoleCell new.

    cells := (1 to: 10) collect: [:i | RegularCell new].
    cells at: 3 put: blackHoleCell.

    board := Board withCells: cells andShips: { ship } asOrderedCollection.
    board placeAllShipsAtStart: { ship } asOrderedCollection.

    board moveShip: ship steps: 2. 

    (board cellAt: 3) applyEffectTo: ship in: board.

    self assert: (board indexOfCellContaining: ship) equals: 9.


]

{ #category : #tests }
GameTests >> test028BlackHoleCellPenalizesIfNotEnoughFuelAndItCrossesCircularBoard [
    | ship board blackHoleCell cells |

    ship := Ship withName: 'Apollo' and: 3.  

    blackHoleCell := BlackHoleCell new.

    cells := (1 to: 10) collect: [:i | RegularCell new].
    cells at: 2 put: blackHoleCell.

    board := Board withCells: cells andShips: { ship } asOrderedCollection.
    board placeAllShipsAtStart: { ship } asOrderedCollection.

    board moveShip: ship steps: 1. 

    (board cellAt: 2) applyEffectTo: ship in: board.

    self assert: (board indexOfCellContaining: ship) equals: 1.
    self assert: ship fuel equals: ship fuelCapacity.
    self assert: ship canPlay not.



]

{ #category : #tests }
GameTests >> test029MoonWalkCellMovesAllOtherShipsBackwardsAndConsumesFuel [
    | apollo orion board moonWalkCell cells initialFuelApollo initialFuelOrion |

    apollo := Ship withName: 'Apollo' and: 10.
    orion := Ship withName: 'Orion' and: 10.

    moonWalkCell := MoonWalkCell new.

    cells := (1 to: 10) collect: [:i | RegularCell new].
    cells at: 4 put: moonWalkCell.

    board := Board withCells: cells andShips: { apollo. orion } asOrderedCollection.
    board placeAllShipsAtStart: { apollo. orion } asOrderedCollection.

    board moveShip: apollo steps: 3. 
    board moveShip: orion steps: 5.   

    initialFuelApollo := apollo fuel.
    initialFuelOrion := orion fuel.

    (board cellAt: 4) applyEffectTo: apollo in: board.

    self assert: (board indexOfCellContaining: apollo) equals: 4.  
    self assert: (board indexOfCellContaining: orion) equals: 5.  

    self assert: apollo fuel equals: initialFuelApollo.
    self assert: orion fuel < initialFuelOrion.
]

{ #category : #tests }
GameTests >> test30MoonWalkCellMovesOthersBackwardsByCustomAmountAndPenalizesIfNeeded [
    | apollo orion board moonWalkCell cells |

    apollo := Ship withName: 'Apollo' and: 10.
    orion := Ship withName: 'Orion' and: 1.  

    moonWalkCell := MoonWalkCell withSteps: 3.

    cells := (1 to: 10) collect: [:i | RegularCell new].
    cells at: 5 put: moonWalkCell.

    board := Board withCells: cells andShips: { apollo. orion } asOrderedCollection.
    board placeAllShipsAtStart: { apollo. orion } asOrderedCollection.

    board moveShip: apollo steps: 4.
    board moveShip: orion steps: 6.  

    (board cellAt: 5) applyEffectTo: apollo in: board.

    self assert: (board indexOfCellContaining: apollo) equals: 5.  
    self assert: (board indexOfCellContaining: orion) equals: 1. 
    self assert: orion fuel equals: orion fuelCapacity.
    self assert: orion canPlay not.

]

{ #category : #tests }
GameTests >> test31MoonWalkCellWrapsAroundWhenMovingOthersBackwards [
    | apollo orion board moonWalkCell cells |

    apollo := Ship withName: 'Apollo' and: 10.
    orion := Ship withName: 'Orion' and: 10.

    moonWalkCell := MoonWalkCell withSteps: 3.

    cells := (1 to: 10) collect: [:i | RegularCell new].
    cells at: 5 put: moonWalkCell.

    board := Board withCells: cells andShips: { apollo. orion } asOrderedCollection.
    board placeAllShipsAtStart: { apollo. orion } asOrderedCollection.

    board moveShip: apollo steps: 4.  
    board moveShip: orion steps: 1.  

    (board cellAt: 5) applyEffectTo: apollo in: board.

    self assert: (board indexOfCellContaining: apollo) equals: 5.  
    self assert: (board indexOfCellContaining: orion) equals: 9.  
]

{ #category : #tests }
GameTests >> test32MoonWalkCellWrapsAndPenalizesIfNotEnoughFuel [
    | apollo orion board moonWalkCell cells |

    apollo := Ship withName: 'Apollo' and: 10.
    orion := Ship withName: 'Orion' and: 2.  

    moonWalkCell := MoonWalkCell withSteps: 3.

    cells := (1 to: 10) collect: [:i | RegularCell new].
    cells at: 5 put: moonWalkCell.

    board := Board withCells: cells andShips: { apollo. orion } asOrderedCollection.
    board placeAllShipsAtStart: { apollo. orion } asOrderedCollection.

    board moveShip: apollo steps: 4.  
    board moveShip: orion steps: 1.   

    (board cellAt: 5) applyEffectTo: apollo in: board.

    self assert: (board indexOfCellContaining: apollo) equals: 5. 
    self assert: (board indexOfCellContaining: orion) equals: 1. 
    self assert: orion fuel equals: orion fuelCapacity.
    self assert: orion canPlay not.
]
