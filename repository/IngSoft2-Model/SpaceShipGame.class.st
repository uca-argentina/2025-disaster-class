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
		'turnManager'
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
	^cardEnforcer 
]

{ #category : 'as yet unclassified' }
SpaceShipGame >> currentTurnsShip [

	^  turnManager currentTurnsShip 
]

{ #category : 'as yet unclassified' }
SpaceShipGame >> diceRollResult [

	^ (dice collect: [ :d | d rollDice ]) sum 
]

{ #category : 'testing' }
SpaceShipGame >> findShip: aShipName [
	^ships detect: [ :ship | ship name = aShipName ]
		ifNone: [ Error signal: 'No ship name found' ]
]

{ #category : 'testing' }
SpaceShipGame >> initializeCardsAndCardEnforcer [

	availableCards := OrderedCollection new.
	availableCards
		add: Acceleration new;
		add: Cancellation new;
		add: Overload new;
		add: Redo new;
		add: Acceleration new;
		add: Overload new;
		add: Redo new;
		add: Cancellation new;
		add: Acceleration new;
		add: Cancellation new;
		add: Overload new;
		add: Redo new.

	ships do: [ :ship |
		ship addCard: availableCards removeFirst.
		ship addCard: availableCards removeFirst.
		ship addCard: availableCards removeFirst.
		ship addCard: availableCards removeFirst ].

	cardEnforcer := CardEnforcer
		                withShips: ships
		                withBoard: board
		                withTurnManager: turnManager
]

{ #category : 'initialization' }
SpaceShipGame >> initializeWith: someShipNames withDice: someDice withGenerator: aCellGenerator withWormholesAt: aFirstWormholeLocation and: aSecondWormholeLocation withBoardSize: aBoardSize withParsecs: anAmountOfParsecs withLaps: aLapCount withRewards: someRewards andDeck: aDeckOfCards [

	| cells |
	dice := someDice.

	ships := someShipNames collect: [ :eachName |
		         Ship withName: eachName and: 2 * self maxDiceRoll ].

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
				                        HyperJumpCell
					                        withParsecList: #( 100 50 20 )
					                        totalParsecs: 100 ] }
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


	^ board ships anySatisfy: [ :ship | (board lapsCompletedOf: ship) >= numberOfLaps ]

]

{ #category : 'accessing' }
SpaceShipGame >> maxDiceRoll [
	| allDice sidesList |
	
	allDice := dice isCollection
		ifTrue: [ dice ]
		ifFalse: [ Array with: dice ].

	sidesList := allDice collect: [ :die |
		(die respondsTo: #sides)
			ifTrue: [ die sides ]
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

	self verifyIsNotOver.
	turnManager currentTurnsShip 
		playTurnIn: board
		withDiceResult: self diceRollResult.
	board applyEffectTo: turnManager currentTurnsShip.
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
