Class {
	#name : 'Overload',
	#superclass : 'Permanent',
	#instVars : [
		'overloadedShip'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Overload >> removeEffectsWith: aCardEnforcer [

	overloadedShip changeDiceAdjustmentBy: 2
]

{ #category : 'as yet unclassified' }
Overload >> use: aCardEnforcer from: cardThrower target: aTarget [

	overloadedShip := aCardEnforcer findShip: aTarget.
	aCardEnforcer applyOverloadEffectTo: overloadedShip.
	aCardEnforcer addActiveCardEffect: self
]
