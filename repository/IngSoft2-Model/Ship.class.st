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
		'requiredRoll'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Ship class >> withName: aName and: aFuelAmount [

	^ self new initializeWith: aName and: aFuelAmount
]

{ #category : 'as yet unclassified' }
Ship >> addCard: aCard [
	cards add: aCard.
]

{ #category : 'as yet unclassified' }
Ship >> applyPenaltyIn: aBoard [

	self refuel.
	self loseTurn.
	self loseTurn.
	aBoard moveShipToStart: self
]

{ #category : 'as yet unclassified' }
Ship >> canMove: anAmountOfCellsToMove in: aBoard [

	fuel < anAmountOfCellsToMove abs ifTrue: [
		self applyPenaltyIn: aBoard.
		^ false ].
	self consumeFuel: anAmountOfCellsToMove.
	^ true
]

{ #category : 'as yet unclassified' }
Ship >> canPlayATurn [

	lostTurns <= 0 ifTrue: [ ^ true ].
	self lostATurn.
	^ false
]

{ #category : 'as yet unclassified' }
Ship >> changeRequiredRollTo: aRequiredRoll [

	requiredRoll := aRequiredRoll
]

{ #category : 'as yet unclassified' }
Ship >> changeTotalThrowBy: anAmount [
	diceAdjustment := diceAdjustment + anAmount.
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
Ship >> diceAdjustment [
	^diceAdjustment 
]

{ #category : 'as yet unclassified' }
Ship >> findCardOfClass: aCardClass [
	^ cards detect: [ :c | c class = aCardClass ] ifNone: [ nil ]
]

{ #category : 'as yet unclassified' }
Ship >> handleEffectMovementFor: anAmountOfCells in: aBoard [

	(self canMove: anAmountOfCells in: aBoard) ifTrue: [
		aBoard moveShip: self steps: anAmountOfCells ]
]

{ #category : 'as yet unclassified' }
Ship >> handleTurnMovementFor: aDiceResult in: aBoard [

	(self canMove: aDiceResult in: aBoard) ifTrue: [
		aBoard handleMovementOf: self thatRolled: aDiceResult ]
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
Ship >> playTurnIn: aBoard withDiceResult: aDiceResult [
	|actualResult|
	actualResult  := aDiceResult +diceAdjustment.
	lostTurns > 0 ifTrue: [ ^ self lostATurn ].
	actualResult < requiredRoll ifTrue: [ ^ self ].
	requiredRoll := 0.
	self handleTurnMovementFor: actualResult in: aBoard
]

{ #category : 'as yet unclassified' }
Ship >> refuel [

	fuel := fuelCapacity 
]

{ #category : 'as yet unclassified' }
Ship >> removeCard: aCard [ 
	cards remove: aCard ifAbsent: [ Error signal: 'Card not found' ]

]

{ #category : 'as yet unclassified' }
Ship >> resetTotalThrowModifier [
	diceAdjustment := 0.
]

{ #category : 'as yet unclassified' }
Ship >> useCard: aCard [ 

	cards
		remove: aCard
		ifAbsent: [
		Error signal: self name , ' does not have a ' , aCard class name, ' card' ]
]
