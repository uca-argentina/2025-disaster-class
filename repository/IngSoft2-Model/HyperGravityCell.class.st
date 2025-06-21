Class {
	#name : 'HyperGravityCell',
	#superclass : 'Cell',
	#instVars : [
		'requiredRoll'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
HyperGravityCell class >> requiringMinimumRoll: aNumber [

	^ self new initializeWithRequiredRoll: aNumber
]

{ #category : 'as yet unclassified' }
HyperGravityCell >> applyEffectTo: aShip in: aBoard [

	aShip lastRoll < requiredRoll ifTrue: [ ^ self ].
	aBoard moveShip: aShip steps: aShip lastRoll
]

{ #category : 'as yet unclassified' }
HyperGravityCell >> initializeWithRequiredRoll: aNumber [

	super initialize.
	requiredRoll := aNumber
]
