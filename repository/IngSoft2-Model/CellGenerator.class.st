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

	| probabilitiesSum |
	probabilitiesSum := (someProbabilities collect: [ :eachProbability |
		                     eachProbability first ]) sum.
	probabilitiesSum ~= 1 ifTrue: [
		Error signal: 'probabilities should sum one in total' ]
]

{ #category : 'as yet unclassified' }
CellGenerator class >> withCellCount: aNumberOfCells andDistribution: aDistribution [

	self verifyValidityOf: aDistribution.
	^ self new
		  initializeWith: aNumberOfCells
		  and: aDistribution
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
CellGenerator >> initializeWith: aNumberOfCells and: aDistribution [

	| rangeAcummulator aCellCreation cellRate aRangeStart |
	rangeAcummulator := 0.
	numberOfCells := aNumberOfCells.
	cellProbabilities := aDistribution collect: [ :eachProbability |
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
