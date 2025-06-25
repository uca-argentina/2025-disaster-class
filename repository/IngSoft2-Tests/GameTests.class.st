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
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
		         andDeck: {  NullCard new. NullCard new. }.

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
		        andDeck: {
				        NullCard new.
				        NullCard new }.

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
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
		         withRewards: (FuelBuffReward by: 1)
		         andDeck: {
				         NullCard new.
				         NullCard new }.


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
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
		         andDeck: {
				         NullCard new.
				         NullCard new }.

	aShip := aGame ships first.

	aGame playTurn.

	self
		should: [ aGame playTurn ]
		raise: Error
		withMessageText: 'game is over!'.
]

{ #category : 'tests' }
GameTests >> test010CanPlayWithMultipleDieConsecutively [

	| aDie anotherDie someDice aFixedCellGenerator aGame somePositions |
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
		         andDeck: {
				         NullCard new.
				         NullCard new }.

	aGame playTurn.
	self deny: aGame isOver.

	somePositions := aGame positions.
	self assert: (somePositions at: 'Apollo') equals: 12.

	aGame playTurn.
	self assert: aGame isOver.

	somePositions := aGame positions.
	self assert: (somePositions at: 'Apollo') equals: 1
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
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       100.

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
		         andDeck: {
				         NullCard new.
				         NullCard new }.

	aShip := aGame ships first.

	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame positions at: 'Apollo') equals: 1
]

