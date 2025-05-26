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
	lostTurns := 2
]

{ #category : 'as yet unclassified' }
Ship >> canPlay [

	^ lostTurns = 0
]

{ #category : 'accessing' }
Ship >> consumeFuel: steps [ 
	fuel := fuel - steps.

]

{ #category : 'accessing' }
Ship >> fuel [

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
Ship >> lostATurn [

	lostTurns := lostTurns - 1
]

{ #category : 'accessing' }
Ship >> moveS: steps in: board [

	fuel < steps ifTrue: [ ^ self applyPenaltyIn: board ].
	self consumeFuel: steps.
	board moveShip: self steps: steps
]

{ #category : 'accessing' }
Ship >> name [

	^ name
]

{ #category : 'as yet unclassified' }
Ship >> refuel [

	fuel := fuelCapacity 
]
