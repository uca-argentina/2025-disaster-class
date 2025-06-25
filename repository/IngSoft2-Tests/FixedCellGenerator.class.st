Class {
	#name : 'FixedCellGenerator',
	#superclass : 'Object',
	#instVars : [
		'cellsToGenerate'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'as yet unclassified' }
FixedCellGenerator class >> cells: someCellsToGenerate [ 

	^ self new initializeWith: someCellsToGenerate

]

{ #category : 'as yet unclassified' }
FixedCellGenerator class >> withAllRegularCellAmount: aNormalCellLength [ 

	| cells |
	cells := OrderedCollection new.
	1 to: aNormalCellLength do: [ :index | cells add: RegularCell new ].
	^ self cells: cells
]

{ #category : 'translating' }
FixedCellGenerator >> generate [

	^ cellsToGenerate
]

{ #category : 'translating' }
FixedCellGenerator >> initializeWith: someCells [

	cellsToGenerate := someCells.
	^ self
]
