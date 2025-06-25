Class {
	#name : 'Acceleration',
	#superclass : 'Permanent',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Acceleration >> removeEffectsWith: aCardEnforcer [

	aCardEnforcer removeAccelerationEffect
]

{ #category : 'as yet unclassified' }
Acceleration >> use: aCardEnforcer from: cardThrower target: aTarget [

	aCardEnforcer applyAccelerationEffect.
	aCardEnforcer addActiveCardEffect: self
]
