Class {
	#name : 'Card',
	#superclass : 'Object',
	#instVars : [
		'ships',
		'name'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Card >> use: aCardManager from: cardThrower target: aTarget [ 
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
Card >> verifyCanBePlayedBy: aSpaceship with: aTurnManager [ 
	self subclassResponsibility
]
