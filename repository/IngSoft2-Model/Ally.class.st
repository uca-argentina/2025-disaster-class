Class {
	#name : 'Ally',
	#superclass : 'Permanent',
	#instVars : [
		'primaryAlly',
		'secondaryAlly'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
Ally >> initialize [ 
	primaryAlly := NullShip new.
	secondaryAlly := NullShip new.

]

{ #category : 'initialization' }
Ally >> removeEffectsWith: aCardEnforcer [ 

	primaryAlly allyWith: NullShip new.
	secondaryAlly allyWith: NullShip new.


]

{ #category : 'initialization' }
Ally >> use: aCardEnforcer from: aShip target: aTarget [ 

	| anotherShip |
	anotherShip := aCardEnforcer findShip: aTarget.

	aCardEnforcer createAlliance: anotherShip.

	primaryAlly := aShip.
	secondaryAlly := anotherShip.
	
	aCardEnforcer addActiveCardEffect: self
]
