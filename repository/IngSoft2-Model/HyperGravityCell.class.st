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
    self applyEffectTo: aShip in: aBoard withRoll: 3.

]

{ #category : 'as yet unclassified' }
HyperGravityCell >> applyEffectTo: aShip in: aBoard withRoll: aRoll [
    aRoll < requiredRoll ifTrue: [ ^ self ].  
    aShip attemptMoveBy: aRoll in: aBoard.
]

{ #category : 'as yet unclassified' }
HyperGravityCell >> initializeWithRequiredRoll: aNumber [

	super initialize.
	requiredRoll := aNumber
]
