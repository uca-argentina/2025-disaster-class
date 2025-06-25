Class {
	#name : 'Ship',
	#superclass : 'Object',
	#instVars : [
		'name',
		'fuel',
		'fuelCapacity',
		'lostTurns',
		'diceAdjustment',
		'cards',
		'requiredRoll',
		'ally'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Ship class >> withName: aName and: aFuelAmount [

	^ self new initializeWith: aName and: aFuelAmount
]

{ #category : 'as yet unclassified' }
Ship >> allyWith: aSpaceship [

	ally := aSpaceship
]

{ #category : 'as yet unclassified' }
Ship >> applyPenaltyIn: aBoard [

	self refuel.
	self loseTurn.
	self loseTurn.
	aBoard moveShipToStart: self
]

{ #category : 'accessing' }
Ship >> cards [

	^ cards
]

{ #category : 'as yet unclassified' }
Ship >> changeDiceAdjustmentBy: anAmount [

	diceAdjustment := diceAdjustment + anAmount
]

{ #category : 'as yet unclassified' }
Ship >> changeFuelCapacityBy: anAmount [ 

	fuelCapacity := fuelCapacity + anAmount.
	fuel := fuelCapacity min: fuel

]

{ #category : 'as yet unclassified' }
Ship >> changeRequiredRollTo: aRequiredRoll [

	requiredRoll := aRequiredRoll
]

{ #category : 'accessing' }
Ship >> consumeFuel: anAmount [

	| cost |
	cost := anAmount abs.
	fuel := fuel - cost
]

{ #category : 'as yet unclassified' }
Ship >> findCardOfClass: aCardClass [

	^ cards detect: [ :c | c class = aCardClass ] ifNone: [ nil ]
]

{ #category : 'as yet unclassified' }
Ship >> giveCard: aCard [ 

	cards add: aCard
]

{ #category : 'as yet unclassified' }
Ship >> initializeWith: aName and: aFuelAmount [

	name := aName.
	fuel := aFuelAmount.
	fuelCapacity := aFuelAmount.
	lostTurns := 0.
	cards := OrderedCollection new.
	diceAdjustment := 0.
	requiredRoll := 0.
	ally := NullShip new.
]

{ #category : 'as yet unclassified' }
Ship >> loseTurn [

	lostTurns := lostTurns + 1
]

{ #category : 'as yet unclassified' }
Ship >> lostATurn [

	lostTurns := (lostTurns - 1) max: 0
]

{ #category : 'as yet unclassified' }
Ship >> move: anAmount in: aBoard [

	self useAllyFuelIfNecessary: anAmount in: aBoard.
	fuel < anAmount abs ifTrue: [ ^ self applyPenaltyIn: aBoard ].
	self consumeFuel: anAmount.
	aBoard moveShip: self by: anAmount
]

{ #category : 'accessing' }
Ship >> name [

	^ name
]

{ #category : 'as yet unclassified' }
Ship >> playTurnIn: aBoard withDiceResult: aDiceResult [

	| anAdjustedDiceResult |
	lostTurns > 0 ifTrue: [ ^ self lostATurn ].
	aDiceResult < requiredRoll ifTrue: [ ^ self ].
	requiredRoll := 0.
	anAdjustedDiceResult := aDiceResult + diceAdjustment.
	self move: anAdjustedDiceResult in: aBoard
]

{ #category : 'as yet unclassified' }
Ship >> refuel [

	fuel := fuelCapacity
]

{ #category : 'as yet unclassified' }
Ship >> takeFuel: anAmountOfFuel [ 

	anAmountOfFuel > fuel ifTrue: [ ^ 0 ].

	fuel := fuel - anAmountOfFuel.

	^ anAmountOfFuel



]

{ #category : 'as yet unclassified' }
Ship >> useAllyFuelIfNecessary: amountOfSteps in: aBoard [

	| allyFuel |
	fuel <= amountOfSteps abs ifFalse: [ ^ self ].

	allyFuel := ally takeFuel: amountOfSteps - fuel + 1.

	fuel := fuel + allyFuel.

	fuel <= amountOfSteps abs ifTrue: [ ally applyPenaltyIn: aBoard ]
]

{ #category : 'as yet unclassified' }
Ship >> useCard: aCard [

	cards remove: aCard ifAbsent: [
		Error signal:
			self name , ' does not have a ' , aCard class name , ' card' ]
]
