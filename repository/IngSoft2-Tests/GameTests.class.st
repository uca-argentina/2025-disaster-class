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
GameTests >> test001GameIsCreatedThenAllShipsAreAtCell1 [

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
GameTests >> test002PlayTurnMovesShipOneSpace [

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
GameTests >> test003PlayTurnTwiceMovesSecondShip [

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
GameTests >> test004ShipFallsIntoWormholeThenIsTransportedToOtherEnd [

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
GameTests >> test005RollDiceMovesShipAccordingly [

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
GameTests >> test007ShipReachesLastCellAndBecomesWinner [


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


	self assert: aGame winner isNil.

	aGame playTurn.


	self assert: aGame winner name equals: 'Apollo'

]

{ #category : 'tests' }
GameTests >> test008GameIsOverWhenThereIsAWinner [


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
	self assert: aGame winner isNil.

	aGame playTurn.

	self assert: aGame isOver.
	self assert: aGame winner name equals: 'Apollo'
]

{ #category : 'tests' }
GameTests >> test009NoMoreTurnsAfterGameIsOverWhenLapsCompleted [

	| someDice aFixedCellGenerator aGame aShip |
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
	aShip := aGame ships first.

	aGame playTurn.

	self
		should: [ aGame playTurn ]
		raise: Error
		withMessageText: 'game is over!'.
	self assert: (aGame board lapsCompletedOf: aShip) equals: 1
]

{ #category : 'tests' }
GameTests >> test010CanPlayWithMultipleDieConsecutively [

	| aDie anotherDie someDice aFixedCellGenerator aGame somePositions aShip |
	aDie := TestDie withRolls: #( 6 4 ).
	anotherDie := TestDie withRolls: #( 5 5 ).
	someDice := OrderedCollection with: aDie with: anotherDie.

	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator 
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
GameTests >> test011WhenGameEndsPlayTurnDoesNothing [

	| aDie aFixedCellGenerator aGame somePositionsBeforePlayturn |
	aDie := TestDie withRolls: #( 21 ).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 10
		         and: 18
		         forLaps: 1
		         withDice: (OrderedCollection with: aDie)
		         andShipsNamed: #( 'Apollo' 'Orion' ).

	aGame playTurn.
	self assert: aGame isOver.

	somePositionsBeforePlayturn := aGame positions.
	self assert: (somePositionsBeforePlayturn at: 'Apollo') equals: 2.
	self assert: (somePositionsBeforePlayturn at: 'Orion') equals: 1.
	self
		should: [ aGame playTurn ]
		raise: Error
		withMessageText: 'game is over!'.
	self assert: somePositionsBeforePlayturn equals: aGame positions
]

{ #category : 'tests' }
GameTests >> test012ShipRunsOutOfFuelThenReturnsToFirstCell [

	| someDice aFixedCellGenerator aGame aShip |
	someDice := TestDie withRolls: #( 6 ).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 3
		         and: 7
		         forLaps: 1
		         withDice: (OrderedCollection with: someDice)
		         andShipsNamed: #( 'Apollo' ).

	aShip := aGame ships first.
	aShip consumeFuel: 12.

	aGame playTurn.

	self assert: (aGame positions at: 'Apollo') equals: 1
]

{ #category : 'tests' }
GameTests >> test013ShipRunsOutOfFuelThenLosesTwoTurns [

	| someDice aFixedCellGenerator aGame aShip |
	someDice := OrderedCollection with: (TestDie withRolls: #( 6 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 18
		         and: 19
		         forLaps: 1
		         withDice: someDice
		         andShipsNamed: #( 'Apollo' ).

	aShip := aGame ships first.
	aShip consumeFuel: 11.
	
	self assert: (aGame positions at: 'Apollo') equals: 1.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 1.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 7
]

{ #category : 'tests' }
GameTests >> test014PlayerSkipsTurnThenFuelIsRestoredToMax [

	| someDie aFixedCellGenerator aGame aShip |
	someDie := OrderedCollection with: (TestDie withRolls: #( 3 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       100.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 98
		         and: 99
		         forLaps: 1
		         withDice: someDie
		         andShipsNamed: #( 'Apollo' ).

	aShip := aGame ships first.
	aShip consumeFuel: 5.
	aGame skipTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 7
]

{ #category : 'tests' }
GameTests >> test015AtomicBombCellMovesAllShipsToStart [
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
GameTests >> test016AtomicBombCellMovesAllShipsToStart [

	| someDie aFixedCellGenerator aGame someCells anAtomicBombCell |
	someDie := OrderedCollection with: (TestDie withRolls: #( 9 19 15 )).
	anAtomicBombCell := AtomicBombCell new.
	someCells := (1 to: 100) collect: [ :i | RegularCell new ].
	someCells at: 25 put: anAtomicBombCell.
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 98
		         and: 99
		         forLaps: 1
		         withDice: someDie
		         andShipsNamed: #( 'Apollo' 'Orion' ).
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame positions at: 'Apollo') equals: 10.
	self assert: (aGame positions at: 'Orion') equals: 20.
	
	aGame playTurn.

	self assert: (aGame positions at: 'Apollo') equals: 1.
	self assert: (aGame positions at: 'Orion') equals: 1.
]

{ #category : 'tests' }
GameTests >> test017AtomicBombCellDoesNotResetLaps [

	| someDie anAtomicBombCell someCells aFixedCellGenerator aGame |
	someDie := OrderedCollection with:
		           (TestDie withRolls: #( 10 14 1 10 )).
	anAtomicBombCell := AtomicBombCell new.
	someCells := (1 to: 10) collect: [ :i | RegularCell new ].
	someCells at: 2 put: anAtomicBombCell.
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 8
		         and: 9
		         forLaps: 2
		         withDice: someDie
		         andShipsNamed: #( 'Apollo' 'Orion' ).


	aGame playTurn.
	aGame playTurn.

	self assert: (aGame positions at: 'Apollo') equals: 1.
	self assert: (aGame positions at: 'Orion') equals: 5.

	aGame playTurn.

	self assert: (aGame positions at: 'Apollo') equals: 1.
	self assert: (aGame positions at: 'Orion') equals: 1.

	aGame playTurn.
	self assert: (aGame winner name) equals: 'Orion'
	"si se hubieran reseteado las laps no ganaria con un 10"
]

{ #category : 'tests' }
GameTests >> test018BlackHoleCellMovesShipBackwardsAndConsumesFuel [

	| someDie blackHoleCell someCells aFixedCellGenerator aGame |
	someDie := OrderedCollection with: (TestDie withRolls: #( 4 5)).
	blackHoleCell := BlackHoleCell new.
	someCells := (1 to: 100) collect: [ :i | RegularCell new ].
	someCells at: 10 put: blackHoleCell.
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 98
		         and: 99
		         forLaps: 1
		         withDice: someDie
		         andShipsNamed: #( 'Apollo' ).

	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 5.
	aGame playTurn.
	"Cae en el Black Hole y se aplica la penalty aunque solo se movio por dado 9 pasos"
	self assert: (aGame positions at: 'Apollo') equals: 1.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 1.
]

{ #category : 'tests' }
GameTests >> test019BlackHoleCellWrapsAroundWhenMovingBackwards [

	| someDie blackHoleCell someCells aFixedCellGenerator aGame |
	someDie := OrderedCollection with: (TestDie withRolls: #( 21 )).
	blackHoleCell := BlackHoleCell new.
	someCells := (1 to: 20) collect: [ :i | RegularCell new ].
	someCells at: 2 put: blackHoleCell.
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 10
		         and: 11
		         forLaps: 1
		         withDice: someDie
		         andShipsNamed: #( 'Apollo' ).
	
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 18.
]

{ #category : 'tests' }
GameTests >> test020BlackHoleCellPenalizesIfNotEnoughFuelBeforeGoingBackALap [

	| someDice someCells aFixedCellGenerator aGame |
	someDice := OrderedCollection with: (TestDie withRolls: #( 9 10 1 1 1 )).
	someCells := (1 to: 18) collect: [ :i | RegularCell new ].
	someCells at: 2 put: (BlackHoleCell new).
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 12
		         and: 13
		         forLaps: 2
		         withDice: someDice
		         andShipsNamed: #( 'Apollo' ).

	aGame playTurn.
	aGame playTurn.
	"Cae en el Black Hole y se aplica la penalty primero antes de volver una lap"
	self assert: (aGame positions at: 'Apollo') equals: 1.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 1.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 1.
	"Pierde dos turnos"
	aGame playTurn.
	"Cae en el Blackhole, vuelve atras una lap y cae en 16"
	self assert: (aGame positions at: 'Apollo') equals: 16.
]

{ #category : 'tests' }
GameTests >> test021MoonWalkCellMovesAllOtherShipsBackwardsAndConsumesFuel [

	| someDice someCells aFixedCellGenerator aGame |
	someDice := OrderedCollection with:
		            (TestDie withRolls: #( 5 5 5 0 4 5 )).
	someCells := (1 to: 100) collect: [ :i | RegularCell new ].
	someCells at: 11 put: (MoonWalkCell withSteps: 4).
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 98
		         and: 99
		         forLaps: 2
		         withDice: someDice
		         andShipsNamed:
		         #( 'Apollo' 'Orion' 'Helado de menta granizada' ).

	"Se juega un turno"
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	"En el segundo turno Helado cae en moonWalk"
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	"Apollo vuelve 4, Orion se queda sin nafta y helado no se mueve"
	self
		assert: (aGame positions at: 'Helado de menta granizada')
		equals: 11.
	self assert: (aGame positions at: 'Apollo') equals: 2.
	self assert: (aGame positions at: 'Orion') equals: 1.
]

{ #category : 'tests' }
GameTests >> test022MoonWalkCellWrapsAroundWhenMovingOthersBackwards [

	| someDice someCells aFixedCellGenerator aGame |
	someDice := OrderedCollection with:
		            (TestDie withRolls: #( 8 5 13 5 )).
	someCells := (1 to: 20) collect: [ :i | RegularCell new ].
	someCells at: 11 put: (MoonWalkCell withSteps: 4).
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 8
		         and: 19
		         forLaps: 2
		         withDice: someDice
		         andShipsNamed: #( 'Pancho' 'Hernan' ).

	aGame playTurn.
	self assert: (aGame positions at: 'Pancho') equals: 9.
	aGame playTurn.
	self assert: (aGame positions at: 'Hernan') equals: 6.
	aGame playTurn.
	self assert: (aGame positions at: 'Pancho') equals: 2.
	aGame playTurn.
	self assert: (aGame positions at: 'Hernan') equals: 11.
	self assert: (aGame positions at: 'Pancho') equals: 18
]

{ #category : 'tests' }
GameTests >> test023HyperGravityBlocksShipIfRolllsBelowThreshold [

	| someDice someCells aFixedCellGenerator aGame |
	someDice := OrderedCollection with: (TestDie withRolls: #( 1 1 5 )).
	someCells := (1 to: 20) collect: [ :i | RegularCell new ].
	someCells at: 2 put: (HyperGravityCell requiringMinimumRoll: 4).
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 8
		         and: 19
		         forLaps: 2
		         withDice: someDice
		         andShipsNamed: #( 'Gon' ).

	"Falls in hyperGravity"
	aGame playTurn.
	self assert: (aGame positions at: 'Gon') equals: 2.
	"Juega y se queda en el mismo lugar"
	aGame playTurn.
	self assert: (aGame positions at: 'Gon') equals: 2.
	"Juega y se puede mover porque tiro mas alto que 4"
	aGame playTurn.
	self assert: (aGame positions at: 'Gon') equals: 7
]

{ #category : 'tests' }
GameTests >> test033HyperJumpCellAdvancesShipByParsecAmount [

	

	"| ship board hyperCell cells parsecList initialFuel |
	ship := Ship withName: 'Apollo' and: 10.

	parsecList := #( 20 10 ).
	hyperCell := HyperJumpCell
		             withParsecList: parsecList
		             totalParsecs: 100.

	cells := (1 to: 10) collect: [ :i | RegularCell new ].
	cells at: 4 put: hyperCell.

	board := Board
		         withCells: cells
		         andShips: { ship } asOrderedCollection.
	board placeAllShipsAtStart: { ship } asOrderedCollection.

	board moveShip: ship steps: 3.
	initialFuel := ship currentFuel.

	(board cellAt: 4) applyEffectTo: ship in: board.

	self assert: (board indexOfCellContaining: ship) equals: 6.
	self assert: ship currentFuel < initialFuel"
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
    self assert: ship currentFuel equals: ship fuelCapacity. 
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
GameTests >> test040AFullGameIsPlayedUntilItsOverAndTheresAWinner [

	| someDice game winner aNumberOfSides |
	aNumberOfSides := 6.

	someDice := OrderedCollection with: (Die with: aNumberOfSides).

	game := SpaceShipGame
		        onABoardSized: 30
		        withWormholesAt: 10
		        and: 15
		        forLaps: 1
		        withDice: someDice
		        andShipsNamed: #( 'Apollo' 'Orion' ).


	[ game isOver ] whileFalse: [ game playTurn ].
	winner := game winner.

	self assert: game isOver.
	self assert: winner isNotNil
]
