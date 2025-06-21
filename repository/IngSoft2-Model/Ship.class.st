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
Ship >> applyPenalty [

	self refuel.
	self loseTurn.
	self loseTurn
]

{ #category : 'as yet unclassified' }
Ship >> canMove: aDiceResult [

	fuel < aDiceResult abs ifTrue: [
		self applyPenalty.
		^ false ].
	self consumeFuel: aDiceResult.
	^ true
]

{ #category : 'as yet unclassified' }
Ship >> canPlayATurn [

	lostTurns <= 0 ifTrue: [ ^ true ].
	self lostATurn.
	^ false
]

{ #category : 'accessing' }
Ship >> consumeFuel: steps [

	| cost |
	cost := steps abs.
	cost > fuel ifTrue: [
		Error signal: 'Cannot consume more fuel than available.' ].
	fuel := fuel - cost
]

{ #category : 'as yet unclassified' }
Ship >> initializeWith: aName and: aFuelAmount [

	name := aName.
	fuel := aFuelAmount.
	fuelCapacity := aFuelAmount.
	lostTurns := 0.
]

{ #category : 'as yet unclassified' }
Ship >> loseTurn [

	lostTurns := lostTurns + 1
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
Ship >> refuel [

	fuel := fuelCapacity 
]
