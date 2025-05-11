Class {
	#name : 'Cell',
	#superclass : 'Object',
	#instVars : [
		'shipContainer'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Cell >> enters: aShip [
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
Cell >> getShips [
	^shipContainer.
]

{ #category : 'testing' }
Cell >> includes: aShip [ 
	^shipContainer includes: aShip .
]

{ #category : 'testing' }
Cell >> includesAll: aCollectionOfShips [

	^ aCollectionOfShips allSatisfy: [ :ship |
		  shipContainer includes: ship ]
]

{ #category : 'initialization' }
Cell >> initializeWith: aShipContainer [ 
	shipContainer := aShipContainer.
]

{ #category : 'accessing' }
Cell >> leaves: aShip [ 
	shipContainer remove: aShip
]
