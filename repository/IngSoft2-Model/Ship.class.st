Class {
	#name : 'Ship',
	#superclass : 'Object',
	#instVars : [
		'name',
		'fuel',
		'fuelCapacity',
		'lostTurns'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Ship class >> withName: aName and: aFuelAmount [

	^ self new initializeWith: aName and: aFuelAmount
]

{ #category : 'as yet unclassified' }
Ship >> applyPenaltyIn: board [

	board moveShipToStart: self.
	self refuel.
	self loseTurn.
	self loseTurn.
]

{ #category : 'accessing' }
Ship >> attemptMoveBy: steps in: board [

	| cost |
	cost := steps abs.
	fuel < cost ifTrue: [ ^ self applyPenaltyIn: board ].
	self consumeFuel: cost.
	board moveShipDirectly: self steps: steps
]

{ #category : 'as yet unclassified' }
Ship >> canPlay [

	^ lostTurns <= 0
]

{ #category : 'accessing' }
Ship >> consumeFuel: steps [

	| cost |
	cost := steps abs.
	cost > fuel ifTrue: [
		Error signal: 'Cannot consume more fuel than available.' ].
	fuel := fuel - cost
]

{ #category : 'accessing' }
Ship >> currentFuel [

	^ fuel
]

{ #category : 'accessing' }
Ship >> fuelCapacity [

	^ fuelCapacity
]

{ #category : 'as yet unclassified' }
Ship >> initializeWith: aName and: aFuelAmount [

	name := aName.
	fuel := aFuelAmount.
	fuelCapacity := aFuelAmount.
	lostTurns := 0
]

{ #category : 'as yet unclassified' }
Ship >> loseTurn [ 
	lostTurns := lostTurns + 1.
]

{ #category : 'as yet unclassified' }
Ship >> lostATurn [

	lostTurns := (lostTurns - 1) max: 0
]

{ #category : 'accessing' }
Ship >> name [

	^ name
]

{ #category : 'as yet unclassified' }
Ship >> playTurnIn: aGame [

	self canPlay
		ifFalse: [ self lostATurn ]
		ifTrue: [ aGame performTurnSequenceFor: self ]
]

{ #category : 'as yet unclassified' }
Ship >> refuel [

	fuel := fuelCapacity 
]
