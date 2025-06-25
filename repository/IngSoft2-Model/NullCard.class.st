Class {
	#name : 'NullCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
NullCard >> verifyCanBePlayedBy: aSpaceship with: aTurnManager [ 
	Error signal: 'There is no card to redo'

]
