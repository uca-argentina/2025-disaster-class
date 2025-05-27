Class {
	#name : #DefaultCellGenerator,
	#superclass : #Object,
	#instVars : [
		'distribution'
	],
	#category : 'IngSoft2-Model'
}

{ #category : #'as yet unclassified' }
DefaultCellGenerator class >> validateProbabilities: aBlockToProbabilityCollection [

	(aBlockToProbabilityCollection collect: [ :each | each value ]) sum
	= 1 ifFalse: [ Error signal: 'The sum of probabilities must equal 1' ]
]

{ #category : #'as yet unclassified' }
DefaultCellGenerator class >> withDistributions: aBlockToProbabilityCollection [

	self validateProbabilities: aBlockToProbabilityCollection.
	^ self new initializeWith: aBlockToProbabilityCollection
]

{ #category : #initialization }
DefaultCellGenerator >> cellCollection: amount with: aBlock [

	| collection |
	collection := OrderedCollection new.
	amount timesRepeat: [ collection add: aBlock value ].
	^ collection
]

{ #category : #initialization }
DefaultCellGenerator >> generateCells: anAmountOfCells [

	| cellPool cells |
	cellPool := distribution collect: [ :each |
		            self
			            cellCollection: (each value * 100) asInteger
			            with: each key ].
	cellPool := cellPool flattened.

	cells := OrderedCollection new.
	anAmountOfCells timesRepeat: [ cells add: cellPool atRandom ].

	^ cells
]

{ #category : #initialization }
DefaultCellGenerator >> initializeWith: aBlockToProbabilityCollection [

	distribution := aBlockToProbabilityCollection
]

{ #category : #initialization }
DefaultCellGenerator >> validateProbabilities [

	distribution values sum = 1 ifFalse: [
		Error signal: 'Probabilities must sum to 1' ]
]
