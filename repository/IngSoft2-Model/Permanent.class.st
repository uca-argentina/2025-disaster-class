Class {
	#name : 'Permanent',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'removing' }
Permanent >> removeEffectsWith: aCardManager [ 
	self subclassResponsibility
]

{ #category : 'removing' }
Permanent >> verifyCanBePlayedBy: aSpaceship with: aTurnManager [ 

	aSpaceship = aTurnManager currentTurnsShip ifFalse: [
		Error signal: 'You can only play this card when its your turn' ].
]
