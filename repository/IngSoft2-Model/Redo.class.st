Class {
	#name : 'Redo',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Redo >> lastUsedCard: aCard [ 
	^ aCard

]

{ #category : 'as yet unclassified' }
Redo >> use: aCardManager from: cardThrower target: aTarget [ 
	aCardManager redoLastCardFrom: cardThrower target: aTarget

]

{ #category : 'as yet unclassified' }
Redo >> verifyCanBePlayedBy: aSpaceship with: aTurnManager [ 
	^ self
]
