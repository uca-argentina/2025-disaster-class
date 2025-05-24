Class {
	#name : #Board,
	#superclass : #Object,
	#instVars : [
		'map'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Board class >> with: aNumberOfCells [ 
	^self new initializeWith: aNumberOfCells. 
]

{ #category : #'as yet unclassified' }
Board >> applyEffectTo: aShip [

	| cell |
	cell := self cellContaining: aShip.
	cell applyEffectTo: aShip in: self
]

{ #category : #'as yet unclassified' }
Board >> cellAt: aPosition [
	^ map at: aPosition.
]

{ #category : #'as yet unclassified' }
Board >> cellContaining: aShip [

	^ map detect: [ :each | each includes: aShip ]
]

{ #category : #'as yet unclassified' }
Board >> firstCell [
	^ map first
]

{ #category : #'as yet unclassified' }
Board >> indexOfCellContaining: aShip [
	^ map indexOf: (self cellContaining: aShip).
]

{ #category : #initialization }
Board >> initializeWith: aNumberOfCells [

	map := OrderedCollection new: aNumberOfCells.
	1 to: aNumberOfCells do: [ :i |
	map add: (RegularCell with: OrderedCollection new) ]
]

{ #category : #'as yet unclassified' }
Board >> lastCell [
	^ map last.
]

{ #category : #'as yet unclassified' }
Board >> placeAllShipsAtStart: someShips [

	(map at: 1) entersAll: someShips
]

{ #category : #'as yet unclassified' }
Board >> size [
	^ map size.
]
