Class {
	#name : 'Cancellation',
	#superclass : 'Instantaneous',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Cancellation >> use: aCardEnforcer from: cardThrower target: aTarget [

	aCardEnforcer disableCardEffect: aTarget
]
