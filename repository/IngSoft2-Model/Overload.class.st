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
	overloadedShip changeTotalThrowBy: 2

]

{ #category : 'as yet unclassified' }
Overload >> use: aCardManager from: cardThrower target: aTarget [ 
	overloadedShip := aCardManager shipNamed: aTarget.
	aCardManager applyOverloadEffectTo: overloadedShip.
	aCardManager addActiveCard: self

]
