Class {
	#name : 'Position',
	#superclass : 'Object',
	#instVars : [
		'laps',
		'cell'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Position class >> laps: lapsAmount cell: currentCell [

	^ self new initializeWithLaps: lapsAmount withCell: currentCell
]

{ #category : 'initialization' }
Position >> >= aPosition [

	^ laps > aPosition laps or: [
		  laps = aPosition laps and: [ cell >= aPosition cell ] ]
]

{ #category : 'initialization' }
Position >> cell [

	^ cell
]

{ #category : 'initialization' }
Position >> initializeWithLaps: lapsAmount withCell: currentCell [

	laps := lapsAmount.
	cell := currentCell
]

{ #category : 'initialization' }
Position >> laps [

	^ laps
]
