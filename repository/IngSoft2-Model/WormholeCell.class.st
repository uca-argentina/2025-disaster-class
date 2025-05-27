Class {
	#name : #WormholeCell,
	#superclass : #Cell,
	#instVars : [
		'linkedCell'
	],
	#category : 'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
WormholeCell class >> newPairIn: aBoard at: firstPosition and: secondPosition [ 
	| aWormhole anotherWormhole |
	aWormhole := self new.
	anotherWormhole := self new.

	aWormhole linkWith: anotherWormhole.
	anotherWormhole linkWith: aWormhole.

	aBoard at: firstPosition put: aWormhole.
	aBoard at: secondPosition put: anotherWormhole.
]

{ #category : #'as yet unclassified' }
WormholeCell >> applyEffectTo: aShip in: aBoard [

	| currentCell |
	currentCell := aBoard cellContaining: aShip.
	currentCell leaves: aShip.
	linkedCell enters: aShip
]

{ #category : #'as yet unclassified' }
WormholeCell >> linkWith: anotherWormholeCell [

	linkedCell := anotherWormholeCell
]
