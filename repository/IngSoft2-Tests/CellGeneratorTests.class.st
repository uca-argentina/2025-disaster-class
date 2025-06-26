Class {
	#name : 'CellGeneratorTests',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
CellGeneratorTests >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
CellGeneratorTests >> test001IfGeneratorCreatesRequestedAmountOfCellsThenIsValid [

	| generator cells aDistribution |
	aDistribution := OrderedCollection with: {
			                 1.
			                 [ RegularCell new ] }.
	generator := CellGenerator
		             withCellCount: 10
		             andDistribution: aDistribution.

	cells := generator generate.

	self assert: cells size equals: 10.
	self assert:
		(cells allSatisfy: [ :cell | cell isKindOf: RegularCell ])
]

{ #category : 'tests' }
CellGeneratorTests >> test002IfProbabilitiesDoNotSumToOneThenFails [

	| aDistribution |
	aDistribution := OrderedCollection with: {
			                 1.1.
			                 [ RegularCell new ] }.

	self
		should: [
		CellGenerator withCellCount: 10 andDistribution: aDistribution ]
		raise: Error
		withMessageText: 'probabilities should sum one in total'
]

{ #category : 'tests' }
CellGeneratorTests >> test003CustomDistributionGeneratesExpectedCellCounts [

	| cells counts aDistribution aGenerator |
	aDistribution := OrderedCollection
		                 with: {
				                 0.4.
				                 [ RegularCell new ] }
		                 with: {
				                 0.2.
				                 [ BlackHoleCell new ] }
		                 with: {
				                 0.2.
				                 [ HyperGravityCell requiringMinimumRoll: 2 ] }
		                 with: {
				                 0.1.
				                 [ MoonWalkCell withSteps: 3 ] }
		                 with: {
				                 0.08.
				                 [
				                 HyperJumpCell withLengths: {
						                 2 parsecs.
						                 5 parsecs.
						                 7 parsecs } ] }
		                 with: {
				                 0.02.
				                 [ AtomicBombCell new ] }.

	aGenerator := CellGenerator
		              withCellCount: 1000
		              andDistribution: aDistribution.

	cells := aGenerator generate.

	counts := Dictionary new.
	cells do: [ :cell |
		counts
			at: cell class
			put: (counts at: cell class ifAbsent: [ 0 ]) + 1 ].

	self assert: ((counts at: RegularCell) between: 350 and: 450).
	self assert: ((counts at: BlackHoleCell) between: 150 and: 250).
	self assert: ((counts at: HyperGravityCell) between: 150 and: 250).
	self assert: ((counts at: MoonWalkCell) between: 50 and: 150).
	self assert: ((counts at: HyperJumpCell) between: 40 and: 120).
	self assert: ((counts at: AtomicBombCell) between: 10 and: 30)
]
