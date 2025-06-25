Class {
	#name : 'SpaceShipGame',
	#superclass : 'Object',
	#instVars : [
		'board',
		'dice',
		'ships',
		'cardEnforcer',
		'availableCards',
		'turnManager',
		'rewards'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
SpaceShipGame class >> validateShips: shipNames andDice: someDice [

	shipNames isEmpty ifTrue: [
		Error signal: 'Must have at least one ship' ].

	someDice isEmpty ifTrue: [
		Error signal: 'Dice collection cannot be empty' ]
]

{ #category : 'as yet unclassified' }
SpaceShipGame class >> withShipsNamed: someShipNames playedWith: someDice createdWith: aCellGenerator withWormholesAt: aFirstWormholeLocation and: aSecondWormholeLocation onABoardSized: aBoardSize whichToParsecsIs: anAmountOfParsecs forLaps: aLapCount withRewards: someRewards andDeck: aDeckOfCards [

	^ self new
		  initializeWith: someShipNames
		  withDice: someDice
		  withGenerator: aCellGenerator
		  withWormholesAt: aFirstWormholeLocation
		  and: aSecondWormholeLocation
		  withBoardSize: aBoardSize
		  withParsecs: anAmountOfParsecs
		  withLaps: aLapCount
		  withRewards: someRewards
		  andDeck: aDeckOfCards
]

{ #category : 'as yet unclassified' }
SpaceShipGame class >> withShipsNamed: someShipNames playedWith: someDice onABoardSized: aBoardSize whichToParsecsIs: aLengthInParsecs forLaps: aLapCount withWormholesAt: aFirstWormholeLocation and: aSecondWormholeLocation [

	self validateShips: someShipNames andDice: someDice.

	^ self new
		  initializeWithShipNames: someShipNames
		  dice: someDice
		  boardSize: aBoardSize
		  lengthInParsecs: aLengthInParsecs
		  laps: aLapCount
		  wormholesAt: aFirstWormholeLocation
		  and: aSecondWormholeLocation
]

{ #category : 'as yet unclassified' }
SpaceShipGame >> currentTurnsShip [

	^  turnManager currentTurnsShip 
]

{ #category : 'testing' }
SpaceShipGame >> deckOf: aSpaceshipName [

	^ (self findShip: aSpaceshipName) cards
]

{ #category : 'testing' }
SpaceShipGame >> findShip: aShipName [

	^ ships
		  detect: [ :ship | ship name = aShipName ]
		  ifNone: [ Error signal: 'No ship name found' ]
]

{ #category : 'initialization' }
SpaceShipGame >> initializeWith: someShipNames withDice: someDice withGenerator: aCellGenerator withWormholesAt: aWormholeStartLocation and: aWormholeEndLocation withBoardSize: aBoardSize withParsecs: aLengthInParsecs withLaps: aLapCount withRewards: someRewards andDeck: aDeckOfCards [

	dice := Dice with: someDice.
	ships := someShipNames collect: [ :eachName |
		         Ship withName: eachName and: 2 * dice maxThrow ].
	ships do: [ :player |
		player
			giveCard: aDeckOfCards first deepCopy;
			giveCard: aDeckOfCards second deepCopy ].

	board := Board
		         withShips: ships
					boardSize: aBoardSize 
		         lengthInParsecs: aLengthInParsecs
		         lapsToWin: aLapCount
		         wormholeStart: aWormholeStartLocation
		         wormholeEnd: aWormholeEndLocation
		         cellGenerator: aCellGenerator
		         cards: aDeckOfCards.
	turnManager := TurnManager withShips: ships.
	rewards := someRewards.
	cardEnforcer := CardEnforcer
		                withShips: ships
		                withBoard: board
		                withTurnManager: turnManager
]

{ #category : 'initialization' }
SpaceShipGame >> initializeWithShipNames: someShipNames dice: someDice boardSize: aBoardSize lengthInParsecs: aLengthInParsecs laps: aLapCount wormholesAt: aWormholeStartLocation and: aWormholeEndLocation [

	| aDefaultDistribution aCellGenerator |
	aDefaultDistribution := OrderedCollection new.
	aDefaultDistribution
		add: {
				0.3.
				[ RegularCell new ] };
		add: {
				0.1.
				[ CardCell new ] };
		add: {
				0.2.
				[ BlackHoleCell new ] };
		add: {
				0.2.
				[ HyperGravityCell requiringMinimumRoll: dice maxThrow atRandom ] };
		add: {
				0.1.
				[ MoonWalkCell withSteps: 3 ] };
		add: {
				0.08.
				[
				HyperJumpCell withLengths: {
							2 parsecs.
							5 lightYears.
							7 parsecs } asOrderedCollection ] };
		add: {
				0.02.
				[ AtomicBombCell new ] }.

	aCellGenerator := CellGenerator
		                  withCellCount: aBoardSize
		                  andDistribution: aDefaultDistribution.
	rewards := RewardManager with: {
			           ((FuelBuffReward by: 1) -> 0.2).
			           ((FuelDebuffReward by: 1) -> 0.8) }.
	availableCards := {
		                  Cancellation new.
		                  Repeat new.
		                  Acceleration new.
		                  Ally new.
		                  Overload new.
		                  Redo new }.
	dice := Dice with: someDice.
	ships := someShipNames collect: [ :eachName |
		         Ship withName: eachName and: 2 * dice maxThrow ].
	ships do: [ :player |
		player
			giveCard: availableCards atRandom;
			giveCard: availableCards atRandom ].
	board := Board
		         withShips: ships
		         boardSize: aBoardSize
		         lengthInParsecs: aLengthInParsecs
		         lapsToWin: aLapCount
		         wormholeStart: aWormholeStartLocation
		         wormholeEnd: aWormholeEndLocation
		         cellGenerator: aCellGenerator
		         cards: availableCards.
	turnManager := TurnManager withShips: ships.
	board placeAllShipsAtStart: ships
]

{ #category : 'testing' }
SpaceShipGame >> isOver [

	^ board anyShipCompletedAllLaps
]

{ #category : 'testing' }
SpaceShipGame >> playCard: aCard from: aShipNamed to: aTargetNamed [

	| aShip |
	self verifyIsNotOver.
	aShip := self findShip: aShipNamed.
	cardEnforcer playCard: aCard from: aShip target: aTargetNamed
]

{ #category : 'as yet unclassified' }
SpaceShipGame >> playTurn [

	| spaceshipToPlay diceThrow |
	self verifyIsNotOver.
	spaceshipToPlay := turnManager currentTurnsShip.
	diceThrow := dice throw.
	diceThrow = dice maxThrow ifTrue: [ rewards applyTo: spaceshipToPlay ].
	spaceshipToPlay playTurnIn: board withDiceResult: diceThrow.
	board applyEffectTo: spaceshipToPlay.
	turnManager advanceToNextPlayer
]

{ #category : 'as yet unclassified' }
SpaceShipGame >> positionOfShip: aShip [

	^ board indexOfCellContaining: aShip
]

{ #category : 'as yet unclassified' }
SpaceShipGame >> positions [

	^ Dictionary newFrom:
		  (ships collect: [ :ship |
			   ship name -> (self positionOfShip: ship) ])

]

{ #category : 'testing' }
SpaceShipGame >> rankings [

	self isOver ifFalse: [ Error signal: 'Game is not over' ].
	^ (RankingTable forPlayers: ships withGameboard: board) rankings
]

{ #category : 'accessing' }
SpaceShipGame >> ships [

	^ ships
]

{ #category : 'as yet unclassified' }
SpaceShipGame >> skipTurn [

	| ship |
	ship := self currentTurnsShip.
	ship refuel.
	turnManager advanceToNextPlayer 
]

{ #category : 'as yet unclassified' }
SpaceShipGame >> verifyIsNotOver [ 

	self isOver ifTrue: [ Error signal: 'game is over!' ]
]

{ #category : 'testing' }
SpaceShipGame >> winner [

	^ board shipThatCompletedAllLaps
]
