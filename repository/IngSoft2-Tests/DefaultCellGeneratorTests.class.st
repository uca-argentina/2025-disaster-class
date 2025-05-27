Class {
	#name : #DefaultCellGeneratorTests,
	#superclass : #TestCase,
	#category : 'IngSoft2-Tests'
}

{ #category : #tests }
DefaultCellGeneratorTests >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: errorMessage ]
]

{ #category : #tests }
DefaultCellGeneratorTests >> test001IfGeneratorCreatesRequestedAmountOfCellsThenIsValid [

	| generator cells |
	generator := DefaultCellGenerator withDistributions:
		             { ([ RegularCell new] -> 1.0) }.

	cells := generator generateCells: 10.

	self assert: cells size equals: 10.
	self assert:
		(cells allSatisfy: [ :cell | cell isKindOf: RegularCell ])
]

{ #category : #tests }
DefaultCellGeneratorTests >> test002IfGeneratorCanCreateWormholeCellsThenIsValid [ 
	| generator cells |
	generator := DefaultCellGenerator withDistributions: {
		([ WormholeCell new ] -> 1.0)
	}.

	cells := generator generateCells: 10.

	self assert: cells size equals: 10.
	self assert: (cells allSatisfy: [ :cell | cell isKindOf: WormholeCell ]).

]

{ #category : #tests }
DefaultCellGeneratorTests >> test003IfProbabilitiesDoNotSumToOneThenFails [

	self
		should: [
			DefaultCellGenerator withDistributions: {
					([ RegularCell with: OrderedCollection new ] -> 0.8).
					([ WormholeCell new ] -> 0.3) } ]
		raise: Error
		withMessageText: 'The sum of probabilities must equal 1'
]
