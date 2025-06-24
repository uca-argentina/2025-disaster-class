Class {
	#name : 'CardCell',
	#superclass : 'Cell',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
CardCell >> applyEffectTo: aShip in: aBoard [

	aShip giveCard: aBoard possibleCards atRandom
]
