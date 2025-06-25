Class {
	#name : 'Repeat',
	#superclass : 'Instantaneous',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Repeat >> use: aCardEnforcer from: aShip target: aTarget [ 

	| ship |
	ship := aCardEnforcer findShip: aTarget.
	aCardEnforcer applyLastCardEffectTo: ship
]