{ #category : 'tests' }
GameTests >> test013ShipRunsOutOfFuelThenLosesTwoTurns [

	| someDice aFixedCellGenerator aGame aShip |
	someDice := OrderedCollection with: (CustomDie withRolls: #( 6 5 6 6 6 6 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       100.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 98
		         and: 99
		         onABoardSized: 100
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

	aShip := aGame ships first.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 1.
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
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

	aShip := aGame ships first.
	aGame playTurn.
	aGame playTurn.
	aGame skipTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 13
]

{ #category : 'tests' }
GameTests >> test015AtomicBombCellMovesAllShipsToStart [

	| someDie aFixedCellGenerator aGame someCells |
	someDie := OrderedCollection with:
		           (CustomDie withRolls: #( 3 3 1000 )).
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
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

	aGame playTurn.
	aGame playTurn.
	self assert: (aGame positions at: 'Apollo') equals: 1
]

{ #category : 'tests' }
GameTests >> test016AtomicBombCellMovesAllShipsToStart [

	| someDie aFixedCellGenerator aGame someCells |
	someDie := OrderedCollection with:
		           (CustomDie withRolls: #( 9 19 15 )).
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
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
	someDie := OrderedCollection with: (CustomDie withRolls: #( 4 5 )).
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
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

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
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

	aGame playTurn.
	self assert: (aGame positions at: 'Gon') equals: 1
]

{ #category : 'tests' }
GameTests >> test028AFullGameIsPlayedUntilItsOverAndTheresAWinner [

	| someDice game winner |

	someDice := OrderedCollection with: (Die with: 6).

	game := SpaceShipGame
		        withShipsNamed: #( 'Apollo' 'Orion' )
		        playedWith: someDice
		        onABoardSized: 30
		        whichToParsecsIs: 3
		        forLaps: 10
		        withWormholesAt: 10
		        and: 15.


	[ game isOver ] whileFalse: [ game playTurn ].
	winner := game winner.

	self assert: game isOver.
	self assert: winner isNotNil
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
		         andDeck: {
				         NullCard new.
				         NullCard new }.


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
		         andDeck: {
				         NullCard new.
				         NullCard new }.


	aGame playTurn.
	aGame skipTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame positions at: 'Agus') equals: 32
]

{ #category : 'tests' }
GameTests >> test031HyperJumpCellAdvancesShipByLightyearsAmount [

	| someDice someCells aFixedCellGenerator aGame |
	someDice := OrderedCollection with:
		            (CustomDie withRolls: #( 9 10 1000000000 )).
	someCells := (1 to: 100) collect: [ :i | RegularCell new ].
	someCells at: 10 put: (HyperJumpCell withLengths: {
				 6 lightYears.
				 30 lightYears.
				 60 lightYears } asOrderedCollection).
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
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

	aGame playTurn.
	self assert: (aGame positions at: 'Gon') equals: 30
]

{ #category : 'tests' }
GameTests >> test032CardGivingCellGivesOneMoreCardToAShip [

	| someDice someCells aFixedCellGenerator aGame aShip |
	someDice := OrderedCollection with:
		            (CustomDie withRolls: #( 9 10 1000000000 )).
	someCells := (1 to: 100) collect: [ :i | RegularCell new ].
	someCells at: 10 put: CardCell new.
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
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

	aShip := aGame ships first.
	self assert: (aGame deckOf: 'Gon') size equals: 2.
	aGame playTurn.
	self assert: (aGame deckOf: 'Gon') size equals: 3
]

{ #category : 'tests' }
GameTests >> test033WhenGameFinishesGivesTheRankingOfTheSpaceships [

	| someDice aFixedCellGenerator aGame |
	someDice := OrderedCollection with:
		            (CustomDie withRolls: #( 15 12 10 10 16 7 5 50 )).
	aFixedCellGenerator := FixedCellGenerator withAllRegularCellAmount:
		                       15.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Max' 'Tom' 'Franco' )
		         playedWith: someDice
		         createdWith: aFixedCellGenerator
		         withWormholesAt: 5
		         and: 6
		         onABoardSized: 15
		         whichToParsecsIs: 15
		         forLaps: 2
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	self
		assert: aGame rankings
		equals: #( 'Max' 'Tom' 'Franco' ) asOrderedCollection
]

{ #category : 'tests' }
GameTests >> test034ErrorWhenBoardSizeIsZeroOrNegative [

	self
		should: [
			SpaceShipGame
				withShipsNamed: #( 'Apollo' 'Orion' )
				playedWith: (OrderedCollection with: (Die with: 6))
				onABoardSized: 0
				whichToParsecsIs: 3
				forLaps: 10
				withWormholesAt: 10
				and: 15 ]
		raise: Error
		withMessageText: 'Board size must be positive'
]

{ #category : 'tests' }
GameTests >> test035ErrorWhenLapCountIsZeroOrNegative [

	self
		should: [
			SpaceShipGame
				withShipsNamed: #( 'Apollo' 'Orion' )
				playedWith: (OrderedCollection with: (Die with: 6))
				onABoardSized: 20
				whichToParsecsIs: 3
				forLaps: 0
				withWormholesAt: 10
				and: 15 ]
		raise: Error
		withMessageText: 'The lap count must be positive'

]

{ #category : 'tests' }
GameTests >> test036ErrorWhenLengthInParsecsIsZeroOrNegative [

	self
		should: [
			SpaceShipGame
				withShipsNamed: #( 'Apollo' 'Orion' )
				playedWith: (OrderedCollection with: (Die with: 6))
				onABoardSized: 20
				whichToParsecsIs: 0
				forLaps: 3
				withWormholesAt: 10
				and: 15 ]
		raise: Error
		withMessageText: 'Length in parsecs must be positive'

]

{ #category : 'tests' }
GameTests >> test037ErrorWhenWormholeStartPositionIsOutOfBounds [

	self
		should: [
			SpaceShipGame
				withShipsNamed: #( 'Apollo' 'Orion' )
				playedWith: (OrderedCollection with: (Die with: 6))
				onABoardSized: 20
				whichToParsecsIs: 3
				forLaps: 3
				withWormholesAt: 0
				and: 15 ]
		raise: Error
		withMessageText: 'Wormhole start position is out of bounds'

]

{ #category : 'tests' }
GameTests >> test038ErrorWhenWormholeEndPositionIsOutOfBounds [

	self
		should: [
			SpaceShipGame
				withShipsNamed: #( 'Apollo' 'Orion' )
				playedWith: (OrderedCollection with: (Die with: 6))
				onABoardSized: 20
				whichToParsecsIs: 3
				forLaps: 3
				withWormholesAt: 10
				and: 21 ]
		raise: Error
		withMessageText: 'Wormhole end position is out of bounds'

]

{ #category : 'tests' }
GameTests >> test039ErrorWhenShipNamesIsEmpty [

	self
		should: [
			SpaceShipGame
				withShipsNamed: #()
				playedWith: (OrderedCollection with: (Die with: 6))
				onABoardSized: 20
				whichToParsecsIs: 3
				forLaps: 3
				withWormholesAt: 10
				and: 15 ]
		raise: Error
		withMessageText: 'Must have at least one ship'

]

{ #category : 'tests' }
GameTests >> test040ErrorWhenDiceCollectionIsEmpty [

	self
		should: [
			SpaceShipGame
				withShipsNamed: #( 'Apollo' )
				playedWith: OrderedCollection new
				onABoardSized: 20
				whichToParsecsIs: 3
				forLaps: 3
				withWormholesAt: 10
				and: 15 ]
		raise: Error
		withMessageText: 'Dice collection cannot be empty'

]

{ #category : 'tests' }
GameTests >> test041UsingAccelerationIncreasesDiceAdjustmentOfAllShips [

	| die game shipA accelerationCard generator boardSize positions |
	boardSize := 10.
	die := CustomDie withRolls: #( 4 4 100 ).
	generator := FixedCellGenerator withAllRegularCellAmount: boardSize.

	game := SpaceShipGame
		        withShipsNamed: #( 'shipA' )
		        playedWith: (OrderedCollection with: die)
		        createdWith: generator
		        withWormholesAt: 1
		        and: 2
		        onABoardSized: boardSize
		        whichToParsecsIs: 100
		        forLaps: 1
		        withRewards: (FuelBuffReward by: 0)
		        andDeck: {
				        Acceleration new.
				        NullCard new }.

	shipA := game ships first.
	accelerationCard := shipA findCardOfClass: Acceleration.
	self assert: accelerationCard notNil.

	game playTurn.

	positions := game positions.
	self assert: (positions at: 'shipA') equals: 5.

	game playCard: accelerationCard from: 'shipA' to: nil.

	game playTurn.

	positions := game positions.
	self assert: (positions at: 'shipA') equals: 10
]

{ #category : 'tests' }
GameTests >> test042CancellationRemovesAccelerationEffect [

	| die game shipA accelerationCard cancellationCard generator boardSize positions |
	boardSize := 14.
	die := CustomDie withRolls: #( 4 4 4 100 ).
	generator := FixedCellGenerator withAllRegularCellAmount: boardSize.

	game := SpaceShipGame
		        withShipsNamed: #( 'shipA' )
		        playedWith: (OrderedCollection with: die)
		        createdWith: generator
		        withWormholesAt: 1
		        and: 2
		        onABoardSized: boardSize
		        whichToParsecsIs: 100
		        forLaps: 1
		        withRewards: (FuelBuffReward by: 0)
		        andDeck: {
				        Acceleration new.
				        Cancellation new }.

	shipA := game ships first.
	accelerationCard := shipA findCardOfClass: Acceleration.
	cancellationCard := shipA findCardOfClass: Cancellation.

	self assert: accelerationCard notNil.
	self assert: cancellationCard notNil.

	game playTurn.
	positions := game positions.
	self assert: (positions at: 'shipA') equals: 5.

	game playCard: accelerationCard from: 'shipA' to: nil.

	game playTurn.
	positions := game positions.
	self assert: (positions at: 'shipA') equals: 10.

	game playCard: cancellationCard from: 'shipA' to: accelerationCard.

	game playTurn.
	positions := game positions.
	self assert: (positions at: 'shipA') equals: 14
]

{ #category : 'tests' }
GameTests >> test043OverloadAffectsOnlyTargetShip [

	| die game shipA shipB overloadCard generator boardSize positions |
	boardSize := 10.
	die := CustomDie withRolls: #( 4 4 100 ).
	generator := FixedCellGenerator withAllRegularCellAmount: boardSize.

	game := SpaceShipGame
		        withShipsNamed: #( 'shipA' 'shipB' )
		        playedWith: (OrderedCollection with: die)
		        createdWith: generator
		        withWormholesAt: 1
		        and: 2
		        onABoardSized: boardSize
		        whichToParsecsIs: 100
		        forLaps: 1
		        withRewards: (FuelBuffReward by: 0)
		        andDeck: {
				        Overload new.
				        NullCard new }.

	shipA := game ships first.
	shipB := game ships second.
	overloadCard := shipA findCardOfClass: Overload.
	game playCard: overloadCard from: 'shipA' to: 'shipB'.

	game playTurn.
	game playTurn.
	positions := game positions.

	self assert: (positions at: 'shipB') equals: 3.
	self assert: (positions at: 'shipA') equals: 5
]

{ #category : 'tests' }
GameTests >> test044CancellationRemovesOverloadEffect [

	| die game ship overloadCard cancellationCard generator boardSize positions |
	boardSize := 10.
	die := CustomDie withRolls: #( 4 4 100 ).
	generator := FixedCellGenerator withAllRegularCellAmount: boardSize.

	game := SpaceShipGame
		        withShipsNamed: #( 'ship' )
		        playedWith: (OrderedCollection with: die)
		        createdWith: generator
		        withWormholesAt: 1
		        and: 2
		        onABoardSized: boardSize
		        whichToParsecsIs: 100
		        forLaps: 1
		        withRewards: (FuelBuffReward by: 0)
		        andDeck: {
				        Overload new.
				        Cancellation new }.

	ship := game ships first.
	overloadCard := ship findCardOfClass: Overload.
	cancellationCard := ship findCardOfClass: Cancellation.
	game playTurn.
	self assert: (game positions at: 'ship') equals: 5.
	game playCard: overloadCard from: 'ship' to: 'ship'.
	game playCard: cancellationCard from: 'ship' to: overloadCard.
	game playTurn.
	positions := game positions.
	self assert: (positions at: 'ship') equals: 9
]

{ #category : 'tests' }
GameTests >> test045CancellationRemovesOverloadEffectWhileGameHasTwoShipsPlaying [

	| die game shipA shipB overloadCard cancellationCard generator boardSize |
	boardSize := 10.
	die := CustomDie withRolls: #( 4 4 100 ).
	generator := FixedCellGenerator withAllRegularCellAmount: boardSize.

	game := SpaceShipGame
		        withShipsNamed: #( 'shipA' 'shipB' )
		        playedWith: (OrderedCollection with: die)
		        createdWith: generator
		        withWormholesAt: 1
		        and: 2
		        onABoardSized: boardSize
		        whichToParsecsIs: 100
		        forLaps: 1
		        withRewards: (FuelBuffReward by: 0)
		        andDeck: {
				        Overload new.
				        Cancellation new }.

	shipA := game ships first.
	shipB := game ships second.
	overloadCard := shipA findCardOfClass: Overload.
	cancellationCard := shipB findCardOfClass: Cancellation.

	game playCard: overloadCard from: 'shipA' to: 'shipB'.
	game playTurn.
	self assert: (game positions at: 'shipA') equals: 5.
	game playCard: cancellationCard from: 'shipB' to: overloadCard.
	game playTurn.
	self assert: (game positions at: 'shipB') equals: 5
]

{ #category : 'tests' }
GameTests >> test046RedoReappliesLastPermanentEffect [

	| die game ship overloadCard redoCard |
	die := CustomDie withRolls: #( 4 4 4 12 ).

	game := SpaceShipGame
		        withShipsNamed: #( 'Apollo' )
		        playedWith: (OrderedCollection with: die)
		        createdWith:
		        (FixedCellGenerator withAllRegularCellAmount: 20)
		        withWormholesAt: 2
		        and: 3
		        onABoardSized: 20
		        whichToParsecsIs: 100
		        forLaps: 1
		        withRewards: (FuelBuffReward by: 0)
		        andDeck: {
				        Overload new.
				        Redo new }.

	ship := game ships first.
	overloadCard := ship findCardOfClass: Overload.
	redoCard := ship findCardOfClass: Redo.

	game playTurn.
	self assert: (game positions at: 'Apollo') equals: 5.

	game playCard: overloadCard from: 'Apollo' to: 'Apollo'.
	game playTurn.
	self assert: (game positions at: 'Apollo') equals: 7.

	game playCard: redoCard from: 'Apollo' to: 'Apollo'.
	game playTurn.
	self assert: (game positions at: 'Apollo') equals: 7
]

{ #category : 'tests' }
GameTests >> test047ShipBorrowsFuelFromAllyWhenRunningLow [

	| dice generator game apollo orion |
	dice := OrderedCollection with:
		        (CustomDie withRolls: #( 5 2 5 2 4 6 )).
	generator := FixedCellGenerator withAllRegularCellAmount: 20.

	game := SpaceShipGame
		        withShipsNamed: #( 'Apollo' 'Orion' )
		        playedWith: dice
		        createdWith: generator
		        withWormholesAt: 8
		        and: 19
		        onABoardSized: 20
		        whichToParsecsIs: 100
		        forLaps: 1
		        withRewards: (FuelBuffReward by: 0)
		        andDeck: {
				        Ally new.
				        Overload new }.

	apollo := game findShip: 'Apollo'.
	orion := game findShip: 'Orion'.

	game
		playCard: (apollo findCardOfClass: Ally)
		from: 'Apollo'
		to: 'Orion'.
	game playTurn."A 5"
	game playTurn."O 2"
	game playTurn."A 5"
	game playTurn.	"O 2"
	game playTurn."A 4"
	
	self assert: (game positions at: 'Apollo') equals: 15.
]

{ #category : 'tests' }
GameTests >> test048WhenCancellationCardIsUsedOnAllyCardThenShipsNoLongerShareTheirFuel [

	| dice generator allyCard cancellationCard game apollo orion |
	dice := OrderedCollection with:
		        (CustomDie withRolls: #( 5 2 5 2 4 6 )).
	generator := FixedCellGenerator withAllRegularCellAmount: 20.

	game := SpaceShipGame
		        withShipsNamed: #( 'Apollo' 'Orion' )
		        playedWith: dice
		        createdWith: generator
		        withWormholesAt: 8
		        and: 19
		        onABoardSized: 20
		        whichToParsecsIs: 100
		        forLaps: 1
		        withRewards: (FuelBuffReward by: 0)
		        andDeck: {
				        Ally new.
				        Cancellation new }.

	apollo := game findShip: 'Apollo'.
	orion := game findShip: 'Orion'.

	allyCard := (game deckOf: 'Apollo') first.
	cancellationCard := (game deckOf: 'Apollo') second.

	game playCard: allyCard from: 'Apollo' to: 'Orion'.
	game playCard: cancellationCard from: 'Apollo' to: allyCard.

	game playTurn."A 5"
	game playTurn."O 2"
	game playTurn."A 5"
	game playTurn."O 2"
	game playTurn."A 4"
	


	self assert: (game positionOfShip: apollo) equals: 1
]

{ #category : 'tests' }
GameTests >> test049WhenShipsAreAlliedAndNeitherHasEnoughFuelBothArePenalized [

	| dice generator allyCard game apollo orion andromeda |
	dice := OrderedCollection with:
		        (CustomDie withRolls: #( 5 5 2 5 5 2 5 2 2 6 )).
	generator := FixedCellGenerator withAllRegularCellAmount: 13.

	game := SpaceShipGame
		        withShipsNamed: #( 'Apollo' 'Orion' 'Andromeda')
		        playedWith: dice
		        createdWith: generator
		        withWormholesAt: 2
		        and: 8
		        onABoardSized: 13
		        whichToParsecsIs: 100
		        forLaps: 1
		        withRewards: (FuelBuffReward by: 0)
		        andDeck: {
				        Ally new.
				        Cancellation new }.

	apollo := game findShip: 'Apollo'.
	orion := game findShip: 'Orion'.
	andromeda := game findShip: 'Andromeda'.


	allyCard := (game deckOf: 'Apollo') first.
	game playCard: allyCard from: 'Apollo' to: 'Orion'.

	game playTurn. "A 5 pos 6 fuel 7"
	game playTurn. "O 5 pos 6 fuel 7"
	game playTurn. "C 2 pos 3 fuel 10"
	game playTurn. "A 5 pos 11 fuel 2"
	game playTurn. "O 5 pos 11 fuel 2"
	game playTurn. "C 2 pos 5 fuel 8"
	game playTurn. "A 5 pos 4 not enough"	
	game playTurn. "O 2 pos 1 llega?"
	game playTurn. "C 2 pos 7 fuel 6"



	self assert: (game positionOfShip: apollo) equals: 1.
	self assert: (game positionOfShip: orion) equals: 1.
	self assert: (game positionOfShip: andromeda) equals: 7.

]

{ #category : 'tests' }
GameTests >> test050WhenShipFallsOnBlackHoleCellAndARepeatCardIsUsedThenBlackHoleEffectIsAppliedToTheTargetedShip [

	| dice generator aGame apollo orion repeat |
	dice := OrderedCollection with: (CustomDie withRolls: #( 9 6 15 )).
	generator := generator := FixedCellGenerator cells:
		                          ((1 to: 15) collect: [ :i |
			                           i = 10
				                           ifTrue: [ BlackHoleCell new ]
				                           ifFalse: [ RegularCell new ] ]).



	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' 'Orion' )
		         playedWith: dice
		         createdWith: generator
		         withWormholesAt: 5
		         and: 6
		         onABoardSized: 15
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         Repeat new.
				         Repeat new }.

	apollo := aGame findShip: 'Apollo'.
	orion := aGame findShip: 'Orion'.
	repeat := (aGame deckOf: 'Orion') first.
	aGame playTurn.
	aGame playCard: repeat from: 'Orion' to: 'Apollo'.
	aGame playTurn.

	self assert: (aGame positionOfShip: apollo) equals: 2. "6"
	self assert: (aGame positionOfShip: orion) equals: 7 "6"
]

{ #category : 'tests' }
GameTests >> test051WhenRedoCardIsPlayedTwiceTheEffectIsAppliedTwice [

	| dice generator aGame apollo orion overload redo redo2 apollo1 orion1 |
    dice := OrderedCollection with: (CustomDie withRolls: #( 5 5 6 7 2 10 )).
    generator := generator := FixedCellGenerator
                                  withAllRegularCellAmount: 20.



    aGame := SpaceShipGame
                 withShipsNamed: #( 'Apollo' 'Orion' )
                 playedWith: dice
                 createdWith: generator
                 withWormholesAt: 2
                 and: 3
                 onABoardSized: 20
                 whichToParsecsIs: 100
                 forLaps: 1
                 withRewards: (FuelBuffReward by: 0)
                 andDeck: {
                         Overload new.
                         Redo new }.

    apollo := 'Apollo'.
    orion := 'Orion'.
    apollo1 := aGame findShip: 'Apollo'.
    orion1 := aGame findShip: 'Orion'.
    overload := (aGame deckOf: apollo) first.
    redo := (aGame deckOf: apollo) second.
    redo2 := (aGame deckOf: orion) second.



    aGame playTurn.
    aGame playTurn.

    aGame playCard: overload from: apollo to: orion.
    aGame playCard: redo from: apollo to: orion.
    aGame playTurn.
    aGame playCard: redo2 from: orion to: apollo.
    aGame playTurn.
    aGame playTurn.

    self assert: (aGame positions at: apollo) equals: 12.
    self assert: (aGame positions at: orion) equals: 9
]

{ #category : 'tests' }
GameTests >> test052CancellationCardCanBeUsedBeforeTurnAndCanceltsEffect [

	| someDice aGenerator aGame overloadCard cancellationCard aShip anotherShip |
	someDice := OrderedCollection with: (CustomDie withRolls: #( 9 7 3 )).
	aGenerator := FixedCellGenerator withAllRegularCellAmount: 11.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' 'Orion' )
		         playedWith: someDice
		         createdWith: aGenerator
		         withWormholesAt: 1
		         and: 2
		         onABoardSized: 11
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         Overload new.
				         Cancellation new }.

	aShip := 'Apollo'.
	anotherShip := 'Orion'.

	overloadCard := (aGame deckOf: aShip) first.
	cancellationCard := (aGame deckOf: anotherShip) second.

	aGame playCard: overloadCard from: aShip to: anotherShip.
	aGame playCard: cancellationCard from: anotherShip to: overloadCard.

	aGame playTurn.
	aGame playTurn.

	self assert: (aGame positions at: aShip) equals: 10.
	self assert: (aGame positions at: anotherShip) equals: 8
]

{ #category : 'tests' }
GameTests >> test053ShipsRecieveTwoRandomCardsAtTheBeginningOfTheGame [

	| someDice aGenerator aGame |
	someDice := OrderedCollection with: (CustomDie withRolls: #( 1 )).
	aGenerator := FixedCellGenerator withAllRegularCellAmount: 11.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' 'Orion' )
		         playedWith: someDice
		         onABoardSized: 11
		         whichToParsecsIs: 100
		         forLaps: 1
		         withWormholesAt: 1
		         and: 2.

	self assert: (aGame deckOf: 'Apollo') size equals: 2.
	self assert: (aGame deckOf: 'Orion') size equals: 2
]

{ #category : 'tests' }
GameTests >> test054CancellationCardCannotBeUsedIfTargetCardWasNotPlayed [

	| someDice aGenerator aGame aShip anotherShip overloadCard cancellationCard |
	someDice := OrderedCollection with: (CustomDie withRolls: #( 9 7 2 3 10 )).
	aGenerator := FixedCellGenerator withAllRegularCellAmount: 15.

	aGame := SpaceShipGame
		withShipsNamed: #( 'Apollo' 'Orion' )
		playedWith: someDice
		createdWith: aGenerator
		withWormholesAt: 1
		and: 2
		onABoardSized: 15
		whichToParsecsIs: 100
		forLaps: 1
		withRewards: (FuelBuffReward by: 0)
		andDeck: {
			Overload new.
			Cancellation new }.

	aShip := 'Apollo'.
	anotherShip := 'Orion'.

	aGame playTurn.

	cancellationCard := (aGame deckOf: anotherShip) second.
	overloadCard := (aGame deckOf: aShip) first.

	self
		should: [
			aGame
				playCard: cancellationCard
				from: anotherShip
				to: overloadCard ]
		raise: Error
		withMessageText: 'There is no such active card'
]

{ #category : 'tests' }
GameTests >> test055ErrorWhenAskedForAWinnerAndThereIsNone [

	| someDice aGenerator aGame aShip someShips |
	aShip := 'Apollo'.
	someShips := OrderedCollection with: aShip.
	someDice := OrderedCollection with: (CustomDie withRolls: #( 4 )).
	aGenerator := FixedCellGenerator withAllRegularCellAmount: 15.

	aGame := SpaceShipGame
		withShipsNamed: someShips
		playedWith: someDice
		createdWith: aGenerator
		withWormholesAt: 1
		and: 2
		onABoardSized: 15
		whichToParsecsIs: 100
		forLaps: 2
		withRewards: (FuelBuffReward by: 0)
		andDeck: {
			NullCard new.
			NullCard new }.

	self
		should: [ aGame winner ]
		raise: Error
		withMessageText: 'There is no winner yet'

]

{ #category : 'tests' }
GameTests >> test056ErrorWhenPlayerWantsToPlayOverloadCardWhenItsNotHisTurn [

	| someDice aGenerator aGame aShip anotherShip |
	someDice := OrderedCollection with: (CustomDie withRolls: #( 9 7 3 )).
	aGenerator := FixedCellGenerator withAllRegularCellAmount: 11.

	aGame := SpaceShipGame
		withShipsNamed: #( 'Apollo' 'Orion' )
		playedWith: someDice
		createdWith: aGenerator
		withWormholesAt: 1
		and: 2
		onABoardSized: 11
		whichToParsecsIs: 100
		forLaps: 1
		withRewards: (FuelBuffReward by: 0)
		andDeck: {
			Overload new.
			Ally new.
			Acceleration new }.

	aShip := 'Apollo'.
	anotherShip := 'Orion'.

	self
		should: [
			aGame
				playCard: Overload new
				from: anotherShip
				to: aShip ]
		raise: Error
		withMessageText: 'You can only play this card when its your turn'

]

{ #category : 'tests' }
GameTests >> test057ErrorWhenRedoCardIsUsedAndNoOtherCardsWereUsed [

	| someDice aGenerator aGame aShip anotherShip redoCard |
	someDice := OrderedCollection with: (CustomDie withRolls: #( 9 7 3 )).
	aGenerator := FixedCellGenerator withAllRegularCellAmount: 11.

	aGame := SpaceShipGame
		withShipsNamed: #( 'Apollo' 'Orion' )
		playedWith: someDice
		createdWith: aGenerator
		withWormholesAt: 1
		and: 2
		onABoardSized: 11
		whichToParsecsIs: 100
		forLaps: 1
		withRewards: (FuelBuffReward by: 0)
		andDeck: {
			Redo new.
			Cancellation new.
			Overload new }.

	aShip := 'Apollo'.
	anotherShip := 'Orion'.

	redoCard := (aGame deckOf: aShip) first.

	self
		should: [
			aGame playCard: redoCard from: aShip to: anotherShip ]
		raise: Error
		withMessageText: 'There is no card to redo'

]

{ #category : 'tests' }
GameTests >> test058WhenAccelerationCardIsUsedAndThenCancelledNoEffectIsApplied [

	| someDice aGenerator aGame aShip anotherShip accelerationCard cancellationCard |
	someDice := OrderedCollection with: (CustomDie withRolls: #( 9 7 3 )).
	aGenerator := FixedCellGenerator withAllRegularCellAmount: 15.

	aGame := SpaceShipGame
		withShipsNamed: #( 'Apollo' 'Orion' )
		playedWith: someDice
		createdWith: aGenerator
		withWormholesAt: 1
		and: 2
		onABoardSized: 15
		whichToParsecsIs: 100
		forLaps: 1
		withRewards: (FuelBuffReward by: 0)
		andDeck: {
			Acceleration new.
			Cancellation new }.

	aShip := 'Apollo'.
	anotherShip := 'Orion'.

	accelerationCard := (aGame deckOf: aShip) first.
	cancellationCard := (aGame deckOf: aShip) second.

	aGame playCard: accelerationCard from: aShip to: #( 'Apollo' 'Orion' ).
	aGame playCard: cancellationCard from: aShip to: accelerationCard.

	aGame playTurn.
	aGame playTurn.

	self assert: (aGame positions at: aShip) equals: 10.
	self assert: (aGame positions at: anotherShip) equals: 8

]

{ #category : 'tests' }
GameTests >> test059WhenCancellationCardIsUsedAndThenRedoneItCancelsTheNewTargetCard [

	| someDice aGenerator aGame aShip anotherShip accel1 accel2 cancellation redo apollo1 |
	someDice := OrderedCollection with:
		            (CustomDie withRolls: #( 5 5 6 7 10 )).
	aGenerator := FixedCellGenerator cells: ((1 to: 25) collect: [ :i |
			               i = 6
				               ifTrue: [ CardCell new ]
				               ifFalse: [ RegularCell new ] ]).

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' 'Orion' )
		         playedWith: someDice
		         createdWith: aGenerator
		         withWormholesAt: 2
		         and: 3
		         onABoardSized: 25
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         Acceleration new.
				         Cancellation new.
				         Redo new }.

	aShip := 'Apollo'.
	anotherShip := 'Orion'.
	apollo1 := aGame findShip: 'Apollo'.
	accel1 := (aGame deckOf: aShip) first.
	accel2 := (aGame deckOf: anotherShip) first.
	cancellation := (aGame deckOf: anotherShip) second.
	redo := (aGame deckOf: aShip) second.
	
	aGame playCard: accel1 from: aShip to: anotherShip.
	aGame playTurn.
	aGame playCard: accel2 from: anotherShip to: aShip.
	aGame playCard: cancellation from: anotherShip to: accel1.
	aGame playTurn.
	aGame playCard: redo from: aShip to: accel2.
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame positions at: aShip) equals: 13.
	self assert: (aGame positions at: anotherShip) equals: 14
]

{ #category : 'tests' }
GameTests >> test060WhenShipIsInSecondLapInitialSquaresAndAnotherTriggersMoonWalkThenItGoesToStartOfSameLap [

	| someDice aGenerator aGame aShip anotherShip someCells |
	someDice := OrderedCollection with:
		            (CustomDie withRolls: #( 9 3 7 3 9 )).
	someCells := (1 to: 15) collect: [ :i | RegularCell new ].
	someCells at: 7 put: (MoonWalkCell withSteps: 3).
	aGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' 'Orion' )
		         playedWith: someDice
		         createdWith: aGenerator
		         withWormholesAt: 1
		         and: 2
		         onABoardSized: 15
		         whichToParsecsIs: 150
		         forLaps: 2
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         NullCard new.
				         NullCard new }.

	aShip := 'Apollo'.
	anotherShip := 'Orion'.

	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.

	self assert: (aGame positions at: aShip) equals: 1
]

{ #category : 'tests' }
GameTests >> test061WhenRepeatCardIsUsedThenBlackHoleEffectIsAppliedAgainToTargetShip [

	| someDice aGenerator aGame aShip anotherShip repeatCard someCells |
	someDice := OrderedCollection with:
		            (CustomDie withRolls: #( 9 6 15 )).
	someCells := (1 to: 15) collect: [ :i | RegularCell new ].
	someCells at: 10 put: BlackHoleCell new.
	aGenerator := FixedCellGenerator cells: someCells.

	aGame := SpaceShipGame
		         withShipsNamed: #( 'Apollo' 'Orion' )
		         playedWith: someDice
		         createdWith: aGenerator
		         withWormholesAt: 1
		         and: 2
		         onABoardSized: 15
		         whichToParsecsIs: 100
		         forLaps: 1
		         withRewards: (FuelBuffReward by: 0)
		         andDeck: {
				         Repeat new.
				         Overload new.
				         Ally new }.

	aShip := 'Apollo'.
	anotherShip := 'Orion'.
	repeatCard := (aGame deckOf: anotherShip) first.

	aGame playTurn.
	aGame playCard: repeatCard from: anotherShip to: aShip.
	aGame playTurn.

	self assert: (aGame positions at: aShip) equals: 2.
	self assert: (aGame positions at: anotherShip) equals: 7
]
