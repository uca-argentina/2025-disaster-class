Class {
	#name : 'NullShip',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
NullShip >> applyPenaltyIn: gameboard [

	^ self
]

{ #category : 'accessing' }
NullShip >> consumeFuel: anAmountOfFuel [ 

	^ 0
]

{ #category : 'as yet unclassified' }
NullShip >> refuel [ 

	^ self

]

{ #category : 'accessing' }
NullShip >> takeFuel: anAmountOfFuel [ 

	^ 0
]
