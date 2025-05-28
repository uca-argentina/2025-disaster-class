Class {
	#name : 'BlackHoleCell',
	#superclass : 'Cell',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
BlackHoleCell >> applyEffectTo: aShip in: aBoard [
    aShip attemptMoveBy: -4 in: aBoard.
]
