Class {
	#name : 'MoonWalkCell',
	#superclass : 'Cell',
	#instVars : [
		'stepsBack'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
MoonWalkCell class >> withSteps: n [
    ^ self new initializeWithSteps: n
]

{ #category : 'as yet unclassified' }
MoonWalkCell >> applyEffectTo: aShip in: aBoard [
    | allOtherShips |
    
    allOtherShips := aBoard ships reject: [ :each | each = aShip ].

    allOtherShips do: [ :ship |
        ship attemptMoveBy: stepsBack negated in: aBoard ].
]

{ #category : 'as yet unclassified' }
MoonWalkCell >> initializeWithSteps: n [

	super initialize.
	stepsBack := n
]
