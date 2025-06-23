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
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' 'Orion' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 2
		         and: 4
		         onABoardSized: 20
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

	positions := aGame positions.

	self assert: (positions values allSatisfy: [ :pos | pos = 1 ])
]

{ #category : 'tests' }
GameTests >> test002PlayTurnMovesShipOneSpace [

	| someDice aGame aFixedCellGenerator positionsBefore positionsAfter |
	someDice := OrderedCollection with: (CustomDie withRolls: #( 1 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' 'Orion' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 10
		         and: 18
		         onABoardSized: 20
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

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
	someDice := OrderedCollection with: (CustomDie withRolls: #( 2 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	game := SpaceShipGame
		        withShipsNamed: #( 'Apollo' 'Orion' )
		        playedWith: someDice
		        createdWith: aFixedCellGenerator
		        withWormholesAt: 2
		        and: 4
		        onABoardSized: 20
		        whichToParsecsIs: 100
		        forLaps: 1
		        withRewards: (FuelBuffReward by: 1)
		        andDeck: {  }.

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
	someDice := OrderedCollection with: (CustomDie withRolls: #( 1 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 2
		         and: 4
		         onABoardSized: 20
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

	aGame playTurn.

	positionsAfter := aGame positions.

	self assert: (positionsAfter at: 'Apollo') equals: 4
]

{ #category : 'tests' }
GameTests >> test005RollDiceMovesShipAccordingly [

	| someDice aFixedCellGenerator aGame positionsBefore positionsAfter |
	someDice := OrderedCollection with: (CustomDie withRolls: #( 3 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 10
		         and: 18
		         onABoardSized: 20
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

	positionsBefore := aGame positions.

	self assert: (positionsBefore at: 'Apollo') equals: 1.

	aGame playTurn.

	positionsAfter := aGame positions.

	self assert: (positionsAfter at: 'Apollo') equals: 4
]

{ #category : 'tests' }
GameTests >> test006GameIsOverWhenShipCompletesTheRequiredLaps [

	| someDice aFixedCellGenerator aGame |
	someDice := OrderedCollection with: (CustomDie withRolls: #( 20 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 10
		         and: 18
		         onABoardSized: 20
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

	self deny: aGame isOver.

	aGame playTurn.

	self assert: aGame isOver
]

{ #category : 'tests' }
GameTests >> test007ShipReachesLastCellAndBecomesWinner [

	| someDice aFixedCellGenerator aGame |
	someDice := OrderedCollection with: (CustomDie withRolls: #( 20 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 10
		         and: 18
		         onABoardSized: 20
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards:(FuelBuffReward by: 1)
		         andDeck: {  }.

	self assert: aGame winner isNil.

	aGame playTurn.

	self assert: aGame winner name equals: 'Apollo'
]

{ #category : 'tests' }
GameTests >> test008GameIsOverWhenThereIsAWinner [

	| someDice aFixedCellGenerator aGame |
	someDice := OrderedCollection with: (CustomDie withRolls: #( 20 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 10
		         and: 18
		         onABoardSized: 20
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

	self deny: aGame isOver.
	self assert: aGame winner isNil.

	aGame playTurn.

	self assert: aGame isOver.
	self assert: aGame winner name equals: 'Apollo'
]

{ #category : 'tests' }
GameTests >> test009NoMoreTurnsAfterGameIsOverWhenLapsCompleted [

	| someDice aFixedCellGenerator aGame aShip |
	someDice := OrderedCollection with: (CustomDie withRolls: #( 20 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 10
		         and: 18
		         onABoardSized: 20
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

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
	aDie := CustomDie withRolls: #( 6 4 ).
	anotherDie := CustomDie withRolls: #( 5 5 ).
	someDice := OrderedCollection with: aDie with: anotherDie.

	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 10
		         and: 18
		         onABoardSized: 20
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

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
	aDie := CustomDie withRolls: #( 21 ).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' 'Orion' )
		         playedWith: (OrderedCollection with: aDie)
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 10
		         and: 18
		         onABoardSized: 20
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

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
	someDice := CustomDie withRolls: #( 6 ).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount: 20.

	aGame := SpaceShipGame
		withShipsNamed: #( 'Apollo' )
		playedWith: (OrderedCollection with: someDice)
		createdWith: aFixedCellGenerator
		withWormholesAt: 3
		and: 7
		onABoardSized: 20
		whichToParsecsIs: 100
		forLaps: 1
		withRewards: (FuelBuffReward by: 1)
		andDeck: { }.

	aShip := aGame ships first.
	aShip consumeFuel: 12.

	aGame playTurn.

	self assert: (aGame positions at: 'Apollo') equals: 1

]

{ #category : 'tests' }
GameTests >> test013ShipRunsOutOfFuelThenLosesTwoTurns [

	| someDice aFixedCellGenerator aGame aShip |
	someDice := OrderedCollection with: (CustomDie withRolls: #( 6 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       20.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 18
		         and: 19
		         onABoardSized: 20
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

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
	someDie := OrderedCollection with: (CustomDie withRolls: #( 3 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       100.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' )
		         playedWith: someDie
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 98
		         and: 99
		         onABoardSized: 100
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

	aShip := aGame ships first.
	aShip consumeFuel: 5.
	aGame skipTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 7
]

{ #category : 'tests' }
GameTests >> test015AtomicBombCellMovesAllShipsToStart [

	| someDie aFixedCellGenerator aGame someCells |
	someDie := OrderedCollection with: (CustomDie withRolls: #( 3 3 1000 )).
	someCells := (1 to: 100) collect: [ :i | RegularCell new ].
	someCells at: 7 put: AtomicBombCell new.
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' )
		         playedWith: someDie
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 98
		         and: 99
		         onABoardSized: 100
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: {  }
		         andDeck: {  }.

	aGame playTurn.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 1
]

{ #category : 'tests' }
GameTests >> test016AtomicBombCellMovesAllShipsToStart [

	| someDie aFixedCellGenerator aGame someCells |
	someDie := OrderedCollection with: (CustomDie withRolls: #( 9 19 15 )).
	someCells := (1 to: 100) collect: [ :i | RegularCell new ].
	someCells at: 25 put: AtomicBombCell new.
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' 'Orion' )
		         playedWith: someDie
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 98
		         and: 99
		         onABoardSized: 100
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

	aGame playTurn.
	aGame playTurn.

	self assert: (aGame positions at: 'Apollo') equals: 10.
	self assert: (aGame positions at: 'Orion') equals: 20.

	aGame playTurn.

	self assert: (aGame positions at: 'Apollo') equals: 1.
	self assert: (aGame positions at: 'Orion') equals: 1
]

{ #category : 'tests' }
GameTests >> test017AtomicBombCellDoesNotResetLaps [

	| someDie anAtomicBombCell someCells aFixedCellGenerator aGame |
	someDie := OrderedCollection with:
		           (CustomDie withRolls: #( 10 14 1 10 )).
	anAtomicBombCell := AtomicBombCell new.
	someCells := (1 to: 10) collect: [ :i | RegularCell new ].
	someCells at: 2 put: anAtomicBombCell.
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' 'Orion' )
		         playedWith: someDie
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 8
		         and: 9
		         onABoardSized: 10
		         whichToParsecsIs: 100
		         forLaps: 2
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

	aGame playTurn.
	aGame playTurn.

	self assert: (aGame positions at: 'Apollo') equals: 1.
	self assert: (aGame positions at: 'Orion') equals: 5.

	aGame playTurn.

	self assert: (aGame positions at: 'Apollo') equals: 1.
	self assert: (aGame positions at: 'Orion') equals: 1.

	aGame playTurn.
	self assert: aGame winner name equals: 'Orion'
]

{ #category : 'tests' }
GameTests >> test018BlackHoleCellMovesShipBackwardsAndConsumesFuel [

	| someDie blackHoleCell someCells aFixedCellGenerator aGame |
	someDie := OrderedCollection with: (CustomDie withRolls: #( 4 5)).
	blackHoleCell := BlackHoleCell new.
	someCells := (1 to: 100) collect: [ :i | RegularCell new ].
	someCells at: 10 put: blackHoleCell.
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		withShipsNamed: #( 'Apollo' )
		playedWith: someDie
		createdWith: aFixedCellGenerator
		withWormholesAt: 98
		and: 99
		onABoardSized: 100
		whichToParsecsIs: 100
		forLaps: 1
		withRewards: (FuelBuffReward by: 1)
		andDeck: { }.

	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 5.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 1.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 1

]

{ #category : 'tests' }
GameTests >> test019BlackHoleCellWrapsAroundWhenMovingBackwards [

	| someDie blackHoleCell someCells aFixedCellGenerator aGame |
	someDie := OrderedCollection with: (CustomDie withRolls: #( 21 )).
	blackHoleCell := BlackHoleCell new.
	someCells := (1 to: 20) collect: [ :i | RegularCell new ].
	someCells at: 2 put: blackHoleCell.
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' )
		         playedWith: someDie
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 10
		         and: 11
		         onABoardSized: 20
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 18
]

{ #category : 'tests' }
GameTests >> test020BlackHoleCellPenalizesIfNotEnoughFuelBeforeGoingBackALap [

	| someDice someCells aFixedCellGenerator aGame |
	someDice := OrderedCollection with:
		            (CustomDie withRolls: #( 9 10 1 1 1 )).
	someCells := (1 to: 18) collect: [ :i | RegularCell new ].
	someCells at: 2 put: BlackHoleCell new.
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 12
		         and: 13
		         onABoardSized: 18
		         whichToParsecsIs: 100
		         forLaps: 2
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

	aGame playTurn.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 1.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 1.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 1.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 16
]

{ #category : 'tests' }
GameTests >> test021MoonWalkCellMovesAllOtherShipsBackwardsAndConsumesFuel [

	| someDice someCells aFixedCellGenerator aGame |
	someDice := OrderedCollection with:
		            (CustomDie withRolls: #( 5 5 5 0 4 5 )).
	someCells := (1 to: 100) collect: [ :i | RegularCell new ].
	someCells at: 11 put: (MoonWalkCell withSteps: 4).
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         withShipsNamed:
		         #( 'Apollo' 'Orion' 'Helado de menta granizada' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 98
		         and: 99
		         onABoardSized: 100
		         whichToParsecsIs: 100
		         forLaps: 2
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	self
		assert: (aGame positions at: 'Helado de menta granizada')
		equals: 11.
	self assert: (aGame positions at: 'Apollo') equals: 2.
	self assert: (aGame positions at: 'Orion') equals: 1
]

{ #category : 'tests' }
GameTests >> test022MoonWalkCellWrapsAroundWhenMovingOthersBackwards [

	| someDice someCells aFixedCellGenerator aGame |
	someDice := OrderedCollection with:
		            (CustomDie withRolls: #( 8 5 13 5 )).
	someCells := (1 to: 20) collect: [ :i | RegularCell new ].
	someCells at: 11 put: (MoonWalkCell withSteps: 4).
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Pancho' 'Hernan' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 8
		         and: 19
		         onABoardSized: 20
		         whichToParsecsIs: 100
		         forLaps: 2
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

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
	someDice := OrderedCollection with: (CustomDie withRolls: #( 1 1 5 )).
	someCells := (1 to: 20) collect: [ :i | RegularCell new ].
	someCells at: 2 put: (HyperGravityCell requiringMinimumRoll: 4).
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Gon' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 8
		         and: 19
		         onABoardSized: 20
		         whichToParsecsIs: 100
		         forLaps: 2
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

	aGame playTurn.
	self assert: (aGame positions at: 'Gon') equals: 2.
	aGame playTurn.
	self assert: (aGame positions at: 'Gon') equals: 2.
	aGame playTurn.
	self assert: (aGame positions at: 'Gon') equals: 7
]

{ #category : 'tests' }
GameTests >> test024HyperJumpCellAdvancesShipByParsecAmount [

	| someDice someCells aFixedCellGenerator aGame |
	someDice := OrderedCollection with:
		            (CustomDie withRolls: #( 9 10 1000000000 )).
	someCells := (1 to: 100) collect: [ :i | RegularCell new ].
	someCells at: 10 put: (HyperJumpCell withLengths: {
				 2 parsecs.
				 10 parsecs.
				 20 parsecs } asOrderedCollection).
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Gon' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 98
		         and: 99
		         onABoardSized: 100
		         whichToParsecsIs: 10
		         forLaps: 999
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

	aGame playTurn.
	self assert: (aGame positions at: 'Gon') equals: 30
]

{ #category : 'tests' }
GameTests >> test025HyperJumpCellCyclesThroughParsecList [

	| someDice someCells aFixedCellGenerator aGame |
	someDice := OrderedCollection with:
		            (CustomDie withRolls: #( 9 9 9 9 1000000000 )).
	someCells := (1 to: 100) collect: [ :i | RegularCell new ].
	someCells at: 10 put: (HyperJumpCell withLengths: {
				 2 parsecs.
				 5 parsecs.
				 7 parsecs } asOrderedCollection).
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Gon' 'Jorge' 'Fran' 'Hernan' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 98
		         and: 99
		         onABoardSized: 100
		         whichToParsecsIs: 10
		         forLaps: 999
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: (aGame positions at: 'Gon') equals: 30.
	self assert: (aGame positions at: 'Jorge') equals: 60.
	self assert: (aGame positions at: 'Fran') equals: 80.
	self assert: (aGame positions at: 'Hernan') equals: 30
]

{ #category : 'tests' }
GameTests >> test026HyperJumpCellGoesInCircle [

	| someDice someCells aFixedCellGenerator aGame |
	someDice := OrderedCollection with:
		            (CustomDie withRolls: #( 9 9 9 9 1000000000 )).
	someCells := (1 to: 100) collect: [ :i | RegularCell new ].
	someCells at: 10 put: (HyperJumpCell withLengths: {
				 2 parsecs.
				 10 parsecs.
				 20 parsecs } asOrderedCollection).
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Gon' 'Jorge' 'Fran' 'Hernan' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 98
		         and: 99
		         onABoardSized: 100
		         whichToParsecsIs: 10
		         forLaps: 999
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: (aGame positions at: 'Gon') equals: 30.
	self assert: (aGame positions at: 'Jorge') equals: 10.
	self assert: (aGame positions at: 'Fran') equals: 10.
	self assert: (aGame positions at: 'Hernan') equals: 30
]

{ #category : 'tests' }
GameTests >> test027HyperJumpCellPenalizesShipIfNotEnoughFuel [

	| someDice someCells aFixedCellGenerator aGame |
	someDice := OrderedCollection with:
		            (CustomDie withRolls: #( 9 9 9 9 )).
	someCells := (1 to: 100) collect: [ :i | RegularCell new ].
	someCells at: 10 put: (HyperJumpCell withLengths: {
				 10 parsecs.
				 15 parsecs.
				 20 parsecs } asOrderedCollection).
	aFixedCellGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Gon' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 98
		         and: 99
		         onABoardSized: 100
		         whichToParsecsIs: 10
		         forLaps: 999
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.

	aGame playTurn.
	self assert: (aGame positions at: 'Gon') equals: 1.
]

{ #category : 'tests' }
GameTests >> test028AFullGameIsPlayedUntilItsOverAndTheresAWinner [
"
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
	self assert: winner isNotNil"
]

{ #category : 'tests' }
GameTests >> test029WhenSpaceshipThrowsMaxThrowThenItsCurrentFuelItsDecrementedByOne [

	| someDice aFixedCellGenerator aGame |
	someDice := OrderedCollection with:
		            (CustomDie withRolls: #( 10 5 5 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       100.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Agus' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 8
		         and: 19
		         onABoardSized: 20
		         whichToParsecsIs: 100
		         forLaps: 2
		         withRewards: (FuelDebuffReward by: 1)
		         andDeck: {  }.


	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame positions at: 'Agus') equals: 1
]

{ #category : 'tests' }
GameTests >> test030WhenSpaceshipThrowsMaxThrowThenItsFuelCapacityItsIncrementedByOne [

	| someDice aFixedCellGenerator aGame |
	someDice := OrderedCollection with:
		            (CustomDie withRolls: #( 10 5 5 5 5 1 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       100.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Agus' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 8
		         and: 19
		         onABoardSized: 20
		         whichToParsecsIs: 100
		         forLaps: 2
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {  }.


	aGame playTurn.
	aGame skipTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame positions at: 'Agus') equals: 32
]
