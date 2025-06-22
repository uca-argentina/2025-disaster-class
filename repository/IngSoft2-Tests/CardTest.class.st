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

	accelerationCard use: game cardEnforcer from: shipA target: nil.

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
	self assert: accelerationCard notNil.

	
	game playTurn.
	positions := game positions.
	self assert: (positions at: 'shipA') equals: 5. "1 + 4"

	
	accelerationCard use: game cardEnforcer from: shipA target: nil.

	
	game playTurn.
	positions := game positions.
	self assert: (positions at: 'shipA') equals: 10. "5 + (4 + 1)"

	
	cancellationCard := Cancellation new.
	cancellationCard use: game cardEnforcer from: shipA target: accelerationCard.

	
	game playTurn.
	positions := game positions.
	self assert: (positions at: 'shipA') equals: 14. "10 + 4 (sin el +1)"

]
