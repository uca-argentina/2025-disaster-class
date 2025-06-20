Class {
	#name : 'CellGenerator',
	#superclass : 'Object',
	#instVars : [
		'distribution',
		'numberOfCells',
		'cellProbabilities'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
CellGenerator class >> verifyValidityOf: someProbabilities [

	(someProbabilities collect: [ :each | each value ]) sum
	= 1 ifFalse: [ Error signal: 'The sum of probabilities must equal 1' ]
]

{ #category : 'as yet unclassified' }
CellGenerator class >> withCellCount: aNumberOfCells andDistribution: someProbabilities [

	self verifyValidityOf: someProbabilities.
	^ self new
		  initializeWith: aNumberOfCells
		  and: someProbabilities
]

{ #category : 'as yet unclassified' }
CellGenerator class >> withDistributions: someProbabilities [

	self verifyValidityOf: someProbabilities.
	^ self new initializeWith: someProbabilities
]

{ #category : 'initialization' }
CellGenerator >> cellCollection: amount with: aBlock [

	| collection |
	collection := OrderedCollection new.
	amount timesRepeat: [ collection add: aBlock value ].
	^ collection
]

{ #category : 'initialization' }
CellGenerator >> generate [

	| cells random seed |
	seed := Random new.
	cells := OrderedCollection new.
	1 to: numberOfCells do: [ :index |
		random := seed next.
		cellProbabilities do: [ :eachCellProbability |
			eachCellProbability addCellTo: cells ifIsInRange: random ] ].
	^ cells
]

{ #category : 'initialization' }
CellGenerator >> generateCells: anAmountOfCells [

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

{ #category : 'initialization' }
CellGenerator >> initializeWith: aBlockToProbabilityCollection [

	distribution := aBlockToProbabilityCollection
]

{ #category : 'initialization' }
CellGenerator >> initializeWith: aNumberOfCells probabilities: someProbabilities [

	| rangeAcummulator aCellCreation cellRate aRangeStart |
	rangeAcummulator := 0.
	numberOfCells := aNumberOfCells.
	cellProbabilities := someProbabilities collect: [ :eachProbability |
		                     cellRate := eachProbability first.
		                     aCellCreation := eachProbability second.
		                     aRangeStart := rangeAcummulator.
		                     rangeAcummulator := rangeAcummulator + cellRate.

		                     CellProbability
			                     cellCreation: aCellCreation
			                     rangeStart: aRangeStart
			                     rangeEnd: rangeAcummulator ].
	^ self
]

{ #category : 'initialization' }
CellGenerator >> validateProbabilities [

	distribution values sum = 1 ifFalse: [
		Error signal: 'Probabilities must sum to 1' ]
]
