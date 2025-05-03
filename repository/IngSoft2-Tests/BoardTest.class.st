Class {
	#name : 'BoardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'as yet unclassified' }
BoardTest >> testIfCreatedMapIsSizeOfAllocatedValueThenIsValid [

	| aNumberOfCells aBoard |
	aNumberOfCells := 20.
	aBoard := Board with: aNumberOfCells.
	self assert: aBoard getMap size equals: aNumberOfCells
]
