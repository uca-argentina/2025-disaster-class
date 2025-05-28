Class {
	#name : 'DefaultCellGeneratorTests',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
DefaultCellGeneratorTests >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
DefaultCellGeneratorTests >> test001IfGeneratorCreatesRequestedAmountOfCellsThenIsValid [

	| generator cells |
	generator := DefaultCellGenerator withDistributions:
		             { ([ RegularCell new] -> 1.0) }.

	cells := generator generateCells: 10.

	self assert: cells size equals: 10.
	self assert:
		(cells allSatisfy: [ :cell | cell isKindOf: RegularCell ])
]

{ #category : 'tests' }
DefaultCellGeneratorTests >> test002IfGeneratorCanCreateWormholeCellsThenIsValid [ 
	| generator cells |
	generator := DefaultCellGenerator withDistributions: {
		([ WormholeCell new ] -> 1.0)
	}.

	cells := generator generateCells: 10.

	self assert: cells size equals: 10.
	self assert: (cells allSatisfy: [ :cell | cell isKindOf: WormholeCell ]).

]

{ #category : 'tests' }
DefaultCellGeneratorTests >> test003IfProbabilitiesDoNotSumToOneThenFails [

	self
		should: [
			DefaultCellGenerator withDistributions: {
					([ RegularCell with: OrderedCollection new ] -> 0.8).
					([ WormholeCell new ] -> 0.3) } ]
		raise: Error
		withMessageText: 'The sum of probabilities must equal 1'
]

{ #category : 'tests' }
DefaultCellGeneratorTests >> test004CustomDistributionGeneratesExpectedCellCounts [ 
    | generator cells counts totalCells |

    generator := DefaultCellGenerator withDistributions: {
        ([ RegularCell new ] -> 0.4).
        ([ BlackHoleCell new ] -> 0.2).
        ([ HyperGravityCell requiringMinimumRoll: 2 ] -> 0.2).
        ([ MoonWalkCell withSteps: 3 ] -> 0.1).
        ([ HyperJumpCell withParsecList: #(100 50 20) totalParsecs: 100 ] -> 0.08).
        ([ AtomicBombCell new ] -> 0.02)
    }.

    totalCells := 1000.
    cells := generator generateCells: totalCells.

    counts := Dictionary new.
    cells do: [ :cell |
        counts at: cell class put: ((counts at: cell class ifAbsent: [ 0 ]) + 1)
    ].

    self assert: ((counts at: RegularCell) between: 350 and: 450).
    self assert: ((counts at: BlackHoleCell) between: 150 and: 250).
    self assert: ((counts at: HyperGravityCell) between: 150 and: 250).
    self assert: ((counts at: MoonWalkCell) between: 50 and: 150).
    self assert: ((counts at: HyperJumpCell) between: 40 and: 120).
    self assert: ((counts at: AtomicBombCell) between: 10 and: 30).


]

{ #category : 'tests' }
DefaultCellGeneratorTests >> test005DefaultDistributionGeneratesExpectedCellCounts [ 
    | generator cells counts totalCells |

    generator := DefaultCellGenerator defaultDistributions .

    totalCells := 1000.
    cells := generator generateCells: totalCells.

    counts := Dictionary new.
    cells do: [ :cell |
        counts at: cell class put: ((counts at: cell class ifAbsent: [ 0 ]) + 1)
    ].

    self assert: ((counts at: RegularCell) between: 350 and: 450).
    self assert: ((counts at: BlackHoleCell) between: 150 and: 250).
    self assert: ((counts at: HyperGravityCell) between: 150 and: 250).
    self assert: ((counts at: MoonWalkCell) between: 50 and: 150).
    self assert: ((counts at: HyperJumpCell) between: 40 and: 120).
    self assert: ((counts at: AtomicBombCell) between: 10 and: 30).


]
