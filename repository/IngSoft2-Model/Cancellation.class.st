Class {
	#name : 'Cancellation',
	#superclass : 'Instantaneous',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Cancellation >> use: aCardManager from: cardThrower target: aTarget [ 
	aCardManager disableCardEffect: aTarget
]
