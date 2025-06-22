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
	die := TestDie withRolls: #(4 4 100).
	generator := FixedCellGenerator withAllRegularCellAmount: boardSize.

	game := SpaceShipGame
		createdWith: generator
		withWormholesAt: 1 and: 2
		forLaps: 1
		withDice: (OrderedCollection with: die)
		andShipsNamed: #('shipA').

	shipA := game ships first.
	accelerationCard := shipA findCardOfClass: Acceleration.
	self assert: accelerationCard notNil.

	game playTurn.

	positions := game positions.
	self assert: (positions at: 'shipA') equals: 5.

	game playCard: accelerationCard from: 'shipA' to: nil.

	game playTurn.

	positions := game positions.
	self assert: (positions at: 'shipA') equals: 10.
]

{ #category : 'tests' }
CardTest >> test002CancellationRemovesAccelerationEffect [

	| die game shipA accelerationCard cancellationCard generator boardSize positions |
	boardSize := 14.
	die := TestDie withRolls: #(4 4 4 100).
	generator := FixedCellGenerator withAllRegularCellAmount: boardSize.

	game := SpaceShipGame
		createdWith: generator
		withWormholesAt: 1 and: 2
		forLaps: 1
		withDice: (OrderedCollection with: die)
		andShipsNamed: #('shipA').

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
	self assert: (positions at: 'shipA') equals: 14. 
]

{ #category : 'tests' }
CardTest >> test003OverloadAffectsOnlyTargetShip [

| die game shipA shipB overloadCard generator boardSize positions |
	boardSize := 10.
	die := TestDie withRolls: #(4 4 100).
	generator := FixedCellGenerator withAllRegularCellAmount: boardSize.

	game := SpaceShipGame
		createdWith: generator
		withWormholesAt: 1 and: 2
		forLaps: 1
		withDice: (OrderedCollection with: die)
		andShipsNamed: #('shipA' 'shipB').

	shipA := game ships first.
	shipB := game ships second.

	overloadCard := shipA findCardOfClass: Overload.
	self assert: overloadCard notNil.

	game playTurn.
	positions := game positions.
	self assert: (positions at: 'shipA') equals: 5.

	game playCard: overloadCard from: 'shipA' to: 'shipB'.

	self assert: shipA diceAdjustment equals: 0.
	self assert: shipB diceAdjustment equals: -2.

	game playTurn.
	positions := game positions.
	self assert: (positions at: 'shipB') equals: 3. 
]

{ #category : 'tests' }
CardTest >> test004CancellationRemovesOverloadEffect [

	| die game shipA shipB overloadCard cancellationCard generator boardSize positions |
	boardSize := 10.
	die := TestDie withRolls: #(4 4 100).
	generator := FixedCellGenerator withAllRegularCellAmount: boardSize.

	game := SpaceShipGame
		createdWith: generator
		withWormholesAt: 1 and: 2
		forLaps: 1
		withDice: (OrderedCollection with: die)
		andShipsNamed: #('shipA' 'shipB').

	shipA := game ships first.
	shipB := game ships second.

	overloadCard := shipA findCardOfClass: Overload.
	cancellationCard := shipB findCardOfClass: Cancellation.

	self assert: overloadCard notNil.
	self assert: cancellationCard notNil.

	game playTurn.
	positions := game positions.
	self assert: (positions at: 'shipA') equals: 5.

	game playCard: overloadCard from: 'shipA' to: 'shipB'.
	self assert: shipB diceAdjustment equals: -2.

	game playCard: cancellationCard from: 'shipB' to: overloadCard.
	self assert: shipB diceAdjustment equals: 0.

	game playTurn.
	positions := game positions.
	self assert: (positions at: 'shipB') equals: 5.
]
