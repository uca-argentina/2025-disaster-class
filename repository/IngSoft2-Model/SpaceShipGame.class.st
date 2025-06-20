Class {
	#name : 'SpaceShipGame',
	#superclass : 'Object',
	#instVars : [
		'board',
		'dice',
		'ships',
		'shipTurnIndex',
		'numberOfLaps'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
SpaceShipGame class >> createdWith: aCellGenerator withWormholesAt: aFirstWormholeLocation and: aSecondWormholeLocation forLaps: aLapCount withDice: someDice andShipsNamed: someShipNames [

	^ self new
		  initializeWith: aCellGenerator
		  withWormholesAt: aFirstWormholeLocation
		  and: aSecondWormholeLocation
		  withDice: someDice
		  shipNames: someShipNames
		  andLaps: aLapCount

]

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
SpaceShipGame >> advanceToNextPlayer [

	shipTurnIndex := shipTurnIndex \\ ships size + 1
]

{ #category : 'accessing' }
SpaceShipGame >> board [

	^ board
]

{ #category : 'as yet unclassified' }
SpaceShipGame >> calculateNewPositionFor: aShip afterRolling: totalRoll [

	| currentIndex maxIndex targetIndex |

	currentIndex := self positionOfShip: aShip.
	maxIndex := board size.
	targetIndex := currentIndex + totalRoll min: maxIndex.
	^ board cellAt: targetIndex

]

{ #category : 'as yet unclassified' }
SpaceShipGame >> currentCellOf: aShip [


	^ board cellContaining: aShip

]

{ #category : 'as yet unclassified' }
SpaceShipGame >> currentShip [

	^ ships at: shipTurnIndex
]

{ #category : 'accessing' }
SpaceShipGame >> dice [

	^ dice
]

{ #category : 'testing' }
SpaceShipGame >> finishLineCell [

	^ board lastCell
]

{ #category : 'as yet unclassified' }
SpaceShipGame >> fuelOf: aName [

	^ (ships detect: [ :s | s name = aName ]) currentFuel 
]

{ #category : 'initialization' }
SpaceShipGame >> initializeWith: aCellGenerator withWormholesAt: aFirstWormholeLocation and: aSecondWormholeLocation withDice: someDice shipNames: someShipNames andLaps: aLapCount [

	| cells|
	dice := someDice.

	ships := someShipNames collect: [ :eachName |
		         Ship withName: eachName and: 2 * self maxDiceRoll ].

	cells := aCellGenerator generate.
	WormholeCell newPairIn: cells at: aFirstWormholeLocation and: aSecondWormholeLocation.

	board := Board withCells: cells andShips: ships.
	board placeAllShipsAtStart: ships.

	shipTurnIndex := 1.
	numberOfLaps := aLapCount
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
					                        totalParsecs: 10 ] }
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

	shipTurnIndex := 1.
	numberOfLaps := aLapCount
]

{ #category : 'testing' }
SpaceShipGame >> isOver [


	^ board ships anySatisfy: [ :ship | (board lapsCompletedOf: ship) >= numberOfLaps ]

]

{ #category : 'testing' }
SpaceShipGame >> isShipAtFinishLine: aShip [


	^ (self currentCellOf: aShip) = board lastCell
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

{ #category : 'as yet unclassified' }
SpaceShipGame >> performTurnSequenceFor: aShip [

	| steps |
	steps := self rollAllDice.
	board moveShip: aShip steps: steps.
	board applyEffectTo: aShip.

]

{ #category : 'as yet unclassified' }
SpaceShipGame >> playTurn [

	self isOver ifTrue: [ ^ self ].

	self currentShip playTurnIn: self.

	self advanceToNextPlayer
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

{ #category : 'as yet unclassified' }
SpaceShipGame >> rollAllDice [


	^ (dice collect: [ :d | d rollDice ]) sum.
]

{ #category : 'accessing' }
SpaceShipGame >> ships [

	^ ships
]

{ #category : 'as yet unclassified' }
SpaceShipGame >> skipTurn [

	| ship |
	ship := self currentShip.
	ship refuel.
	self advanceToNextPlayer

]

{ #category : 'testing' }
SpaceShipGame >> winner [


	^ board ships
        detect: [ :ship | (board lapsCompletedOf: ship) >= numberOfLaps ]
        ifNone: [ nil ]

]
