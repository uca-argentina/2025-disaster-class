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
GameTests >> test001IfGameIsCreatedThenAllShipsAreAtCell1 [

	| aDie aGame someDice positions aFixedCellGenerator |
	aDie := Die with: 2.
	someDice := OrderedCollection with: aDie.
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount: 20.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
					withWormholesAt: 2
		         and: 4
		         forLaps: 1
		         withDice: someDice
		         andShipsNamed: #( 'Apollo' 'Orion' ).

	positions := aGame positions.

	self assert: (positions values allSatisfy: [ :pos | pos = 1 ])

]

{ #category : 'tests' }
GameTests >> test002IfPlayTurnMovesShipOneSpaceThenIsValid [

	| someDice aGame aFixedCellGenerator positionsBefore positionsAfter |
	someDice := OrderedCollection with: (TestDie withRolls: #( 1 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 10
		         and: 18
		         forLaps: 1
		         withDice: someDice
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
GameTests >> test003IfPlayTurnTwiceMovesSecondShipThenIsValid [

	| someDice aFixedCellGenerator game positionsAfterTurn2 |
	someDice := OrderedCollection with: (TestDie withRolls: #( 2 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	game := SpaceShipGame
		        createdWith: aFixedCellGenerator
		        withWormholesAt: 2
		        and: 4
		        forLaps: 1
		        withDice: someDice
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
GameTests >> test004IfShipFallsIntoWormholeThenIsTransportedToOtherEndThenIsValid [

	| someDice aFixedCellGenerator aGame positionsAfter |
	someDice := OrderedCollection with: (TestDie withRolls: #( 1 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 2
		         and: 4
		         forLaps: 1
		         withDice: someDice
		         andShipsNamed: #( 'Apollo' ).

	aGame playTurn.

	positionsAfter := aGame positions.

	self assert: (positionsAfter at: 'Apollo') equals: 4
]

{ #category : 'tests' }
GameTests >> test005IfRollDiceMovesShipAccordinglyThenIsValid [

	| someDice aFixedCellGenerator aGame positionsBefore positionsAfter |
	someDice := OrderedCollection with: (TestDie withRolls: #( 3 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 10
		         and: 18
		         forLaps: 1
		         withDice: (someDice)
		         andShipsNamed: #( 'Apollo' ).

	positionsBefore := aGame positions.

	self assert: (positionsBefore at: 'Apollo') equals: 1.

	aGame playTurn.

	positionsAfter := aGame positions.

	self assert: (positionsAfter at: 'Apollo') equals: 4
]

{ #category : 'tests' }
GameTests >> test006GameIsOverWhenShipCompletesTheRequiredLaps [

	| someDice aFixedCellGenerator aGame |
	someDice := OrderedCollection with: (TestDie withRolls: #( 20 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 10
		         and: 18
		         forLaps: 1
		         withDice: someDice
		         andShipsNamed: #( 'Apollo' ).

	self deny: aGame isOver.

	aGame playTurn.

	self assert: aGame isOver
]

{ #category : 'tests' }
GameTests >> test007IfShipReachesLastCellAndBecomesWinnerThenIsValid [


	| someDice aFixedCellGenerator game |
	someDice := OrderedCollection with: (TestDie withRolls: #( 20 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	game := SpaceShipGame
		        createdWith: aFixedCellGenerator
		        withWormholesAt: 10
		        and: 18
		        forLaps: 1
		        withDice: someDice
		        andShipsNamed: #( 'Apollo' ).


	self assert: game winner isNil.

	game playTurn.


	self assert: game winner name equals: 'Apollo'

]

{ #category : 'tests' }
GameTests >> test008GameIsOverWhenThereIsAWinner [


	| someDice aFixedCellGenerator game |
	someDice := OrderedCollection with: (TestDie withRolls: #( 20 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.
	game := SpaceShipGame
		        createdWith: aFixedCellGenerator
		        withWormholesAt: 10
		        and: 18
		        forLaps: 1
		        withDice: someDice
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

	aGenerator := CellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := SpaceShipGame
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 10
		         and: 18
		         forLaps: 1
		         withDice: (OrderedCollection with: aDie)
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

{ #category : 'tests' }
GameTests >> test015IfYouCanPlayWithMultipleDieConsecutivelyThenIsValid [

	| aDie1 aDie2 someDice aGenerator aGame somePositions aShip |
	aDie1 := TestDie withRolls: #( 6 4 ).
	aDie2 := TestDie withRolls: #( 5 5 ).
	someDice := OrderedCollection with: aDie1 with: aDie2.

	aGenerator := CellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := SpaceShipGame
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 10
		         and: 18
		         forLaps: 1
		         withDice: someDice
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

{ #category : 'tests' }
GameTests >> test016IfWhenGameEndsItReportsWinnerAndFinalPositionsCorrectlyThenIsValid [

	| aDie aGenerator aGame somePositions |
	aDie := TestDie withRolls: #( 20 ).

	aGenerator := CellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := SpaceShipGame
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 10
		         and: 18
		         forLaps: 1
		         withDice: (OrderedCollection with: aDie)
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
	aGenerator := CellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := SpaceShipGame
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 10
		         and: 18
		         forLaps: 1
		         withDice: (OrderedCollection with: aDie)
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
	aGenerator := CellGenerator withDistributions:
		              { ([ RegularCell new ] -> 1.0) }.

	aGame := SpaceShipGame
		         createdWith: aGenerator
		         playedOnABoardSized: 20
		         withWormholesAt: 10
		         and: 18
		         forLaps: 1
		         withDice: (OrderedCollection with: aDie)
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
	generator := CellGenerator withDistributions:
		             { ([ RegularCell new ] -> 1.0) }.

	game := SpaceShipGame
		        createdWith: generator
		        playedOnABoardSized: 10
		        withWormholesAt: 3
		        and: 7
		        forLaps: 1
		        withDice: (OrderedCollection with: die)
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
	generator := CellGenerator withDistributions:
		             { ([ RegularCell new ] -> 1.0) }.

	game := SpaceShipGame
		        createdWith: generator
		        playedOnABoardSized: 10
		        withWormholesAt: 3
		        and: 7
		        forLaps: 1
		        withDice: (OrderedCollection with: die)
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

{ #category : 'tests' }
GameTests >> test021IfPlayerSkipsTurnThenFuelIsRestoredToMax [

	| die generator game ship |
	die := TestDie withRolls: #( 3 ).
	generator := CellGenerator withDistributions:
		             { ([ RegularCell new ] -> 1.0) }.

	game := SpaceShipGame
		        createdWith: generator
		        playedOnABoardSized: 10
		        withWormholesAt: 2
		        and: 4
		        forLaps: 1
		        withDice: (OrderedCollection with: die)
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

	generator := CellGenerator withDistributions:
		             { ([ RegularCell new ] -> 1.0) }.

	game := SpaceShipGame
		        createdWith: generator
		        playedOnABoardSized: 5
		        withWormholesAt: 2
		        and: 4
		        forLaps: 3
		        withDice: (OrderedCollection with: die)
		        andShipsNamed: #( 'Apollo' 'Orion' ).

	self assert: game board size equals: 5
]

{ #category : 'tests' }
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

{ #category : 'tests' }
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

{ #category : 'tests' }
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

{ #category : 'tests' }
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

{ #category : 'tests' }
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

{ #category : 'tests' }
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

{ #category : 'tests' }
GameTests >> test029MoonWalkCellMovesAllOtherShipsBackwardsAndConsumesFuel [
    | apollo orion board moonWalkCell cells initialFuelApollo initialFuelOrion |

    apollo := Ship withName: 'Apollo' and: 10.
    orion := Ship withName: 'Orion' and: 10.

    moonWalkCell := MoonWalkCell withSteps: 2.

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
    self assert: (board indexOfCellContaining: orion) equals: 4.

    self assert: apollo fuel equals: initialFuelApollo.
    self assert: orion fuel < initialFuelOrion.
]

{ #category : 'tests' }
GameTests >> test030MoonWalkCellMovesOthersBackwardsByCustomAmountAndPenalizesIfNeeded [
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

{ #category : 'tests' }
GameTests >> test031MoonWalkCellWrapsAroundWhenMovingOthersBackwards [
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

{ #category : 'tests' }
GameTests >> test032MoonWalkCellWrapsAndPenalizesIfNotEnoughFuel [
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

{ #category : 'tests' }
GameTests >> test033HyperJumpCellAdvancesShipByParsecAmount [
    | ship board hyperCell cells parsecList initialFuel |

    ship := Ship withName: 'Apollo' and: 10.

    parsecList := #(20 10). 
    hyperCell := HyperJumpCell withParsecList: parsecList totalParsecs: 100.

    cells := (1 to: 10) collect: [:i | RegularCell new].
    cells at: 4 put: hyperCell.

    board := Board withCells: cells andShips: { ship } asOrderedCollection.
    board placeAllShipsAtStart: { ship } asOrderedCollection.

    board moveShip: ship steps: 3. 
    initialFuel := ship fuel.

    (board cellAt: 4) applyEffectTo: ship in: board.

    self assert: (board indexOfCellContaining: ship) equals: 6.  
    self assert: ship fuel < initialFuel.
]

{ #category : 'tests' }
GameTests >> test034HyperJumpCellCyclesThroughParsecList [
    | apollo orion board hyperCell cells parsecList |

    apollo := Ship withName: 'Apollo' and: 10.
    orion := Ship withName: 'Orion' and: 10.

    parsecList := #(20 10). 
    hyperCell := HyperJumpCell withParsecList: parsecList totalParsecs: 100.

    cells := (1 to: 10) collect: [:i | RegularCell new].
    cells at: 4 put: hyperCell.

    board := Board withCells: cells andShips: { apollo. orion } asOrderedCollection.
    board placeAllShipsAtStart: { apollo. orion } asOrderedCollection.

    board moveShip: apollo steps: 3.  
    (board cellAt: 4) applyEffectTo: apollo in: board.

    board moveShip: orion steps: 3.  
    (board cellAt: 4) applyEffectTo: orion in: board.

    self assert: (board indexOfCellContaining: apollo) equals: 6.  
    self assert: (board indexOfCellContaining: orion) equals: 5.  
]

{ #category : 'tests' }
GameTests >> test035HyperJumpCellResetsTheParsecListAfterAllParsecValuesUsed [
    | ship1 ship2 ship3 board hyperCell cells parsecList |

    ship1 := Ship withName: 'Apollo' and: 10.
    ship2 := Ship withName: 'Orion' and: 10.
    ship3 := Ship withName: 'Artemis' and: 10.

    parsecList := #(20 10).  
    hyperCell := HyperJumpCell withParsecList: parsecList totalParsecs: 100.

    cells := (1 to: 10) collect: [:i | RegularCell new].
    cells at: 3 put: hyperCell.

    board := Board withCells: cells andShips: { ship1. ship2. ship3 } asOrderedCollection.
    board placeAllShipsAtStart: { ship1. ship2. ship3 } asOrderedCollection.

    
    board moveShip: ship1 steps: 2.  
    (board cellAt: 3) applyEffectTo: ship1 in: board.

  
    board moveShip: ship2 steps: 2.
    (board cellAt: 3) applyEffectTo: ship2 in: board.

    
    board moveShip: ship3 steps: 2.
    (board cellAt: 3) applyEffectTo: ship3 in: board.

    self assert: (board indexOfCellContaining: ship1) equals: 5. 
    self assert: (board indexOfCellContaining: ship2) equals: 4.  
    self assert: (board indexOfCellContaining: ship3) equals: 5. 
]

{ #category : 'tests' }
GameTests >> test036HyperJumpCellGoesInCircle [
    | ship board hyperCell cells parsecList |

    ship := Ship withName: 'Apollo' and: 10.

    parsecList := #(30).
    hyperCell := HyperJumpCell withParsecList: parsecList totalParsecs: 100.

    cells := (1 to: 10) collect: [:i | RegularCell new].
    cells at: 10 put: hyperCell.

    board := Board withCells: cells andShips: { ship } asOrderedCollection.
    board placeAllShipsAtStart: { ship } asOrderedCollection.

    board moveShipDirectly: ship steps: 9.  
    (board cellAt: 10) applyEffectTo: ship in: board.

    self assert: (board indexOfCellContaining: ship) equals: 3. 
]

{ #category : 'tests' }
GameTests >> test037HyperJumpCellPenalizesShipIfNotEnoughFuel [
    | ship board hyperCell cells parsecList |

   
    ship := Ship withName: 'Apollo' and: 2.

    parsecList := #(30). 
    hyperCell := HyperJumpCell withParsecList: parsecList totalParsecs: 100.

    cells := (1 to: 10) collect: [:i | RegularCell new].
    cells at: 5 put: hyperCell.

    board := Board withCells: cells andShips: { ship } asOrderedCollection.
    board placeAllShipsAtStart: { ship } asOrderedCollection.

    board moveShip: ship steps: 4. 
    (board cellAt: 5) applyEffectTo: ship in: board.

    self assert: (board indexOfCellContaining: ship) equals: 1. 
    self assert: ship fuel equals: ship fuelCapacity. 
    self assert: ship canPlay not.  
]

{ #category : 'tests' }
GameTests >> test038HyperGravityBlocksShipIfRollTooLow [

	| ship board gravityCell cells die game maxRoll |
	ship := Ship withName: 'Apollo' and: 10.
	die := TestDie withRolls: #( 3 ). 
	maxRoll := 6. 

	gravityCell := HyperGravityCell requiringMinimumRoll: maxRoll.

	cells := (1 to: 10) collect: [ :i | RegularCell new ].
	cells at: 5 put: gravityCell. 

	board := Board
		         withCells: cells
		         andShips: { ship } asOrderedCollection.
	board placeAllShipsAtStart: { ship } asOrderedCollection.

	game := SpaceShipGame new.
	game instVarNamed: 'board' put: board.
	game instVarNamed: 'dice' put: { die } asOrderedCollection.
	game instVarNamed: 'ships' put: { ship } asOrderedCollection.
	game instVarNamed: 'shipTurnIndex' put: 1.
	game instVarNamed: 'numberOfLaps' put: 1.

	board moveShip: ship steps: 4.

	(board cellAt: 5) applyEffectTo: ship in: board withRoll: 3.

	self assert: (board indexOfCellContaining: ship) equals: 5
]

{ #category : 'tests' }
GameTests >> test039HyperGravityLetsShipAdvanceIfRollIsSufficient [
    | ship board gravityCell cells die game maxRoll |

    ship := Ship withName: 'Apollo' and: 10.
    die := TestDie withRolls: #(6).  
    maxRoll := 6.

    gravityCell := HyperGravityCell requiringMinimumRoll: maxRoll.

    cells := (1 to: 10) collect: [:i | RegularCell new ].
    cells at: 5 put: gravityCell.

    board := Board withCells: cells andShips: { ship } asOrderedCollection.
    board placeAllShipsAtStart: { ship } asOrderedCollection.

    game := SpaceShipGame new.
    game instVarNamed: 'board' put: board.
    game instVarNamed: 'dice' put: { die } asOrderedCollection.
    game instVarNamed: 'ships' put: { ship } asOrderedCollection.
    game instVarNamed: 'shipTurnIndex' put: 1.
    game instVarNamed: 'numberOfLaps' put: 1.

    board moveShip: ship steps: 4.  

    (board cellAt: 5) applyEffectTo: ship in: board withRoll: 6.

    self assert: (board indexOfCellContaining: ship) equals: 1.

]

{ #category : 'tests' }
GameTests >> test040AFullGameIsPlayedUntilItsOverAndTheresAWinner [

	| die game apollo orion generator board minRoll steps parsecList totalParsecs winner aNumberOfSides |
	aNumberOfSides := 6.

	die := Die with: aNumberOfSides.

	minRoll := 3.
	steps := 3.
	parsecList := #( 20 10 5 ).
	totalParsecs := 30.

	generator := CellGenerator withDistributions: {
        ([ RegularCell new ] -> 0.4).
        ([ BlackHoleCell new ] -> 0.2).
        ([ HyperGravityCell requiringMinimumRoll: minRoll ] -> 0.2).
        ([ MoonWalkCell withSteps: steps ] -> 0.1).
        ([ HyperJumpCell withParsecList: parsecList totalParsecs: totalParsecs ] -> 0.08).
        ([ AtomicBombCell new ] -> 0.02)
    }.

	game := SpaceShipGame
		        createdWith: generator
		        playedOnABoardSized: 30
		        withWormholesAt: 10
		        and: 15
		        forLaps: 1
		        withDice: (OrderedCollection with: die)
		        andShipsNamed: #( 'Apollo' 'Orion' ).

	apollo := game ships first.
	orion := game ships second.
	board := game board.


	[ game isOver ] whileFalse: [ game playTurn ].

	self assert: game isOver.

	winner := game winner.

	self assert: winner isNotNil
]
