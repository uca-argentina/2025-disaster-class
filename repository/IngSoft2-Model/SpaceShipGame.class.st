Class {
	#name : 'SpaceShipGame',
	#superclass : 'Object',
	#instVars : [
		'board',
		'dice',
		'ships',
		'numberOfLaps',
		'cardEnforcer',
		'availableCards',
		'turnManager',
		'rewards'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
SpaceShipGame class >> onABoardSized: aBoardSize withWormholesAt: aFirstWormholeLocation and: aSecondWormholeLocation forLaps: aLapCount withDice: someDice andShipsNamed: someShipNames [

	^ self new
		  initializeWithBoardSize: aBoardSize
		  withWormholesAt: aFirstWormholeLocation
		  and: aSecondWormholeLocation
		  withDice: someDice
		  shipNames: someShipNames
		  andLaps: aLapCount

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

{ #category : 'accessing' }
SpaceShipGame >> board [

	^ board
]

{ #category : 'testing' }
SpaceShipGame >> cardEnforcer [

	^ cardEnforcer
]

{ #category : 'as yet unclassified' }
SpaceShipGame >> currentTurnsShip [

	^  turnManager currentTurnsShip 
]

{ #category : 'testing' }
SpaceShipGame >> deckOf: aSpaceshipName [ 

^ (self findShip: aSpaceshipName) cards.
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
		         Ship withName: eachName and: 2 * self maxDiceRoll ].
	ships do: [ :player |
		player
			giveCard: aDeckOfCards first;
			giveCard: aDeckOfCards second ].

	board := Board
		         withShips: ships
		         lengthInParsecs: aLengthInParsecs
		         lapsToWin: aLapCount
		         wormholeStart: aWormholeStartLocation
		         wormholeEnd: aWormholeEndLocation
		         cellGenerator: aCellGenerator.
	turnManager := TurnManager withShips: ships.
	numberOfLaps := aLapCount.
	rewards := someRewards.
	cardEnforcer := CardEnforcer
		                withShips: ships
		                withBoard: board
		                withTurnManager: turnManager
]

{ #category : 'initialization' }
SpaceShipGame >> initializeWithBoardSize: aBoardSize withWormholesAt: aFirstWormholeLocation and: aSecondWormholeLocation withDice: someDice shipNames: someShipNames andLaps: aLapCount [

	| cells aDefaultDistribution aCellGenerator |
	dice := someDice.

	ships := someShipNames collect: [ :eachName |
		         Ship withName: eachName and: 2 * self maxDiceRoll ].

	aDefaultDistribution := OrderedCollection
		                        with: {
				                        0.4.
				                        [ RegularCell new ] }
		                        with: {
				                        0.2.
				                        [ BlackHoleCell new ] }
		                        with: {
				                        0.2.
				                        [
				                        HyperGravityCell requiringMinimumRoll: 2 ] }
		                        with: {
				                        0.1.
				                        [ MoonWalkCell withSteps: 3 ] }
		                        with: {
				                        0.08.
				                        [
				                        HyperJumpCell withLengths: {
						                        2 parsecs.
						                        5 parsecs.
						                        7 parsecs } ] }
		                        with: {
				                        0.02.
				                        [ AtomicBombCell new ] }.
	aCellGenerator := CellGenerator
		                  withCellCount: aBoardSize
		                  andDistribution: aDefaultDistribution.
	cells := aCellGenerator generate.
	WormholeCell
		newPairIn: cells
		at: aFirstWormholeLocation
		and: aSecondWormholeLocation.

	board := Board withCells: cells andShips: ships.
	board placeAllShipsAtStart: ships.


	turnManager := TurnManager withShips: ships.
	numberOfLaps := aLapCount.

	self initializeCardsAndCardEnforcer
]

{ #category : 'testing' }
SpaceShipGame >> isOver [

	^ board anyShipCompletedAllLaps
]

{ #category : 'accessing' }
SpaceShipGame >> maxDiceRoll [
	| allDice sidesList |
	
	allDice := dice isCollection
		ifTrue: [ dice ]
		ifFalse: [ Array with: dice ].

	sidesList := allDice collect: [ :die |
		(die respondsTo: #maxThrow)
			ifTrue: [ die maxThrow ]
			ifFalse: [ 0 ] ].

	^ sidesList sum.
]

{ #category : 'testing' }
SpaceShipGame >> playCard: aCard from: aShipNamed to: aTargetNamed [ 
	|  aShip  |
	self verifyIsNotOver .
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

{ #category : 'testing' }
SpaceShipGame >> turnManager [
	^turnManager 
]

{ #category : 'as yet unclassified' }
SpaceShipGame >> verifyIsNotOver [ 

	self isOver ifTrue: [ Error signal: 'game is over!' ]
]

{ #category : 'testing' }
SpaceShipGame >> winner [

	^ board ships
		  detect: [ :ship | (board lapsCompletedOf: ship) >= numberOfLaps ]
		  ifNone: [ nil ]
]
