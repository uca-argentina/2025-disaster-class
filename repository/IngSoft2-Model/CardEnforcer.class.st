Class {
	#name : 'CardEnforcer',
	#superclass : 'Object',
	#instVars : [
		'ships',
		'board',
		'activeCards'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
CardEnforcer class >> withShips: someShips withBoard: aBoard [
	^ self new initializeWithShips: someShips withBoard: aBoard
]

{ #category : 'initialization' }
CardEnforcer >> addActiveCardEffect: aCard [ [
	activeCards add: aCard
]

]

{ #category : 'as yet unclassified' }
CardEnforcer >> apply: aCard from: aShipName to: aTargetName [

	| sourceShip |
	sourceShip := ships
		              detect: [ :ship | ship name = aShipName ]
		              ifNone: [
		              Error signal:
			              'No ship found with name: ' , aShipName asString ].


	aCard applyEffectFrom: sourceShip to: aTargetName inShips: ships.

	(aCard isKindOf: Permanent) ifTrue: [ activeCards add: aCard ]
]

{ #category : 'initialization' }
CardEnforcer >> applyAccelerationEffect [ 
	ships do: [ :ship |
		ship changeTotalThrowBy: 1 ]

]

{ #category : 'initialization' }
CardEnforcer >> initializeWithShips: someShips withBoard: aBoard [
	ships := someShips.
	board := aBoard.
	activeCards := OrderedCollection new.
]
