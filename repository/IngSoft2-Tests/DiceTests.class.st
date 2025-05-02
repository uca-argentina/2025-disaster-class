Class {
	#name : 'DiceTests',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
DiceTests >> testA [

	| aNumberOfSides aDice |
	aNumberOfSides := 5.
	aDice := Dice with: aNumberOfSides.
	
	self assert: aDice sides = aNumberOfSides
]
