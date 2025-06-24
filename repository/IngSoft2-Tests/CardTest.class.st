Class {
	#name : 'CardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
CardTest >> test001UsingAccelerationIncreasesDiceAdjustmentOfAllShips [

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
CardTest >> test002CancellationRemovesAccelerationEffect [

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
CardTest >> test003OverloadAffectsOnlyTargetShip [

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
CardTest >> test004CancellationRemovesOverloadEffect [

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
	self assert: ship diceAdjustment equals: -2.

	game playCard: cancellationCard from: 'ship' to: overloadCard.
	self assert: ship diceAdjustment equals: 0.

	game playTurn.
	positions := game positions.
	self assert: (positions at: 'ship') equals: 9
]

{ #category : 'tests' }
CardTest >> test005CancellationRemovesOverloadEffectWhileGameHasTwoShipsPlaying [

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
	self assert: shipB diceAdjustment equals: -2.

	game playCard: cancellationCard from: 'shipB' to: overloadCard.
	self assert: shipB diceAdjustment equals: 0.

	game playTurn.
	self assert: (game positions at: 'shipB') equals: 5
]

{ #category : 'tests' }
CardTest >> test006RedoReappliesLastPermanentEffect [

	| die game ship overloadCard redoCard |
	die := CustomDie withRolls: #( 1 1 1 ).

	game := SpaceShipGame
		        withShipsNamed: #( 'Apollo' )
		        playedWith: (OrderedCollection with: die)
		        createdWith:
		        (FixedCellGenerator withAllRegularCellAmount: 10)
		        withWormholesAt: 3
		        and: 7
		        onABoardSized: 10
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

	game playCard: overloadCard from: 'Apollo' to: 'Apollo'.
	self assert: ship diceAdjustment equals: -2.

	game playCard: redoCard from: 'Apollo' to: overloadCard.
	self assert: ship diceAdjustment equals: -4
]

{ #category : 'tests' }
CardTest >> test007ShipBorrowsFuelFromAllyWhenRunningLow [

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
CardTest >> test008WhenCancellationCardIsUsedOnAllyCardThenShipsNoLongerShareTheirFuel [

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
CardTest >> test009WhenShipsAreAlliedAndNeitherHasEnoughFuelBothArePenalized [

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
CardTest >> test010WhenShipFallsOnBlackHoleCellAndARepeatCardIsUsedThenBlackHoleEffectIsAppliedToTheTargetedShip [

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
